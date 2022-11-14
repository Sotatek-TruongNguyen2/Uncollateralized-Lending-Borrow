# OvenueJuniorPoolLogic










## Events

### DepositMade

```solidity
event DepositMade(address indexed owner, uint256 indexed tranche, uint256 indexed tokenId, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| tranche `indexed` | uint256 | undefined |
| tokenId `indexed` | uint256 | undefined |
| amount  | uint256 | undefined |

### DrawdownMade

```solidity
event DrawdownMade(address indexed borrower, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| borrower `indexed` | address | undefined |
| amount  | uint256 | undefined |

### EmergencyShutdown

```solidity
event EmergencyShutdown(address indexed pool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| pool `indexed` | address | undefined |

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

### ReserveFundsCollected

```solidity
event ReserveFundsCollected(address indexed from, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| from `indexed` | address | undefined |
| amount  | uint256 | undefined |

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

### SliceCreated

```solidity
event SliceCreated(address indexed pool, uint256 sliceId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| pool `indexed` | address | undefined |
| sliceId  | uint256 | undefined |

### WithdrawalMade

```solidity
event WithdrawalMade(address indexed owner, uint256 indexed tranche, uint256 indexed tokenId, uint256 interestWithdrawn, uint256 principalWithdrawn)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| tranche `indexed` | uint256 | undefined |
| tokenId `indexed` | uint256 | undefined |
| interestWithdrawn  | uint256 | undefined |
| principalWithdrawn  | uint256 | undefined |



