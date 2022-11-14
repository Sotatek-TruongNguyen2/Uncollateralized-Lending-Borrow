// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../libraries/Math.sol";

import {IOvenueJuniorPool} from "../interfaces/IOvenueJuniorPool.sol";
import {IRequiresUID} from "../interfaces/IRequiresUID.sol";
import {IERC20withDec} from "../interfaces/IERC20withDec.sol";
import {IV2OvenueCreditLine} from "../interfaces/IV2OvenueCreditLine.sol";
import {IOvenueJuniorLP} from "../interfaces/IOvenueJuniorLP.sol";
import {IOvenueConfig} from "../interfaces/IOvenueConfig.sol";
import {BaseUpgradeablePausable} from "../upgradeable/BaseUpgradeablePausable.sol";
import {OvenueConfigHelper} from "../libraries/OvenueConfigHelper.sol";
import {OvenueTranchingLogic} from "../libraries/OvenueTranchingLogic.sol";
import {OvenueJuniorPoolLogic} from "../libraries/OvenueJuniorPoolLogic.sol";

contract OvenueJuniorPool is
    BaseUpgradeablePausable,
    IRequiresUID,
    IOvenueJuniorPool
{
    error PoolNotPure();
    error PoolAlreadyCancelled();
    error NFTCollateralNotLocked();
    error CreditLineBalanceExisted(uint256 balance);
    error AddressZeroInitialization();
    error JuniorTranchAlreadyLocked();
    error PoolNotOpened();
    error InvalidDepositAmount(uint256 amount);
    error AllowedUIDNotGranted(address sender);
    error DrawnDownPaused();
    error UnauthorizedCaller();
    error UnmatchedArraysLength();
    error PoolBalanceNotEmpty();
    error NotFullyCollateral();

    IOvenueConfig public config;
    using OvenueConfigHelper for IOvenueConfig;

    // // Events ////////////////////////////////////////////////////////////////////

    event PoolCancelled();
    event DrawdownsToggled(address indexed pool, bool isAllowed);
    // event TrancheLocked(
    //     address indexed pool,
    //     uint256 trancheId,
    //     uint256 lockedUntil
    // );

    bytes32 public constant LOCKER_ROLE = keccak256("LOCKER_ROLE");
    bytes32 public constant SENIOR_ROLE = keccak256("SENIOR_ROLE");
    // uint8 internal constant MAJOR_VERSION = 0;
    // uint8 internal constant MINOR_VERSION = 1;
    // uint8 internal constant PATCH_VERSION = 0;

    bool public cancelled;
    bool public drawdownsPaused;

    uint256 public juniorFeePercent;
    uint256 public totalDeployed;
    uint256 public fundableAt;
    uint256 public override numSlices;

    uint256[] public allowedUIDTypes;

    mapping(uint256 => PoolSlice) internal _poolSlices;

    function initialize(
        // config - borrower
        address[2] calldata _addresses,
        // junior fee percent - late fee apr, interest apr
        uint256[3] calldata _fees,
        // _paymentPeriodInDays - _termInDays - _principalGracePeriodInDays - _fundableAt
        uint256[4] calldata _days,
        uint256 _limit,
        uint256[] calldata _allowedUIDTypes
    ) external override initializer {
        if (
            !(address(_addresses[0]) != address(0) &&
                address(_addresses[1]) != address(0))
        ) {
            revert AddressZeroInitialization();
        }

     
        config = IOvenueConfig(_addresses[0]);

        address owner = config.protocolAdminAddress();
        __BaseUpgradeablePausable__init(owner);
        

        (numSlices, creditLine) = OvenueJuniorPoolLogic.initialize(
            _poolSlices,
            numSlices,
            config,
            _addresses[1],
            _fees,
            _days,
            _limit
        );

        if (_allowedUIDTypes.length == 0) {
            uint256[1] memory defaultAllowedUIDTypes = [
                config.getGo().ID_TYPE_0()
            ];
            allowedUIDTypes = defaultAllowedUIDTypes;
        } else {
            allowedUIDTypes = _allowedUIDTypes;
        }

        createdAt = block.timestamp;
        fundableAt = _days[3];
        juniorFeePercent = _fees[0];

        _setupRole(LOCKER_ROLE, _addresses[1]);
        _setupRole(LOCKER_ROLE, owner);
        _setRoleAdmin(LOCKER_ROLE, OWNER_ROLE);
        _setRoleAdmin(SENIOR_ROLE, OWNER_ROLE);

        // Give the senior pool the ability to deposit into the senior pool
        _setupRole(SENIOR_ROLE, address(config.getSeniorPool()));

        // Unlock self for infinite amount
        require(config.getUSDC().approve(address(this), type(uint256).max));
    }

    // function cancelAfterLockingCapital() external override onlyLocker NotCancelled {
    //     /// @dev TL: check if borrower is borrow or not
    //     if (creditLine.termEndTime() != 0) {
    //         revert PoolNotPure();
    //     }

    //     // Set pool status
    //     cancel();
    // }

    function setAllowedUIDTypes(uint256[] calldata ids) external onlyLocker {
        if (
            !(_poolSlices[0].juniorTranche.principalDeposited == 0 &&
                _poolSlices[0].seniorTranche.principalDeposited == 0)
        ) {
            revert PoolBalanceNotEmpty();
        }

        allowedUIDTypes = ids;
    }

    function getAllowedUIDTypes() external view returns (uint256[] memory) {
        return allowedUIDTypes;
    }

    /**
     * @notice Deposit a USDC amount into the pool for a tranche. Mints an NFT to the caller representing the position
     * @param tranche The number representing the tranche to deposit into
     * @param amount The USDC amount to tranfer from the caller to the pool
     * @return tokenId The tokenId of the NFT
     */
    function deposit(uint256 tranche, uint256 amount)
        public
        override
        nonReentrant
        whenNotPaused
        returns (uint256)
    {
        TrancheInfo storage trancheInfo = OvenueJuniorPoolLogic._getTrancheInfo(
            _poolSlices,
            numSlices,
            tranche
        );

        // /// @dev TL: Collateral locked
        if (!config.getCollateralCustody().isCollateralFullyFunded(IOvenueJuniorPool(address(this)))) {
            revert NotFullyCollateral();
        }

        /// @dev TL: tranche locked
        if (trancheInfo.lockedUntil != 0) {
            revert JuniorTranchAlreadyLocked();
        }

        /// @dev TL: Pool not opened
        if (block.timestamp < fundableAt) {
            revert PoolNotOpened();
        }

        /// @dev IA: invalid amount
        if (amount <= 0) {
            revert InvalidDepositAmount(amount);
        }

        /// @dev NA: not authorized. Must have correct UID or be go listed
        if (!hasAllowedUID(msg.sender)) {
            revert AllowedUIDNotGranted(msg.sender);
        }

        // senior tranche ids are always odd numbered
        if (OvenueTranchingLogic.isSeniorTrancheId(trancheInfo.id)) {
            if (!hasRole(SENIOR_ROLE, _msgSender())) {
                revert UnauthorizedCaller();
            }
        }

        return OvenueJuniorPoolLogic.deposit(trancheInfo, config, amount);
    }

    function depositWithPermit(
        uint256 tranche,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override returns (uint256 tokenId) {
        IERC20Permit(config.usdcAddress()).permit(
            msg.sender,
            address(this),
            amount,
            deadline,
            v,
            r,
            s
        );
        return deposit(tranche, amount);
    }

    /**
     * @notice Withdraw an already deposited amount if the funds are available
     * @param tokenId The NFT representing the position
     * @param amount The amount to withdraw (must be <= interest+principal currently available to withdraw)
     * @return interestWithdrawn The interest amount that was withdrawn
     * @return principalWithdrawn The principal amount that was withdrawn
     */
    function withdraw(uint256 tokenId, uint256 amount)
        public
        override
        nonReentrant
        whenNotPaused
        returns (uint256, uint256)
    {
        /// @dev NA: not authorized
        if (
            !(config.getJuniorLP().isApprovedOrOwner(msg.sender, tokenId) &&
                hasAllowedUID(msg.sender))
        ) {
            revert UnauthorizedCaller();
        }
        return
            OvenueJuniorPoolLogic.withdraw(
                _poolSlices,
                numSlices,
                tokenId,
                amount,
                config
            );
    }

    /**
     * @notice Withdraw from many tokens (that the sender owns) in a single transaction
     * @param tokenIds An array of tokens ids representing the position
     * @param amounts An array of amounts to withdraw from the corresponding tokenIds
     */
    function withdrawMultiple(
        uint256[] calldata tokenIds,
        uint256[] calldata amounts
    ) public override {
        if (tokenIds.length != amounts.length) {
            revert UnmatchedArraysLength();
        }

        uint256 i;

        while (i < amounts.length) {
            withdraw(tokenIds[i], amounts[i]);
            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Similar to withdraw but will withdraw all available funds
     * @param tokenId The NFT representing the position
     * @return interestWithdrawn The interest amount that was withdrawn
     * @return principalWithdrawn The principal amount that was withdrawn
     */
    function withdrawMax(uint256 tokenId)
        external
        override
        nonReentrant
        whenNotPaused
        returns (uint256 interestWithdrawn, uint256 principalWithdrawn)
    {
        return
            OvenueJuniorPoolLogic.withdrawMax(
                _poolSlices,
                numSlices,
                tokenId,
                config
            );
    }

    /**
     * @notice Draws down the funds (and locks the pool) to the borrower address. Can only be called by the borrower
     * @param amount The amount to drawdown from the creditline (must be < limit)
     */
    function drawdown(uint256 amount)
        external
        override
        onlyLocker
        whenNotPaused
    {
        /// @dev DP: drawdowns paused
        if (drawdownsPaused) {
            revert DrawnDownPaused();
        }

        totalDeployed = OvenueJuniorPoolLogic.drawdown(
            _poolSlices,
            creditLine,
            config,
            numSlices,
            amount,
            totalDeployed
        );
    }

    function NUM_TRANCHES_PER_SLICE() external pure returns (uint256) {
        return OvenueTranchingLogic.NUM_TRANCHES_PER_SLICE;
    }

    /**
     * @notice Locks the junior tranche, preventing more junior deposits. Gives time for the senior to determine how
     * much to invest (ensure leverage ratio cannot change for the period)
     */
    function lockJuniorCapital() external override onlyLocker whenNotPaused {
        _lockJuniorCapital(numSlices - 1);
    }

    /**
     * @notice Locks the pool (locks both senior and junior tranches and starts the drawdown period). Beyond the drawdown
     * period, any unused capital is available to withdraw by all depositors
     */
    function lockPool() external override onlyLocker whenNotPaused {
        OvenueJuniorPoolLogic.lockPool(
            _poolSlices,
            creditLine,
            config,
            numSlices
        );
    }

    function setFundableAt(uint256 newFundableAt) external override onlyLocker {
        fundableAt = newFundableAt;
    }

    function initializeNextSlice(uint256 _fundableAt)
        external
        override
        onlyLocker
        whenNotPaused
    {
        fundableAt = _fundableAt;
        numSlices = OvenueJuniorPoolLogic.initializeAnotherNextSlice(
            _poolSlices,
            creditLine,
            numSlices
        );
    }

    /**
     * @notice Triggers an assessment of the creditline and the applies the payments according the tranche waterfall
     */
    function assess() external override whenNotPaused {
        totalDeployed = OvenueJuniorPoolLogic.assess(
            _poolSlices,
            [address(creditLine), address(config)],
            [numSlices, totalDeployed, juniorFeePercent]
        );
    }

    // function claimCollateralNFT() external virtual override onlyLocker {
    //     uint256 creditBalance = IV2OvenueCreditLine(creditLine).balance();
    //     if (creditBalance != 0) {
    //         revert CreditLineBalanceExisted(creditBalance);
    //     }

    //     IERC721(collateral.nftAddr).safeTransferFrom(
    //         address(this),
    //         msg.sender,
    //         collateral.tokenId,
    //         ""
    //     );
    //     collateral.isLocked = false;

    //     emit NFTCollateralClaimed(
    //         msg.sender,
    //         collateral.nftAddr,
    //         collateral.tokenId
    //     );
    // }

    /**
     * @notice Allows repaying the creditline. Collects the USDC amount from the sender and triggers an assess
     * @param amount The amount to repay
     */
    function pay(uint256 amount) external override whenNotPaused {
        totalDeployed = OvenueJuniorPoolLogic.pay(
            _poolSlices,
            [address(creditLine), address(config)],
            [numSlices, totalDeployed, juniorFeePercent, amount]
        );
    }

    /**
     * @notice Pauses the pool and sweeps any remaining funds to the treasury reserve.
     */
    function emergencyShutdown() public onlyAdmin {
        if (!paused()) {
            _pause();
        }

        OvenueJuniorPoolLogic.emergencyShutdown(config, creditLine);
    }

    /**
     * @notice Toggles all drawdowns (but not deposits/withdraws)
     */
    function toggleDrawdowns() public onlyAdmin {
        drawdownsPaused = drawdownsPaused ? false : true;
        emit DrawdownsToggled(address(this), drawdownsPaused);
    }

    // CreditLine proxy method
    function setLimit(uint256 newAmount) external onlyAdmin {
        return creditLine.setLimit(newAmount);
    }

    function setMaxLimit(uint256 newAmount) external onlyAdmin {
        return creditLine.setMaxLimit(newAmount);
    }

    function getTranche(uint256 tranche)
        public
        view
        override
        returns (TrancheInfo memory)
    {
        return
            OvenueJuniorPoolLogic._getTrancheInfo(
                _poolSlices,
                numSlices,
                tranche
            );
    }

    function poolSlices(uint256 index)
        external
        view
        override
        returns (PoolSlice memory)
    {
        return _poolSlices[index];
    }

    /**
     * @notice Returns the total junior capital deposited
     * @return The total USDC amount deposited into all junior tranches
     */
    function totalJuniorDeposits() external view override returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < numSlices; i++) {
            total = total + _poolSlices[i].juniorTranche.principalDeposited;
        }
        return total;
    }

    // /**
    //  * @notice Returns boolean to check if nft is locked
    //  * @return Check whether nft is locked as collateral
    //  */
    // function isCollateralLocked() external view override returns (bool) {
    //     return collateral.isLocked;
    // }

    // function getCollateralInfo()
    //     external
    //     view
    //     virtual
    //     override
    //     returns (
    //         address,
    //         uint256,
    //         bool
    //     )
    // {
    //     return (
    //         collateral.nftAddr,
    //         collateral.tokenId,
    //         collateral.isLocked
    //     );
    // }

    function cancel() public override onlyLocker NotCancelled {
        setCancelStatus(true);
        emit PoolCancelled();
    }

    function setCancelStatus(bool status) public override onlyLocker NotCancelled {
        cancelled = status;
    }

    /**
     * @notice Determines the amount of interest and principal redeemable by a particular tokenId
     * @param tokenId The token representing the position
     * @return interestRedeemable The interest available to redeem
     * @return principalRedeemable The principal available to redeem
     */
    function availableToWithdraw(uint256 tokenId)
        public
        view
        override
        returns (uint256, uint256)
    {
        return
            OvenueJuniorPoolLogic.availableToWithdraw(
                _poolSlices,
                numSlices,
                config,
                tokenId
            );
    }

    function hasAllowedUID(address sender) public view override returns (bool) {
        return config.getGo().goOnlyIdTypes(sender, allowedUIDTypes);
    }

    function _lockJuniorCapital(uint256 sliceId) internal {
        OvenueJuniorPoolLogic.lockJuniorCapital(
            _poolSlices,
            numSlices,
            config,
            sliceId
        );
    }

    // // // Modifiers /////////////////////////////////////////////////////////////////

    modifier onlyLocker() {
        /// @dev NA: not authorized. not locker
        if (!hasRole(LOCKER_ROLE, msg.sender)) {
            revert UnauthorizedCaller();
        }
        _;
    }

    modifier NotCancelled() {
        /// @dev NA: not authorized. not locker
        if (cancelled) {
            revert PoolAlreadyCancelled();
        }
        _;
    }
}
