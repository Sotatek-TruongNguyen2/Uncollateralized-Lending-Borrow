# OvenueJuniorPoolNoneKYC









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

### NUM_TRANCHES_PER_SLICE

```solidity
function NUM_TRANCHES_PER_SLICE() external pure returns (uint256)
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

### SENIOR_ROLE

```solidity
function SENIOR_ROLE() external view returns (bytes32)
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

### allowedUIDTypes

```solidity
function allowedUIDTypes(uint256) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### assess

```solidity
function assess() external nonpayable
```

Triggers an assessment of the creditline and the applies the payments according the tranche waterfall




### availableToWithdraw

```solidity
function availableToWithdraw(uint256 tokenId) external view returns (uint256, uint256)
```

Determines the amount of interest and principal redeemable by a particular tokenId



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The token representing the position |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | interestRedeemable The interest available to redeem |
| _1 | uint256 | principalRedeemable The principal available to redeem |

### cancel

```solidity
function cancel() external nonpayable
```






### cancelAfterLockingCapital

```solidity
function cancelAfterLockingCapital() external nonpayable
```






### cancelled

```solidity
function cancelled() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### config

```solidity
function config() external view returns (contract IOvenueConfig)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueConfig | undefined |

### createdAt

```solidity
function createdAt() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### creditLine

```solidity
function creditLine() external view returns (contract IV2OvenueCreditLine)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IV2OvenueCreditLine | undefined |

### deposit

```solidity
function deposit(uint256 tranche, uint256 amount) external nonpayable returns (uint256)
```

Deposit a USDC amount into the pool for a tranche. Mints an NFT to the caller representing the position



#### Parameters

| Name | Type | Description |
|---|---|---|
| tranche | uint256 | The number representing the tranche to deposit into |
| amount | uint256 | The USDC amount to tranfer from the caller to the pool |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | tokenId The tokenId of the NFT |

### depositWithPermit

```solidity
function depositWithPermit(uint256 tranche, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external nonpayable returns (uint256 tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tranche | uint256 | undefined |
| amount | uint256 | undefined |
| deadline | uint256 | undefined |
| v | uint8 | undefined |
| r | bytes32 | undefined |
| s | bytes32 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

### drawdown

```solidity
function drawdown(uint256 amount) external nonpayable
```

Draws down the funds (and locks the pool) to the borrower address. Can only be called by the borrower



#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | The amount to drawdown from the creditline (must be &lt; limit) |

### drawdownsPaused

```solidity
function drawdownsPaused() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### emergencyShutdown

```solidity
function emergencyShutdown() external nonpayable
```

Pauses the pool and sweeps any remaining funds to the treasury reserve.




### fundableAt

```solidity
function fundableAt() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getAllowedUIDTypes

```solidity
function getAllowedUIDTypes() external view returns (uint256[])
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256[] | undefined |

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

### getTranche

```solidity
function getTranche(uint256 tranche) external view returns (struct IOvenueJuniorPool.TrancheInfo)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tranche | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | IOvenueJuniorPool.TrancheInfo | undefined |

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

### hasAllowedUID

```solidity
function hasAllowedUID(address sender) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| sender | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

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
function initialize(address[2] _addresses, uint256[3] _fees, uint256[4] _days, uint256 _limit, uint256[] _allowedUIDTypes) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _addresses | address[2] | undefined |
| _fees | uint256[3] | undefined |
| _days | uint256[4] | undefined |
| _limit | uint256 | undefined |
| _allowedUIDTypes | uint256[] | undefined |

### initializeNextSlice

```solidity
function initializeNextSlice(uint256 _fundableAt) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _fundableAt | uint256 | undefined |

### isAdmin

```solidity
function isAdmin() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### juniorFeePercent

```solidity
function juniorFeePercent() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### lockJuniorCapital

```solidity
function lockJuniorCapital() external nonpayable
```

Locks the junior tranche, preventing more junior deposits. Gives time for the senior to determine how much to invest (ensure leverage ratio cannot change for the period)




### lockPool

```solidity
function lockPool() external nonpayable
```

Locks the pool (locks both senior and junior tranches and starts the drawdown period). Beyond the drawdown period, any unused capital is available to withdraw by all depositors




### numSlices

```solidity
function numSlices() external view returns (uint256)
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

### pay

```solidity
function pay(uint256 amount) external nonpayable
```

Allows repaying the creditline. Collects the USDC amount from the sender and triggers an assess



#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | The amount to repay |

### poolSlices

```solidity
function poolSlices(uint256 index) external view returns (struct IOvenueJuniorPool.PoolSlice)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| index | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | IOvenueJuniorPool.PoolSlice | undefined |

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

### setAllowedUIDTypes

```solidity
function setAllowedUIDTypes(uint256[] ids) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| ids | uint256[] | undefined |

### setCancelStatus

```solidity
function setCancelStatus(bool status) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| status | bool | undefined |

### setFundableAt

```solidity
function setFundableAt(uint256 newFundableAt) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newFundableAt | uint256 | undefined |

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

### toggleDrawdowns

```solidity
function toggleDrawdowns() external nonpayable
```

Toggles all drawdowns (but not deposits/withdraws)




### totalDeployed

```solidity
function totalDeployed() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### totalJuniorDeposits

```solidity
function totalJuniorDeposits() external view returns (uint256)
```

Returns the total junior capital deposited




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The total USDC amount deposited into all junior tranches |

### withdraw

```solidity
function withdraw(uint256 tokenId, uint256 amount) external nonpayable returns (uint256, uint256)
```

Withdraw an already deposited amount if the funds are available



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The NFT representing the position |
| amount | uint256 | The amount to withdraw (must be &lt;= interest+principal currently available to withdraw) |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | interestWithdrawn The interest amount that was withdrawn |
| _1 | uint256 | principalWithdrawn The principal amount that was withdrawn |

### withdrawMax

```solidity
function withdrawMax(uint256 tokenId) external nonpayable returns (uint256 interestWithdrawn, uint256 principalWithdrawn)
```

Similar to withdraw but will withdraw all available funds



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The NFT representing the position |

#### Returns

| Name | Type | Description |
|---|---|---|
| interestWithdrawn | uint256 | The interest amount that was withdrawn |
| principalWithdrawn | uint256 | The principal amount that was withdrawn |

### withdrawMultiple

```solidity
function withdrawMultiple(uint256[] tokenIds, uint256[] amounts) external nonpayable
```

Withdraw from many tokens (that the sender owns) in a single transaction



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenIds | uint256[] | An array of tokens ids representing the position |
| amounts | uint256[] | An array of amounts to withdraw from the corresponding tokenIds |



## Events

### DrawdownsToggled

```solidity
event DrawdownsToggled(address indexed pool, bool isAllowed)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| pool `indexed` | address | undefined |
| isAllowed  | bool | undefined |

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

### PoolCancelled

```solidity
event PoolCancelled()
```






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

### AddressZeroInitialization

```solidity
error AddressZeroInitialization()
```






### AllowedUIDNotGranted

```solidity
error AllowedUIDNotGranted(address sender)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| sender | address | undefined |

### CreditLineBalanceExisted

```solidity
error CreditLineBalanceExisted(uint256 balance)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| balance | uint256 | undefined |

### DrawnDownPaused

```solidity
error DrawnDownPaused()
```






### InvalidDepositAmount

```solidity
error InvalidDepositAmount(uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

### JuniorTranchAlreadyLocked

```solidity
error JuniorTranchAlreadyLocked()
```






### NFTCollateralNotLocked

```solidity
error NFTCollateralNotLocked()
```






### NotFullyCollateral

```solidity
error NotFullyCollateral()
```






### PoolAlreadyCancelled

```solidity
error PoolAlreadyCancelled()
```






### PoolBalanceNotEmpty

```solidity
error PoolBalanceNotEmpty()
```






### PoolNotOpened

```solidity
error PoolNotOpened()
```






### PoolNotPure

```solidity
error PoolNotPure()
```






### UnauthorizedCaller

```solidity
error UnauthorizedCaller()
```






### UnmatchedArraysLength

```solidity
error UnmatchedArraysLength()
```







