# Go









## Methods

### DEFAULT_ADMIN_ROLE

```solidity
function DEFAULT_ADMIN_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### ID_TYPE_0

```solidity
function ID_TYPE_0() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ID_TYPE_1

```solidity
function ID_TYPE_1() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ID_TYPE_10

```solidity
function ID_TYPE_10() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ID_TYPE_2

```solidity
function ID_TYPE_2() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ID_TYPE_3

```solidity
function ID_TYPE_3() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ID_TYPE_4

```solidity
function ID_TYPE_4() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ID_TYPE_5

```solidity
function ID_TYPE_5() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ID_TYPE_6

```solidity
function ID_TYPE_6() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ID_TYPE_7

```solidity
function ID_TYPE_7() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ID_TYPE_8

```solidity
function ID_TYPE_8() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### ID_TYPE_9

```solidity
function ID_TYPE_9() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

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

### ZAPPER_ROLE

```solidity
function ZAPPER_ROLE() external view returns (bytes32)
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

### allIdTypes

```solidity
function allIdTypes(uint256) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### config

```solidity
function config() external view returns (contract IOvenueConfig)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueConfig | undefined |

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

### getSeniorPoolIdTypes

```solidity
function getSeniorPoolIdTypes() external pure returns (uint256[])
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256[] | undefined |

### go

```solidity
function go(address account) external view returns (bool)
```

Returns whether the provided account is go-listed for use of the Ovenue protocol for any of the UID token types. This status is defined as: whether `balanceOf(account, id)` on the UniqueIdentity contract is non-zero (where `id` is a supported token id on UniqueIdentity), falling back to the account&#39;s status on the legacy go-list maintained on OvenueConfig.



#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | The account whose go status to obtain |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | The account&#39;s go status |

### goOnlyIdTypes

```solidity
function goOnlyIdTypes(address account, uint256[] onlyIdTypes) external view returns (bool)
```

Returns whether the provided account is go-listed for use of the Goldfinch protocol for defined UID token types



#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | The account whose go status to obtain |
| onlyIdTypes | uint256[] | Array of id types to check balances |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | The account&#39;s go status |

### goSeniorPool

```solidity
function goSeniorPool(address account) external view returns (bool)
```

Returns whether the provided account is go-listed for use of the SeniorPool on the Goldfinch protocol.



#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | The account whose go status to obtain |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | The account&#39;s go status |

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

### initZapperRole

```solidity
function initZapperRole() external nonpayable
```






### initialize

```solidity
function initialize(address owner, contract IOvenueConfig _config, address _uniqueIdentity) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |
| _config | contract IOvenueConfig | undefined |
| _uniqueIdentity | address | undefined |

### isAdmin

```solidity
function isAdmin() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### legacyGoList

```solidity
function legacyGoList() external view returns (contract IOvenueConfig)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueConfig | undefined |

### paused

```solidity
function paused() external view returns (bool)
```



*Returns true if the contract is paused, and false otherwise.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### performUpgrade

```solidity
function performUpgrade() external nonpayable
```






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

### setLegacyGoList

```solidity
function setLegacyGoList(contract IOvenueConfig _legacyGoList) external nonpayable
```

sets the config that will be used as the source of truth for the go list instead of the config currently associated. To use the associated config for to list, set the override to the null address.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _legacyGoList | contract IOvenueConfig | undefined |

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

### uniqueIdentity

```solidity
function uniqueIdentity() external view returns (address)
```

Returns the address of the UniqueIdentity contract.




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### updateOvenueConfig

```solidity
function updateOvenueConfig() external nonpayable
```








## Events

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

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



