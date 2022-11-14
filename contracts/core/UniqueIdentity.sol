// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

import "../external/ERC1155PresetPauserUpgradeable.sol";
import "../interfaces/IUniqueIdentity.sol";
import "hardhat/console.sol";

/**
 * @title UniqueIdentity
 * @notice UniqueIdentity is an ERC1155-compliant contract for representing
 * the identity verification status of addresses.
 * @author Ovenue
 */

contract UniqueIdentity is ERC1155PresetPauserUpgradeable, IUniqueIdentity {
    error UnmatchedArraysLength();
    error SignatureExpired();
    error MintCostNotEnough(uint256 cost);
    error BalanceNotEqualZero();
    error TokenIDNotSupported();
    error OnlyMintAndBurnActs();
    error UnAuthorizedCaller();
    error AddressZeroInput();

    bytes32 public constant SIGNER_ROLE =
        0xe2f4eaae4a9751e85a3e4a7b9587827a877f29914755229b07a7b2da98285f70;

    uint256 public constant ID_TYPE_0 = 0; // non-US individual
    uint256 public constant ID_TYPE_1 = 1; // US accredited individual
    uint256 public constant ID_TYPE_2 = 2; // US non accredited individual
    uint256 public constant ID_TYPE_3 = 3; // US entity
    uint256 public constant ID_TYPE_4 = 4; // non-US entity
    uint256 public constant ID_TYPE_5 = 5;
    uint256 public constant ID_TYPE_6 = 6;
    uint256 public constant ID_TYPE_7 = 7;
    uint256 public constant ID_TYPE_8 = 8;
    uint256 public constant ID_TYPE_9 = 9;
    uint256 public constant ID_TYPE_10 = 10;

    uint256 public constant MINT_COST_PER_TOKEN = 830000 gwei;

    //   /// @dev We include a nonce in every hashed message, and increment the nonce as part of a
    //   /// state-changing operation, so as to prevent replay attacks, i.e. the reuse of a signature.
    mapping(address => uint256) public nonces;
    mapping(uint256 => bool) public supportedUIDTypes;

    function initialize(address owner, string memory uri) public initializer {
        if (owner == address(0)) {
            revert AddressZeroInput();
        }
        __ERC1155PresetPauser_init(owner, uri);
        _setupRole(SIGNER_ROLE, owner);
        _setRoleAdmin(SIGNER_ROLE, OWNER_ROLE);
    }

    //   // solhint-disable-next-line func-name-mixedcase
    //   function c(address owner) internal initializer {
    //     _setupRole(SIGNER_ROLE, owner);
    //     _setRoleAdmin(SIGNER_ROLE, OWNER_ROLE);
    //   }

    //   // solhint-disable-next-line func-name-mixedcase
    //   function __UniqueIdentity_init_unchained(address owner) internal initializer {
    //     _setupRole(SIGNER_ROLE, owner);
    //     _setRoleAdmin(SIGNER_ROLE, OWNER_ROLE);
    //   }

    function setSupportedUIDTypes(
        uint256[] calldata ids,
        bool[] calldata values
    ) public onlyAdmin {
        if (ids.length != values.length) {
            revert UnmatchedArraysLength();
        }

        for (uint256 i = 0; i < ids.length; ++i) {
            supportedUIDTypes[ids[i]] = values[i];
        }
    }

    /**
     * @dev Gets the token name.
     * @return string representing the token name
     */
    function name() public pure returns (string memory) {
        return "Unique Identity";
    }

    /**
     * @dev Gets the token symbol.
     * @return string representing the token symbol
     */
    function symbol() public pure returns (string memory) {
        return "UID";
    }

    function mint(
        uint256 id,
        uint256 expiresAt,
        bytes calldata signature
    )
        public
        payable
        override
        onlySigner(_msgSender(), id, expiresAt, signature)
        incrementNonce(_msgSender())
    {
        if (msg.value < MINT_COST_PER_TOKEN) {
            revert MintCostNotEnough(msg.value);
        }

        if (!supportedUIDTypes[id]) {
            revert TokenIDNotSupported();
        }

        if (balanceOf(_msgSender(), id) != 0) {
            revert BalanceNotEqualZero();
        }

        _mint(_msgSender(), id, 1, "");
    }

    function burn(
        address account,
        uint256 id,
        uint256 expiresAt,
        bytes calldata signature
    )
        public
        override
        onlySigner(account, id, expiresAt, signature)
        incrementNonce(account)
    {
        _burn(account, id, 1);

        uint256 accountBalance = balanceOf(account, id);
        // require(accountBalance == 0, "Balance after burn must be 0");

        if (accountBalance != 0) {
            revert BalanceNotEqualZero();
        }
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155PresetPauserUpgradeable) {
        if (
            !((from == address(0) && to != address(0)) ||
                (from != address(0) && to == address(0)))
        ) {
            revert OnlyMintAndBurnActs();
        }
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    modifier onlySigner(
        address account,
        uint256 id,
        uint256 expiresAt,
        bytes calldata signature
    ) {
        if (block.timestamp >= expiresAt) {
            revert SignatureExpired();
        }
        // require(block.timestamp < expiresAt, "Signature has expired");

        bytes32 hash = keccak256(
            abi.encodePacked(
                account,
                id,
                expiresAt,
                address(this),
                nonces[account],
                block.chainid
            )
        );
        bytes32 ethSignedMessage = ECDSAUpgradeable.toEthSignedMessageHash(
            hash
        );
        if (
            !hasRole(
                SIGNER_ROLE,
                ECDSAUpgradeable.recover(ethSignedMessage, signature)
            )
        ) {
            revert UnAuthorizedCaller();
        }
        _;
    }

    modifier incrementNonce(address account) {
        ++nonces[account];
        _;
    }
}
