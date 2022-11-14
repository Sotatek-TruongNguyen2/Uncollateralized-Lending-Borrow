# Ownable





The Ownable contract has an owner address, and provides basic authorization control functions

*Forked from https://github.com/OpenZeppelin/openzeppelin-labs/blob/3887ab77b8adafba4a26ace002f3a684c1a3388b/upgradeability_ownership/contracts/ownership/Ownable.sol Modifications: 1. Consolidate OwnableStorage into this contract (7/13/18) 2. Reformat, conform to Solidity 0.6 syntax, and add error messages (5/13/20) 3. Make public functions external (5/27/20)*

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

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Allows the current owner to transfer control of the contract to a newOwner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | The address to transfer ownership to. |



## Events

### OwnershipTransferred

```solidity
event OwnershipTransferred(address previousOwner, address newOwner)
```



*Event to show ownership has been transferred*

#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner  | address | representing the address of the previous owner |
| newOwner  | address | representing the address of the new owner |



