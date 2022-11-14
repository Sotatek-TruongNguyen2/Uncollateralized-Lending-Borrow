# IV2OvenueCreditLine









## Methods

### assess

```solidity
function assess() external nonpayable returns (uint256, uint256, uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |
| _1 | uint256 | undefined |
| _2 | uint256 | undefined |

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

### drawdown

```solidity
function drawdown(uint256 amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

### initialize

```solidity
function initialize(address _config, address owner, address _borrower, uint256 _limit, uint256 _interestApr, uint256 _paymentPeriodInDays, uint256 _termInDays, uint256 _lateFeeApr, uint256 _principalGracePeriodInDays) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _config | address | undefined |
| owner | address | undefined |
| _borrower | address | undefined |
| _limit | uint256 | undefined |
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

### paymentPeriodInDays

```solidity
function paymentPeriodInDays() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### principal

```solidity
function principal() external view returns (uint256)
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

### setPrincipal

```solidity
function setPrincipal(uint256 _principal) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _principal | uint256 | undefined |

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
function setTotalInterestAccrued(uint256 _interestAccrued) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _interestAccrued | uint256 | undefined |

### setWritedownAmount

```solidity
function setWritedownAmount(uint256 newWritedownAmount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newWritedownAmount | uint256 | undefined |

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




