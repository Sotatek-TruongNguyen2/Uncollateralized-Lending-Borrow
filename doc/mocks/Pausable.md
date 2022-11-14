# Pausable





Base contract which allows children to implement an emergency stop mechanism

*Forked from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/feb665136c0dae9912e08397c1a21c4af3651ef3/contracts/lifecycle/Pausable.sol Modifications: 1. Added pauser role, switched pause/unpause to be onlyPauser (6/14/2018) 2. Removed whenNotPause/whenPaused from pause/unpause (6/14/2018) 3. Removed whenPaused (6/14/2018) 4. Switches ownable library to use ZeppelinOS (7/12/18) 5. Remove constructor (7/13/18) 6. Reformat, conform to Solidity 0.6 syntax and add error messages (5/13/20) 7. Make public functions external (5/27/20)*

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

### pause

```solidity
function pause() external nonpayable
```



*called by the owner to pause, triggers stopped state*


### paused

```solidity
function paused() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### pauser

```solidity
function pauser() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Allows the current owner to transfer control of the contract to a newOwner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | The address to transfer ownership to. |

### unpause

```solidity
function unpause() external nonpayable
```



*called by the owner to unpause, returns to normal state*


### updatePauser

```solidity
function updatePauser(address _newPauser) external nonpayable
```



*update the pauser role*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _newPauser | address | undefined |



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

### Pause

```solidity
event Pause()
```






### PauserChanged

```solidity
event PauserChanged(address indexed newAddress)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newAddress `indexed` | address | undefined |

### Unpause

```solidity
event Unpause()
```








