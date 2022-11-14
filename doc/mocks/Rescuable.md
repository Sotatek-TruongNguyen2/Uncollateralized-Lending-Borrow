# Rescuable









## Methods

### owner

```solidity
function owner() external view returns (address)
```



*Tells the address of the owner*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | the address of the owner |

### rescueERC20

```solidity
function rescueERC20(contract IERC20 tokenContract, address to, uint256 amount) external nonpayable
```

Rescue ERC20 tokens locked up in this contract.



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenContract | contract IERC20 | ERC20 token contract address |
| to | address | Recipient address |
| amount | uint256 | Amount to withdraw |

### rescuer

```solidity
function rescuer() external view returns (address)
```

Returns current rescuer




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | Rescuer&#39;s address |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Allows the current owner to transfer control of the contract to a newOwner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | The address to transfer ownership to. |

### updateRescuer

```solidity
function updateRescuer(address newRescuer) external nonpayable
```

Assign the rescuer role to a given address.



#### Parameters

| Name | Type | Description |
|---|---|---|
| newRescuer | address | New rescuer&#39;s address |



## Events

### OwnershipTransferred

```solidity
event OwnershipTransferred(address previousOwner, address newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner  | address | undefined |
| newOwner  | address | undefined |

### RescuerChanged

```solidity
event RescuerChanged(address indexed newRescuer)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newRescuer `indexed` | address | undefined |



