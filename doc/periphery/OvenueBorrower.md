# OvenueBorrower

*Ovenue*

> Ovenue&#39;s Borrower contract

These   with Goldfinch  They are 100% optional. However, they let us add many sophisticated and convient features for borrowers  while still keeping our core protocol small and secure. We therefore expect most borrowers will use them.  This contract is the &quot;official&quot; borrower contract that will be maintained by Goldfinch governance. However,  in theory, anyone can fork or create their own version, or not use any contract at all. The core functionality  is completely agnostic to whether it is interacting with a contract or an externally owned account (EOA).



## Methods

### DEFAULT_ADMIN_ROLE

```solidity
function DEFAULT_ADMIN_ROLE() external view returns (bytes32)
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

### cancel

```solidity
function cancel(address poolAddress, address addressToSendTo) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddress | address | undefined |
| addressToSendTo | address | undefined |

### config

```solidity
function config() external view returns (contract IOvenueConfig)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueConfig | undefined |

### drawdown

```solidity
function drawdown(address poolAddress, uint256 amount, address addressToSendTo) external nonpayable
```

Allows a borrower to drawdown on their credit line through a TranchedPool.



#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddress | address | The creditline from which they would like to drawdown |
| amount | uint256 | The amount, in USDC atomic units, that a borrower wishes to drawdown |
| addressToSendTo | address | The address where they would like the funds sent. If the zero address is passed,  it will be defaulted to the contracts address (msg.sender). This is a convenience feature for when they would  like the funds sent to an exchange or alternate wallet, different from the authentication address |

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

### lockCollateralToken

```solidity
function lockCollateralToken(address _poolAddress, uint256 _amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _poolAddress | address | undefined |
| _amount | uint256 | undefined |

### lockJuniorCapital

```solidity
function lockJuniorCapital(address poolAddress) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddress | address | undefined |

### lockPool

```solidity
function lockPool(address poolAddress) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddress | address | undefined |

### paused

```solidity
function paused() external view returns (bool)
```



*Returns true if the contract is paused, and false otherwise.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### pay

```solidity
function pay(address poolAddress, uint256 amount) external nonpayable
```

Allows a borrower to pay back loans by calling the `pay` function directly on a TranchedPool



#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddress | address | The credit line to be paid back |
| amount | uint256 | The amount, in USDC atomic units, that the borrower wishes to pay |

### payInFull

```solidity
function payInFull(address poolAddress, uint256 amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddress | address | undefined |
| amount | uint256 | undefined |

### payMultiple

```solidity
function payMultiple(address[] pools, uint256[] amounts) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| pools | address[] | undefined |
| amounts | uint256[] | undefined |

### redeemCollateral

```solidity
function redeemCollateral(address poolAddress, address addressToSendTo) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddress | address | undefined |
| addressToSendTo | address | undefined |

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

### transferERC20

```solidity
function transferERC20(address token, address to, uint256 amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| token | address | undefined |
| to | address | undefined |
| amount | uint256 | undefined |



## Events

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

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



