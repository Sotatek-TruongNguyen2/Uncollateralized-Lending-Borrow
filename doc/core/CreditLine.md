# CreditLine

*Goldfinch*

> CreditLine

A contract that represents the agreement between Backers and  a Borrower. Includes the terms of the loan, as well as the current accounting state, such as interest owed.  A CreditLine belongs to a TranchedPool, and is fully controlled by that TranchedPool. It does not  operate in any standalone capacity. It should generally be considered internal to the TranchedPool.



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

### SECONDS_PER_DAY

```solidity
function SECONDS_PER_DAY() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### __BaseUpgradeablePausable__init

```solidity
function __BaseUpgradeablePausable__init(address owner) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

### assess

```solidity
function assess() external nonpayable returns (uint256, uint256, uint256)
```

Triggers an assessment of the creditline. Any USDC balance available in the creditline is applied towards the interest and principal.




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | Any amount remaining after applying payments towards the interest and principal |
| _1 | uint256 | Amount applied towards interest |
| _2 | uint256 | Amount applied towards principal |

### balance

```solidity
function balance() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### borrower

```solidity
function borrower() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### config

```solidity
function config() external view returns (contract IOvenueConfig)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueConfig | undefined |

### currentLimit

```solidity
function currentLimit() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### drawdown

```solidity
function drawdown(uint256 amount) external nonpayable
```

Updates the internal accounting to track a drawdown as of current block timestamp. Does not move any money



#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | The amount in USDC that has been drawndown |

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
function initialize(address _config, address owner, address _borrower, uint256 _maxLimit, uint256 _interestApr, uint256 _paymentPeriodInDays, uint256 _termInDays, uint256 _lateFeeApr, uint256 _principalGracePeriodInDays) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _config | address | undefined |
| owner | address | undefined |
| _borrower | address | undefined |
| _maxLimit | uint256 | undefined |
| _interestApr | uint256 | undefined |
| _paymentPeriodInDays | uint256 | undefined |
| _termInDays | uint256 | undefined |
| _lateFeeApr | uint256 | undefined |
| _principalGracePeriodInDays | uint256 | undefined |

### interestAccruedAsOf

```solidity
function interestAccruedAsOf() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### interestApr

```solidity
function interestApr() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### interestOwed

```solidity
function interestOwed() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### isAdmin

```solidity
function isAdmin() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isLate

```solidity
function isLate() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### lastFullPaymentTime

```solidity
function lastFullPaymentTime() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### lateFeeApr

```solidity
function lateFeeApr() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### limit

```solidity
function limit() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### maxLimit

```solidity
function maxLimit() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### nextDueTime

```solidity
function nextDueTime() external view returns (uint256)
```






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

### paymentPeriodInDays

```solidity
function paymentPeriodInDays() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### principalGracePeriodInDays

```solidity
function principalGracePeriodInDays() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### principalOwed

```solidity
function principalOwed() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

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

### setBalance

```solidity
function setBalance(uint256 newBalance) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newBalance | uint256 | undefined |

### setInterestAccruedAsOf

```solidity
function setInterestAccruedAsOf(uint256 newInterestAccruedAsOf) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newInterestAccruedAsOf | uint256 | undefined |

### setInterestOwed

```solidity
function setInterestOwed(uint256 newInterestOwed) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newInterestOwed | uint256 | undefined |

### setLastFullPaymentTime

```solidity
function setLastFullPaymentTime(uint256 newLastFullPaymentTime) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newLastFullPaymentTime | uint256 | undefined |

### setLateFeeApr

```solidity
function setLateFeeApr(uint256 newLateFeeApr) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newLateFeeApr | uint256 | undefined |

### setLimit

```solidity
function setLimit(uint256 newAmount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newAmount | uint256 | undefined |

### setMaxLimit

```solidity
function setMaxLimit(uint256 newAmount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newAmount | uint256 | undefined |

### setNextDueTime

```solidity
function setNextDueTime(uint256 newNextDueTime) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newNextDueTime | uint256 | undefined |

### setPrincipalOwed

```solidity
function setPrincipalOwed(uint256 newPrincipalOwed) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newPrincipalOwed | uint256 | undefined |

### setTermEndTime

```solidity
function setTermEndTime(uint256 newTermEndTime) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newTermEndTime | uint256 | undefined |

### setTotalInterestAccrued

```solidity
function setTotalInterestAccrued(uint256 _totalInterestAccrued) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _totalInterestAccrued | uint256 | undefined |

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

### termEndTime

```solidity
function termEndTime() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### termInDays

```solidity
function termInDays() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### termStartTime

```solidity
function termStartTime() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### totalInterestAccrued

```solidity
function totalInterestAccrued() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### withinPrincipalGracePeriod

```solidity
function withinPrincipalGracePeriod() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |



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



