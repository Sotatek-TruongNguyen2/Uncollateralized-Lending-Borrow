# IOvenueJuniorPool









## Methods

### assess

```solidity
function assess() external nonpayable
```






### availableToWithdraw

```solidity
function availableToWithdraw(uint256 tokenId) external view returns (uint256 interestRedeemable, uint256 principalRedeemable)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| interestRedeemable | uint256 | undefined |
| principalRedeemable | uint256 | undefined |

### cancel

```solidity
function cancel() external nonpayable
```






### cancelAfterLockingCapital

```solidity
function cancelAfterLockingCapital() external nonpayable
```






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
function deposit(uint256 tranche, uint256 amount) external nonpayable returns (uint256 tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tranche | uint256 | undefined |
| amount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

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





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

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

### lockJuniorCapital

```solidity
function lockJuniorCapital() external nonpayable
```






### lockPool

```solidity
function lockPool() external nonpayable
```






### numSlices

```solidity
function numSlices() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### pay

```solidity
function pay(uint256 amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

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
function setFundableAt(uint256 timestamp) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| timestamp | uint256 | undefined |

### totalJuniorDeposits

```solidity
function totalJuniorDeposits() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### withdraw

```solidity
function withdraw(uint256 tokenId, uint256 amount) external nonpayable returns (uint256 interestWithdrawn, uint256 principalWithdrawn)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |
| amount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| interestWithdrawn | uint256 | undefined |
| principalWithdrawn | uint256 | undefined |

### withdrawMax

```solidity
function withdrawMax(uint256 tokenId) external nonpayable returns (uint256 interestWithdrawn, uint256 principalWithdrawn)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| interestWithdrawn | uint256 | undefined |
| principalWithdrawn | uint256 | undefined |

### withdrawMultiple

```solidity
function withdrawMultiple(uint256[] tokenIds, uint256[] amounts) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenIds | uint256[] | undefined |
| amounts | uint256[] | undefined |




