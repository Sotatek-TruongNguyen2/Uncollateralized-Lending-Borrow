# Accountant

*Goldfinch*

> The Accountant`

Library for handling key financial calculations, such as interest and principal accrual.



## Methods

### allocatePayment

```solidity
function allocatePayment(uint256 paymentAmount, uint256 balance, uint256 interestOwed, uint256 principalOwed) external pure returns (struct Accountant.PaymentAllocation)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| paymentAmount | uint256 | undefined |
| balance | uint256 | undefined |
| interestOwed | uint256 | undefined |
| principalOwed | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | Accountant.PaymentAllocation | undefined |

### calculateAmountOwedForOneDay

```solidity
function calculateAmountOwedForOneDay(contract IOvenueCreditLine cl) external view returns (uint256 interestOwed)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| cl | contract IOvenueCreditLine | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| interestOwed | uint256 | undefined |

### calculateInterestAccrued

```solidity
function calculateInterestAccrued(contract IOvenueCreditLine cl, uint256 balance, uint256 timestamp, uint256 lateFeeGracePeriodInDays) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| cl | contract IOvenueCreditLine | undefined |
| balance | uint256 | undefined |
| timestamp | uint256 | undefined |
| lateFeeGracePeriodInDays | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### calculateInterestAccruedOverPeriod

```solidity
function calculateInterestAccruedOverPeriod(contract IOvenueCreditLine cl, uint256 balance, uint256 startTime, uint256 endTime, uint256 lateFeeGracePeriodInDays) external view returns (uint256 interestOwed)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| cl | contract IOvenueCreditLine | undefined |
| balance | uint256 | undefined |
| startTime | uint256 | undefined |
| endTime | uint256 | undefined |
| lateFeeGracePeriodInDays | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| interestOwed | uint256 | undefined |

### calculateInterestAndPrincipalAccrued

```solidity
function calculateInterestAndPrincipalAccrued(contract IOvenueCreditLine cl, uint256 timestamp, uint256 lateFeeGracePeriod) external view returns (uint256, uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| cl | contract IOvenueCreditLine | undefined |
| timestamp | uint256 | undefined |
| lateFeeGracePeriod | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |
| _1 | uint256 | undefined |

### calculateInterestAndPrincipalAccruedOverPeriod

```solidity
function calculateInterestAndPrincipalAccruedOverPeriod(contract IOvenueCreditLine cl, uint256 balance, uint256 startTime, uint256 endTime, uint256 lateFeeGracePeriod) external view returns (uint256, uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| cl | contract IOvenueCreditLine | undefined |
| balance | uint256 | undefined |
| startTime | uint256 | undefined |
| endTime | uint256 | undefined |
| lateFeeGracePeriod | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |
| _1 | uint256 | undefined |

### calculatePrincipalAccrued

```solidity
function calculatePrincipalAccrued(contract IOvenueCreditLine cl, uint256 balance, uint256 timestamp) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| cl | contract IOvenueCreditLine | undefined |
| balance | uint256 | undefined |
| timestamp | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### calculateWritedownFor

```solidity
function calculateWritedownFor(contract IOvenueCreditLine cl, uint256 timestamp, uint256 gracePeriodInDays, uint256 maxDaysLate) external view returns (uint256, uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| cl | contract IOvenueCreditLine | undefined |
| timestamp | uint256 | undefined |
| gracePeriodInDays | uint256 | undefined |
| maxDaysLate | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |
| _1 | uint256 | undefined |

### calculateWritedownForPrincipal

```solidity
function calculateWritedownForPrincipal(contract IOvenueCreditLine cl, uint256 principal, uint256 timestamp, uint256 gracePeriodInDays, uint256 maxDaysLate) external view returns (uint256, uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| cl | contract IOvenueCreditLine | undefined |
| principal | uint256 | undefined |
| timestamp | uint256 | undefined |
| gracePeriodInDays | uint256 | undefined |
| maxDaysLate | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |
| _1 | uint256 | undefined |

### lateFeeApplicable

```solidity
function lateFeeApplicable(contract IOvenueCreditLine cl, uint256 timestamp, uint256 gracePeriodInDays) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| cl | contract IOvenueCreditLine | undefined |
| timestamp | uint256 | undefined |
| gracePeriodInDays | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |




