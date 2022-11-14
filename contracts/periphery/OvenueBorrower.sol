// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "../libraries/OvenueConfigHelper.sol";
import "../interfaces/IV2OvenueCreditLine.sol";
import "../interfaces/IOvenueConfig.sol";
import "../interfaces/IERC20withDec.sol";
import "../interfaces/IOvenueJuniorPool.sol";
import "../interfaces/IOvenueBorrower.sol";
import "../upgradeable/BaseUpgradeablePausable.sol";

// import "../../external/BaseRelayRecipient.sol";

/**
 * @title Ovenue's Borrower contract
 * @notice These   with Goldfinch
 *  They are 100% optional. However, they let us add many sophisticated and convient features for borrowers
 *  while still keeping our core protocol small and secure. We therefore expect most borrowers will use them.
 *  This contract is the "official" borrower contract that will be maintained by Goldfinch governance. However,
 *  in theory, anyone can fork or create their own version, or not use any contract at all. The core functionality
 *  is completely agnostic to whether it is interacting with a contract or an externally owned account (EOA).
 * @author Ovenue
 */

contract OvenueBorrower is BaseUpgradeablePausable, IOvenueBorrower {
    IOvenueConfig public config;
    using OvenueConfigHelper for IOvenueConfig;
    
    function initialize(address owner, address protocol, address _config)
        external
        override
        initializer
    {
        require(
            owner != address(0) && protocol != address(0) && _config != address(0),
            "Owner and config addresses cannot be empty"
        );
        __BaseUpgradeablePausable__init(owner);
        _setupRole(OWNER_ROLE, protocol);

        config = IOvenueConfig(_config);
        // IERC20withDec usdc = config.getUSDC();
        // usdc.approve(oneInch, type(uint256).max);
    }

    // function cancel(address poolAddress, address addressToSendTo) external onlyAdmin {
    //     IOvenueJuniorPool pool = IOvenueJuniorPool(poolAddress);
    //     IOvenueCollateralCustody custody = config.getCollateralCustody();

    //     pool.cancelAfterLockingCapital();
    //     custody.redeemAllCollateral(
    //         pool,
    //         addressToSendTo
    //     );
    // }

    function lockCollateralToken(address _poolAddress, uint256 _amount) external onlyAdmin {
        config.getCollateralCustody().collectFungibleCollateral(
            IOvenueJuniorPool(_poolAddress),
            msg.sender,
            _amount
        );
    }

    function lockJuniorCapital(address poolAddress) external onlyAdmin {
        IOvenueJuniorPool pool = IOvenueJuniorPool(poolAddress);
        require(config.getCollateralCustody().isCollateralFullyFunded(pool), "Already redeem collateral!");
        IOvenueJuniorPool(poolAddress).lockJuniorCapital();
    }

    function lockPool(address poolAddress) external onlyAdmin {
        IOvenueJuniorPool(poolAddress).lockPool();
    }

    function redeemCollateral(
        address poolAddress, 
        address addressToSendTo
    ) external onlyAdmin {
        IOvenueJuniorPool pool = IOvenueJuniorPool(poolAddress);
        IV2OvenueCreditLine creditLine = pool.creditLine();
        IOvenueCollateralCustody custody = config.getCollateralCustody();

        bool ableToRedeem;

        if (creditLine.termEndTime() == 0) {
            ableToRedeem = true;
        } else {
            uint loanBalance = creditLine.balance();

            if (loanBalance > 0) {
                pool.assess();
            }

            uint totalOwned = creditLine.interestOwed() + creditLine.principalOwed();
        
            if (totalOwned == 0 && loanBalance == 0) {
                ableToRedeem = true;
            }
        }

        require(ableToRedeem, "Not eligible to claim collateral!");

        pool.cancel();
        custody.redeemAllCollateral(
            pool,
            addressToSendTo
        );
    }

    /**
     * @notice Allows a borrower to drawdown on their credit line through a TranchedPool.
     * @param poolAddress The creditline from which they would like to drawdown
     * @param amount The amount, in USDC atomic units, that a borrower wishes to drawdown
     * @param addressToSendTo The address where they would like the funds sent. If the zero address is passed,
     *  it will be defaulted to the contracts address (msg.sender). This is a convenience feature for when they would
     *  like the funds sent to an exchange or alternate wallet, different from the authentication address
     */
    function drawdown(
        address poolAddress,
        uint256 amount,
        address addressToSendTo
    ) external onlyAdmin {
        IOvenueJuniorPool(poolAddress).drawdown(amount);

        if (addressToSendTo == address(0) || addressToSendTo == address(this)) {
            addressToSendTo = msg.sender;
        }

        transferERC20(config.usdcAddress(), addressToSendTo, amount);
    }

    function transferERC20(
        address token,
        address to,
        uint256 amount
    ) public onlyAdmin {
        bytes memory _data = abi.encodeWithSignature(
            "transfer(address,uint256)",
            to,
            amount
        );
        _invoke(token, _data);
    }

    /**
     * @notice Allows a borrower to pay back loans by calling the `pay` function directly on a TranchedPool
     * @param poolAddress The credit line to be paid back
     * @param amount The amount, in USDC atomic units, that the borrower wishes to pay
     */
    function pay(address poolAddress, uint256 amount) external onlyAdmin {
        IERC20withDec usdc = config.getUSDC();
        bool success = usdc.transferFrom(msg.sender, address(this), amount);
        require(success, "Failed to transfer USDC");
        _transferAndPay(usdc, poolAddress, amount);
    }

    function payMultiple(address[] calldata pools, uint256[] calldata amounts)
        external
        onlyAdmin
    {
        require(
            pools.length == amounts.length,
            "Pools and amounts must be the same length"
        );

        uint256 totalAmount;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmount = totalAmount + amounts[i];
        }

        IERC20withDec usdc = config.getUSDC();
        // Do a single transfer, which is cheaper
        bool success = usdc.transferFrom(
            msg.sender,
            address(this),
            totalAmount
        );
        require(success, "Failed to transfer USDC");

        for (uint256 i = 0; i < amounts.length; i++) {
            _transferAndPay(usdc, pools[i], amounts[i]);
        }
    }

    function payInFull(address poolAddress, uint256 amount) external onlyAdmin {
        IERC20withDec usdc = config.getUSDC();
        bool success = usdc.transferFrom(msg.sender, address(this), amount);
        require(success, "Failed to transfer USDC");

        _transferAndPay(usdc, poolAddress, amount);
        require(
            IOvenueJuniorPool(poolAddress).creditLine().balance() == 0,
            "Failed to fully pay off creditline"
        );
    }

    function _transferAndPay(
        IERC20withDec usdc,
        address poolAddress,
        uint256 amount
    ) internal {
        IOvenueJuniorPool pool = IOvenueJuniorPool(poolAddress);
        // We don't use transferFrom since it would require a separate approval per creditline
        bool success = usdc.transfer(address(pool.creditLine()), amount);
        require(success, "USDC Transfer to creditline failed");
        pool.assess();
    }

    function transferFrom(
        address erc20,
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        bytes memory _data;
        // Do a low-level _invoke on this transfer, since Tether fails if we use the normal IERC20 interface
        _data = abi.encodeWithSignature(
            "transferFrom(address,address,uint256)",
            sender,
            recipient,
            amount
        );
        _invoke(address(erc20), _data);
    }

    /**
     * @notice Performs a generic transaction.
     * @param _target The address for the transaction.
     * @param _data The data of the transaction.
     * Mostly copied from Argent:
     * https://github.com/argentlabs/argent-contracts/blob/develop/contracts/wallet/BaseWallet.sol#L111
     */
    function _invoke(address _target, bytes memory _data)
        internal
        returns (bytes memory)
    {
        // External contracts can be compiled with different Solidity versions
        // which can cause "revert without reason" when called through,
        // for example, a standard IERC20 ABI compiled on the latest version.
        // This low-level call avoids that issue.

        bool success;
        bytes memory _res;
        // solhint-disable-next-line avoid-low-level-calls
        (success, _res) = _target.call(_data);
        if (!success && _res.length > 0) {
            // solhint-disable-next-line no-inline-assembly
            assembly {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        } else if (!success) {
            revert("VM: wallet _invoke reverted");
        }
        return _res;
    }

    function _toUint256(bytes memory _bytes)
        internal
        pure
        returns (uint256 value)
    {
        assembly {
            value := mload(add(_bytes, 0x20))
        }
    }

    // function onERC721Received(
    //     address operator,
    //     address from,
    //     uint256 tokenId,
    //     bytes calldata data
    // ) external override pure returns (bytes4) {
    //     return IERC721Receiver.onERC721Received.selector;
    // }
}
