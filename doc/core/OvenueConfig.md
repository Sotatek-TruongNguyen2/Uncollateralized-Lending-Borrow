# OvenueConfig

*Goldfinch*

> GoldfinchConfig

This contract stores mappings of useful &quot;protocol config state&quot;, giving a central place  for all other contracts to access it. For example, the TransactionLimit, or the PoolAddress. These config vars  are enumerated in the `ConfigOptions` library, and can only be changed by admins of the protocol.  Note: While this inherits from BaseUpgradeablePausable, it is not deployed as an upgradeable contract (this    is mostly to save gas costs of having each call go through a proxy)



## Methods

### DEFAULT_ADMIN_ROLE

```solidity
function DEFAULT_ADMIN_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### GO_LISTER_ROLE

```solidity
function GO_LISTER_ROLE() external view returns (bytes32)
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

### addToGoList

```solidity
function addToGoList(address _member) external nonpayable
```



*Adds a user to go-list*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _member | address | address to add to go-list |

### addresses

```solidity
function addresses(uint256) external view returns (address)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### bulkAddToGoList

```solidity
function bulkAddToGoList(address[] _members) external nonpayable
```



*adds many users to go-list at once*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _members | address[] | addresses to ad to go-list |

### bulkRemoveFromGoList

```solidity
function bulkRemoveFromGoList(address[] _members) external nonpayable
```



*removes many users from go-list at once*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _members | address[] | addresses to remove from go-list |

### getAddress

```solidity
function getAddress(uint256 index) external view returns (address)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| index | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### getNumber

```solidity
function getNumber(uint256 index) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| index | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

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

### goList

```solidity
function goList(address) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

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
function initialize(address owner) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

### initializeFromOtherConfig

```solidity
function initializeFromOtherConfig(address _initialConfig, uint256 numbersLength, uint256 addressesLength) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _initialConfig | address | undefined |
| numbersLength | uint256 | undefined |
| addressesLength | uint256 | undefined |

### isAdmin

```solidity
function isAdmin() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### numbers

```solidity
function numbers(uint256) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### paused

```solidity
function paused() external view returns (bool)
```



*Returns true if the contract is paused, and false otherwise.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### removeFromGoList

```solidity
function removeFromGoList(address _member) external nonpayable
```



*removes a user from go-list*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _member | address | address to remove from go-list |

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

### setAddress

```solidity
function setAddress(uint256 addressIndex, address newAddress) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| addressIndex | uint256 | undefined |
| newAddress | address | undefined |

### setBorrowerImplementation

```solidity
function setBorrowerImplementation(address newAddress) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newAddress | address | undefined |

### setCollateralGovernImplementation

```solidity
function setCollateralGovernImplementation(address newAddress) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newAddress | address | undefined |

### setCreditLineImplementation

```solidity
function setCreditLineImplementation(address newAddress) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newAddress | address | undefined |

### setNumber

```solidity
function setNumber(uint256 index, uint256 newNumber) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| index | uint256 | undefined |
| newNumber | uint256 | undefined |

### setOvenueConfig

```solidity
function setOvenueConfig(address newAddress) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newAddress | address | undefined |

### setOvenueSeniorPool

```solidity
function setOvenueSeniorPool(address newAddress) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newAddress | address | undefined |

### setSeniorPoolStrategy

```solidity
function setSeniorPoolStrategy(address newStrategy) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newStrategy | address | undefined |

### setTranchedPoolImplementation

```solidity
function setTranchedPoolImplementation(address newAddress) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newAddress | address | undefined |

### setTreasuryReserve

```solidity
function setTreasuryReserve(address newTreasuryReserve) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newTreasuryReserve | address | undefined |

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

### valuesInitialized

```solidity
function valuesInitialized() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |



## Events

### AddressUpdated

```solidity
event AddressUpdated(address owner, uint256 index, address oldValue, address newValue)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner  | address | undefined |
| index  | uint256 | undefined |
| oldValue  | address | undefined |
| newValue  | address | undefined |

### GoListed

```solidity
event GoListed(address indexed member)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| member `indexed` | address | undefined |

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

### NoListed

```solidity
event NoListed(address indexed member)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| member `indexed` | address | undefined |

### NumberUpdated

```solidity
event NumberUpdated(address owner, uint256 index, uint256 oldValue, uint256 newValue)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner  | address | undefined |
| index  | uint256 | undefined |
| oldValue  | uint256 | undefined |
| newValue  | uint256 | undefined |

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



