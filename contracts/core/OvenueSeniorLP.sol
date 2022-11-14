// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "../external/ERC20PresetMinterPauserUpgradeable.sol";
import "../libraries/OvenueConfigHelper.sol";

/**
 * @title Fidu
 * @notice Fidu (symbol: FIDU) is Goldfinch's liquidity token, representing shares
 *  in the Pool. When you deposit, we mint a corresponding amount of Fidu, and when you withdraw, we
 *  burn Fidu. The share price of the Pool implicitly represents the "exchange rate" between Fidu
 *  and USDC (or whatever currencies the Pool may allow withdraws in during the future)
 * @author Goldfinch
 */

contract OvenueSeniorLP is ERC20PresetMinterPauserUpgradeable {
    error LiabilityMismatched();
    
    bytes32 public constant OWNER_ROLE = 0xb19546dff01e856fb3f010c267a7b1c60363cf8a4664e21cc89c26224620214e;
    // $1 threshold to handle potential rounding errors, from differing decimals on Fidu and USDC;
    uint256 public constant ASSET_LIABILITY_MATCH_THRESHOLD = 1e6;
    uint256 public constant USDC_MANTISSA = 1e6;
    uint256 public constant LP_MANTISSA = 1e18;

    IOvenueConfig public config;
    using OvenueConfigHelper for IOvenueConfig;

    event OvenueConfigUpdated(address indexed who, address configAddress);

    /*
    We are using our own initializer function so we can set the owner by passing it in.
    I would override the regular "initializer" function, but I can't because it's not marked
    as "virtual" in the parent contract
  */
    // solhint-disable-next-line func-name-mixedcase
    function __initialize__(
        address owner,
        string calldata name,
        string calldata symbol,
        IOvenueConfig _config
    ) external initializer {
        __ERC20Votes_init_unchained();
        __ERC20_init_unchained(name, symbol);
        __AccessControl_init_unchained();
        __Pausable_init_unchained();

        // __ERC20Burnable_init_unchained();
        // __ERC20Pausable_init_unchained();

        config = _config;

        _setupRole(MINTER_ROLE, owner);
        _setupRole(PAUSER_ROLE, owner);
        _setupRole(OWNER_ROLE, owner);

        _setRoleAdmin(MINTER_ROLE, OWNER_ROLE);
        _setRoleAdmin(PAUSER_ROLE, OWNER_ROLE);
        _setRoleAdmin(OWNER_ROLE, OWNER_ROLE);
    }

    /**
     * @dev Creates `amount` new tokens for `to`.
     *
     * See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */
    function mintTo(address to, uint256 amount) public {
        if (!canMint(amount)) {
            revert LiabilityMismatched();
        }
        // This super call restricts to only the minter in its implementation, so we don't need to do it here.
        super.mint(to, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have the MINTER_ROLE
     */
    function burnFrom(address from, uint256 amount) public {
        if (!hasRole(MINTER_ROLE, _msgSender())) {
            revert MinterNotGranted();
        }
        if (!canBurn(amount)) {
            revert LiabilityMismatched();
        }
        _burn(from, amount);
    }

    // Internal functions

    // canMint assumes that the USDC that backs the new shares has already been sent to the Pool
    function canMint(uint256 newAmount) internal view returns (bool) {
        IOvenueSeniorPool seniorPool = config.getSeniorPool();
        uint256 liabilities = ((totalSupply() + newAmount) *
            seniorPool.sharePrice()) / LP_MANTISSA;
        uint256 liabilitiesInDollars = lpToUSDC(liabilities);
        uint256 _assets = seniorPool.assets();
        if (_assets >= liabilitiesInDollars) {
            return true;
        } else {
            return
                liabilitiesInDollars - _assets <=
                ASSET_LIABILITY_MATCH_THRESHOLD;
        }
    }

    // canBurn assumes that the USDC that backed these shares has already been moved out the Pool
    function canBurn(uint256 amountToBurn) internal view returns (bool) {
        IOvenueSeniorPool seniorPool = config.getSeniorPool();
        uint256 liabilities = ((totalSupply() - amountToBurn) *
            seniorPool.sharePrice()) / LP_MANTISSA;
        uint256 liabilitiesInDollars = lpToUSDC(liabilities);
        uint256 _assets = seniorPool.assets();
        if (_assets >= liabilitiesInDollars) {
            return true;
        } else {
            return
                liabilitiesInDollars - _assets <=
                ASSET_LIABILITY_MATCH_THRESHOLD;
        }
    }

    function lpToUSDC(uint256 amount) internal pure returns (uint256) {
        return amount / (LP_MANTISSA / USDC_MANTISSA);
    }
}
