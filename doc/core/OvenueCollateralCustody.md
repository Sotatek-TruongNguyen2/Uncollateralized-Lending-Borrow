# OvenueCollateralCustody









## Methods

### DEFAULT_ADMIN_ROLE

```solidity
function DEFAULT_ADMIN_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### LOCKER_ROLE

```solidity
function LOCKER_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### OWNER_ROLE

```solidity
function OWNER_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### PAUSER_ROLE

```solidity
function PAUSER_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### __BaseUpgradeablePausable__init

```solidity
function __BaseUpgradeablePausable__init(address owner) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

### collectFungibleCollateral

```solidity
function collectFungibleCollateral(contract IOvenueJuniorPool _poolAddr, address _depositor, uint256 _amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _poolAddr | contract IOvenueJuniorPool | undefined |
| _depositor | address | undefined |
| _amount | uint256 | undefined |

### config

```solidity
function config() external view returns (contract IOvenueConfig)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueConfig | undefined |

### createCollateralStats

```solidity
function createCollateralStats(contract IOvenueJuniorPool _poolAddr, address _nftAddr, uint256 _tokenId, uint256 _fungibleAmount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _poolAddr | contract IOvenueJuniorPool | undefined |
| _nftAddr | address | undefined |
| _tokenId | uint256 | undefined |
| _fungibleAmount | uint256 | undefined |

### getRoleAdmin

```solidity
function getRoleAdmin(bytes32 role) external view returns (bytes32)
```



*Returns the admin role that controls `role`. See {grantRole} and {revokeRole}. To change a role&#39;s admin, use {_setRoleAdmin}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### grantRole

```solidity
function grantRole(bytes32 role, address account) external nonpayable
```



*Grants `role` to `account`. If `account` had not been already granted `role`, emits a {RoleGranted} event. Requirements: - the caller must have ``role``&#39;s admin role. May emit a {RoleGranted} event.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### hasRole

```solidity
function hasRole(bytes32 role, address account) external view returns (bool)
```



*Returns `true` if `account` has been granted `role`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### initialize

```solidity
function initialize(address owner, address _config) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |
| _config | address | undefined |

### isAdmin

```solidity
function isAdmin() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isCollateralFullyFunded

```solidity
function isCollateralFullyFunded(contract IOvenueJuniorPool _poolAddr) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _poolAddr | contract IOvenueJuniorPool | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### onERC721Received

```solidity
function onERC721Received(address operator, address from, uint256 tokenId, bytes data) external nonpayable returns (bytes4)
```



*Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom} by `operator` from `from`, this function is called. It must return its Solidity selector to confirm the token transfer. If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted. The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| operator | address | undefined |
| from | address | undefined |
| tokenId | uint256 | undefined |
| data | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes4 | undefined |

### paused

```solidity
function paused() external view returns (bool)
```



*Returns true if the contract is paused, and false otherwise.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### poolCollateralStatus

```solidity
function poolCollateralStatus(contract IOvenueJuniorPool) external view returns (uint256 lockedUntil, uint256 fundedFungibleAmount, bool nftLocked)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueJuniorPool | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| lockedUntil | uint256 | undefined |
| fundedFungibleAmount | uint256 | undefined |
| nftLocked | bool | undefined |

### poolCollaterals

```solidity
function poolCollaterals(contract IOvenueJuniorPool) external view returns (address nftAddr, uint256 tokenId, uint256 fungibleAmount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueJuniorPool | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| nftAddr | address | undefined |
| tokenId | uint256 | undefined |
| fungibleAmount | uint256 | undefined |

### redeemAllCollateral

```solidity
function redeemAllCollateral(contract IOvenueJuniorPool _poolAddr, address receiver) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _poolAddr | contract IOvenueJuniorPool | undefined |
| receiver | address | undefined |

### renounceRole

```solidity
function renounceRole(bytes32 role, address account) external nonpayable
```



*Revokes `role` from the calling account. Roles are often managed via {grantRole} and {revokeRole}: this function&#39;s purpose is to provide a mechanism for accounts to lose their privileges if they are compromised (such as when a trusted device is misplaced). If the calling account had been revoked `role`, emits a {RoleRevoked} event. Requirements: - the caller must be `account`. May emit a {RoleRevoked} event.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### revokeRole

```solidity
function revokeRole(bytes32 role, address account) external nonpayable
```



*Revokes `role` from `account`. If `account` had been granted `role`, emits a {RoleRevoked} event. Requirements: - the caller must have ``role``&#39;s admin role. May emit a {RoleRevoked} event.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) external view returns (bool)
```



*See {IERC165-supportsInterface}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| interfaceId | bytes4 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### updateOvenueConfig

```solidity
function updateOvenueConfig() external nonpayable
```








## Events

### CollateralStatsCreated

```solidity
event CollateralStatsCreated(address indexed nftAddr, uint256 tokenId, uint256 collateralAmount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| nftAddr `indexed` | address | undefined |
| tokenId  | uint256 | undefined |
| collateralAmount  | uint256 | undefined |

### FungibleCollateralCollected

```solidity
event FungibleCollateralCollected(address indexed poolAddr, uint256 funded, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddr `indexed` | address | undefined |
| funded  | uint256 | undefined |
| amount  | uint256 | undefined |

### FungibleCollateralRedeemed

```solidity
event FungibleCollateralRedeemed(address indexed poolAddr, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddr `indexed` | address | undefined |
| amount  | uint256 | undefined |

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

### NFTCollateralLocked

```solidity
event NFTCollateralLocked(address indexed nftAddr, uint256 tokenId, address indexed poolAddr)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| nftAddr `indexed` | address | undefined |
| tokenId  | uint256 | undefined |
| poolAddr `indexed` | address | undefined |

### NFTCollateralRedeemed

```solidity
event NFTCollateralRedeemed(address indexed poolAddr, address indexed nftAddr, uint256 tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddr `indexed` | address | undefined |
| nftAddr `indexed` | address | undefined |
| tokenId  | uint256 | undefined |

### OvenueConfigUpdated

```solidity
event OvenueConfigUpdated(address indexed who, address configAddress)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| who `indexed` | address | undefined |
| configAddress  | address | undefined |

### Paused

```solidity
event Paused(address account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| account  | address | undefined |

### RoleAdminChanged

```solidity
event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| previousAdminRole `indexed` | bytes32 | undefined |
| newAdminRole `indexed` | bytes32 | undefined |

### RoleGranted

```solidity
event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| account `indexed` | address | undefined |
| sender `indexed` | address | undefined |

### RoleRevoked

```solidity
event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| account `indexed` | address | undefined |
| sender `indexed` | address | undefined |

### Unpaused

```solidity
event Unpaused(address account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| account  | address | undefined |



## Errors

### CollateralAlreadyInitialized

```solidity
error CollateralAlreadyInitialized(address poolAddr)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddr | address | undefined |

### ConfigNotSetup

```solidity
error ConfigNotSetup()
```






### InLockupPeriod

```solidity
error InLockupPeriod()
```






### InvalidAmount

```solidity
error InvalidAmount()
```






### PoolNotExisted

```solidity
error PoolNotExisted(address poolAddr)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddr | address | undefined |

### UnauthorizedCaller

```solidity
error UnauthorizedCaller()
```






### WrongNFTCollateral

```solidity
error WrongNFTCollateral()
```







