# IOvenueCollateralCustody









## Methods

### collectFungibleCollateral

```solidity
function collectFungibleCollateral(contract IOvenueJuniorPool _poolAddr, address _depositor, uint256 _amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _poolAddr | contract IOvenueJuniorPool | undefined |
| _depositor | address | undefined |
| _amount | uint256 | undefined |

### createCollateralStats

```solidity
function createCollateralStats(contract IOvenueJuniorPool _poolAddr, address _nftAddr, uint256 _tokenId, uint256 _fungibleAmount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _poolAddr | contract IOvenueJuniorPool | undefined |
| _nftAddr | address | undefined |
| _tokenId | uint256 | undefined |
| _fungibleAmount | uint256 | undefined |

### isCollateralFullyFunded

```solidity
function isCollateralFullyFunded(contract IOvenueJuniorPool _poolAddr) external nonpayable returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _poolAddr | contract IOvenueJuniorPool | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### redeemAllCollateral

```solidity
function redeemAllCollateral(contract IOvenueJuniorPool _poolAddr, address receiver) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _poolAddr | contract IOvenueJuniorPool | undefined |
| receiver | address | undefined |




