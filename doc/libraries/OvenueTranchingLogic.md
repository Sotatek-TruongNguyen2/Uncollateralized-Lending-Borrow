# OvenueTranchingLogic

*Goldfinch*

> OvenueTranchingLogic

Library for handling the payments waterfall



## Methods

### NUM_TRANCHES_PER_SLICE

```solidity
function NUM_TRANCHES_PER_SLICE() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### calculateExpectedSharePrice

```solidity
function calculateExpectedSharePrice(IOvenueJuniorPool.TrancheInfo tranche, uint256 amount, IOvenueJuniorPool.PoolSlice slice) external pure returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tranche | IOvenueJuniorPool.TrancheInfo | undefined |
| amount | uint256 | undefined |
| slice | IOvenueJuniorPool.PoolSlice | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getSliceInfo

```solidity
function getSliceInfo(IOvenueJuniorPool.PoolSlice slice, contract IV2OvenueCreditLine creditLine, uint256 totalDeployed, uint256 reserveFeePercent) external view returns (struct OvenueTranchingLogic.SliceInfo)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| slice | IOvenueJuniorPool.PoolSlice | undefined |
| creditLine | contract IV2OvenueCreditLine | undefined |
| totalDeployed | uint256 | undefined |
| reserveFeePercent | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | OvenueTranchingLogic.SliceInfo | undefined |

### getTotalInterestAndPrincipal

```solidity
function getTotalInterestAndPrincipal(IOvenueJuniorPool.PoolSlice slice, contract IV2OvenueCreditLine creditLine, uint256 totalDeployed) external view returns (uint256, uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| slice | IOvenueJuniorPool.PoolSlice | undefined |
| creditLine | contract IV2OvenueCreditLine | undefined |
| totalDeployed | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |
| _1 | uint256 | undefined |

### isJuniorTrancheId

```solidity
function isJuniorTrancheId(uint256 trancheId) external pure returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| trancheId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isSeniorTrancheId

```solidity
function isSeniorTrancheId(uint256 trancheId) external pure returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| trancheId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### scaleByFraction

```solidity
function scaleByFraction(uint256 amount, uint256 fraction, uint256 total) external pure returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |
| fraction | uint256 | undefined |
| total | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### scaleForSlice

```solidity
function scaleForSlice(IOvenueJuniorPool.PoolSlice slice, uint256 amount, uint256 totalDeployed) external pure returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| slice | IOvenueJuniorPool.PoolSlice | undefined |
| amount | uint256 | undefined |
| totalDeployed | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### sharePriceToUsdc

```solidity
function sharePriceToUsdc(uint256 sharePrice, uint256 totalShares) external pure returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| sharePrice | uint256 | undefined |
| totalShares | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### sliceIndexToJuniorTrancheId

```solidity
function sliceIndexToJuniorTrancheId(uint256 sliceIndex) external pure returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| sliceIndex | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### sliceIndexToSeniorTrancheId

```solidity
function sliceIndexToSeniorTrancheId(uint256 sliceIndex) external pure returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| sliceIndex | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### trancheIdToSliceIndex

```solidity
function trancheIdToSliceIndex(uint256 trancheId) external pure returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| trancheId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### usdcToSharePrice

```solidity
function usdcToSharePrice(uint256 amount, uint256 totalShares) external pure returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |
| totalShares | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |



## Events

### PaymentApplied

```solidity
event PaymentApplied(address indexed payer, address indexed pool, uint256 interestAmount, uint256 principalAmount, uint256 remainingAmount, uint256 reserveAmount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| payer `indexed` | address | undefined |
| pool `indexed` | address | undefined |
| interestAmount  | uint256 | undefined |
| principalAmount  | uint256 | undefined |
| remainingAmount  | uint256 | undefined |
| reserveAmount  | uint256 | undefined |

### SharePriceUpdated

```solidity
event SharePriceUpdated(address indexed pool, uint256 indexed tranche, uint256 principalSharePrice, int256 principalDelta, uint256 interestSharePrice, int256 interestDelta)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| pool `indexed` | address | undefined |
| tranche `indexed` | uint256 | undefined |
| principalSharePrice  | uint256 | undefined |
| principalDelta  | int256 | undefined |
| interestSharePrice  | uint256 | undefined |
| interestDelta  | int256 | undefined |

### TrancheLocked

```solidity
event TrancheLocked(address indexed pool, uint256 trancheId, uint256 lockedUntil)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| pool `indexed` | address | undefined |
| trancheId  | uint256 | undefined |
| lockedUntil  | uint256 | undefined |



