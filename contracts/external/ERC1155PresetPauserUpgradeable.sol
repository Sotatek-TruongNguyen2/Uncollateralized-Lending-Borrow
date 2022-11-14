// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev {ERC1155} token, including a pauser role that allows to stop all token transfers
 * (including minting and burning).
 *
 * This contract uses {AccessControl} to lock permissioned functions using the
 * different roles - head to its documentation for details.
 *
 * Adapted from OZ's ERC1155PresetMinterPauserUpgradeable.sol: removed inheritance of
 * ERC1155BurnableUpgradeable; removed MINTER_ROLE; replaced DEFAULT_ADMIN_ROLE with OWNER_ROLE;
 * grants roles to owner param rather than `_msgSender()`; added `setURI()`, to give owner ability
 * to set the URI after initialization; added `isAdmin()` helper and `onlyAdmin` modifier.
 */
contract ERC1155PresetPauserUpgradeable is
    ContextUpgradeable,
    AccessControlUpgradeable,
    ERC1155PausableUpgradeable
{
    error UnAnthorizedPauser();
    error UnAnthorizedOwner();

    bytes32 public constant OWNER_ROLE = 0xb19546dff01e856fb3f010c267a7b1c60363cf8a4664e21cc89c26224620214e;
    bytes32 public constant PAUSER_ROLE = 0x65d7a28e3265b37a6474929f336521b332c1681b933f6cb9f3376673440d862a;

    function __ERC1155PresetPauser_init(address owner, string memory uri) public virtual initializer {
        __ERC1155_init_unchained(uri);
        __Pausable_init_unchained();

        _setupRole(OWNER_ROLE, owner);
        _setupRole(PAUSER_ROLE, owner);

        _setRoleAdmin(PAUSER_ROLE, OWNER_ROLE);
        _setRoleAdmin(OWNER_ROLE, OWNER_ROLE);
    }

    // /**
    //  * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE`, and `PAUSER_ROLE` to the account that
    //  * deploys the contract.
    //  */
    // function __ERC1155PresetPauser_init(address owner, string memory uri)
    //     internal
    //     onlyInitializing
    // {
    //     __ERC1155_init_unchained(uri);
    //     __Pausable_init_unchained();
    //     __ERC1155PresetPauser_init_unchained(owner);
    // }

    // function __ERC1155PresetPauser_init_unchained(address owner)
    //     internal
    //     initializer
    // {
    //     _setupRole(OWNER_ROLE, owner);
    //     _setupRole(PAUSER_ROLE, owner);

    //     _setRoleAdmin(PAUSER_ROLE, OWNER_ROLE);
    //     _setRoleAdmin(OWNER_ROLE, OWNER_ROLE);
    // }

    function setURI(string memory newuri) external onlyAdmin {
        /// @dev Because the `newuri` is not id-specific, we do not emit a URI event here. See the comment
        /// on `_setURI()`.
        _setURI(newuri);
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC1155Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public virtual {
        if (!hasRole(PAUSER_ROLE, _msgSender())) {
            revert UnAnthorizedPauser();
        }
        // require(
        //     hasRole(PAUSER_ROLE, _msgSender()),
        //     "ERC1155PresetMinterPauser: must have pauser role to pause"
        // );
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC1155Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public virtual {
        if (!hasRole(PAUSER_ROLE, _msgSender())) {
            revert UnAnthorizedPauser();
        }
        // require(
        //     hasRole(PAUSER_ROLE, _msgSender()),
        //     "ERC1155PresetMinterPauser: must have pauser role to unpause"
        // );
        _unpause();
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlUpgradeable, ERC1155Upgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override(ERC1155PausableUpgradeable) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;

    function isAdmin() public view returns (bool) {
        return hasRole(OWNER_ROLE, _msgSender());
    }

    modifier onlyAdmin() {
        if (!isAdmin()) {
            revert UnAnthorizedOwner();
        }
        _;
    }
}
