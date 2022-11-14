// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/presets/ERC20PresetMinterPauser.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev {ERC20} token, including:
 *
 *  - ability for holders to burn (destroy) their tokens
 *  - a minter role that allows for token minting (creation)
 *  - a pauser role that allows to stop all token transfers
 *
 * This contract uses {AccessControl} to lock permissioned functions using the
 * different roles - head to its documentation for details.
 *
 * The account that deploys the contract will be granted the minter and pauser
 * roles, as well as the default admin role, which will let it grant both minter
 * and pauser roles to other accounts.
 *
 * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
 */
contract ERC20PresetMinterPauserUpgradeable is AccessControlEnumerableUpgradeable, ERC20VotesUpgradeable, PausableUpgradeable {
    error MinterNotGranted();
    error PauserNotGranted();

    bytes32 public constant MINTER_ROLE = 0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6;
    bytes32 public constant PAUSER_ROLE = 0x65d7a28e3265b37a6474929f336521b332c1681b933f6cb9f3376673440d862a;

    /**
     * @dev Creates `amount` new tokens for `to`.
     *
     * See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */
    function mint(address to, uint256 amount) public virtual {
        if (!hasRole(MINTER_ROLE, _msgSender())) {
            revert MinterNotGranted();
        }

        _mint(to, amount);
    }

    // function burn(uint256 amount) public virtual {
    //     _burn(_msgSender(), amount);
    // }

    // /**
    //  * @dev Destroys `amount` tokens from `account`, deducting from the caller's
    //  * allowance.
    //  *
    //  * See {ERC20-_burn} and {ERC20-allowance}.
    //  *
    //  * Requirements:
    //  *
    //  * - the caller must have allowance for ``accounts``'s tokens of at least
    //  * `amount`.
    //  */
    // function burnFrom(address account, uint256 amount) public virtual {
    //     _spendAllowance(account, _msgSender(), amount);
    //     _burn(account, amount);
    // }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC20Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public virtual {
        if (!hasRole(PAUSER_ROLE, _msgSender())) {
            revert PauserNotGranted();
        }
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC20Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public virtual {
        if (!hasRole(PAUSER_ROLE, _msgSender())) {
            revert PauserNotGranted();
        }
        _unpause();
    }


    // function _mint(address account, uint256 amount) internal virtual override(ERC20VotesUpgradeable) {
    //     ERC20VotesUpgradeable._mint(account, amount);
    // }

    // function _burn(address account, uint256 amount) internal virtual override(ERC20VotesUpgradeable) {
    //     ERC20VotesUpgradeable._burn(account, amount);
    // }

    

     function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20Upgradeable) {
        super._beforeTokenTransfer(from, to, amount);
    }

//     function _afterTokenTransfer(
//         address from,
//         address to,
//         uint256 amount
//     ) internal virtual override(ERC20Upgradeable, ERC20VotesUpgradeable) {
//         ERC20VotesUpgradeable._afterTokenTransfer(from, to, amount);
//     }
}

