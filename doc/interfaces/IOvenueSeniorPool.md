# IOvenueSeniorPool









## Methods

### assets

```solidity
function assets() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### calculateWritedown

```solidity
function calculateWritedown(uint256 tokenId) external view returns (uint256 writedownAmount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| writedownAmount | uint256 | undefined |

### deposit

```solidity
function deposit(uint256 amount) external nonpayable returns (uint256 depositShares)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| depositShares | uint256 | undefined |

### depositWithPermit

```solidity
function depositWithPermit(uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external nonpayable returns (uint256 depositShares)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |
| deadline | uint256 | undefined |
| v | uint8 | undefined |
| r | bytes32 | undefined |
| s | bytes32 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| depositShares | uint256 | undefined |

### estimateInvestment

```solidity
function estimateInvestment(contract IOvenueJuniorPool pool) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| pool | contract IOvenueJuniorPool | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getNumShares

```solidity
function getNumShares(uint256 amount) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### invest

```solidity
function invest(contract IOvenueJuniorPool pool) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| pool | contract IOvenueJuniorPool | undefined |

### redeem

```solidity
function redeem(uint256 tokenId) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

### sharePrice

```solidity
function sharePrice() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### totalLoansOutstanding

```solidity
function totalLoansOutstanding() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### totalWritedowns

```solidity
function totalWritedowns() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### withdraw

```solidity
function withdraw(uint256 usdcAmount) external nonpayable returns (uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| usdcAmount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

### withdrawInLP

```solidity
function withdrawInLP(uint256 fiduAmount) external nonpayable returns (uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| fiduAmount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

### writedown

```solidity
function writedown(uint256 tokenId) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |




