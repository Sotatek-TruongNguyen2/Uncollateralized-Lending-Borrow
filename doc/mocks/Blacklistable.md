# Blacklistable



> Blacklistable Token



*Allows accounts to be blacklisted by a &quot;blacklister&quot; role*

## Methods

### blacklist

```solidity
function blacklist(address _account) external nonpayable
```



*Adds account to blacklist*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _account | address | The address to blacklist |

### blacklister

```solidity
function blacklister() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### isBlacklisted

```solidity
function isBlacklisted(address _account) external view returns (bool)
```



*Checks if account is blacklisted*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _account | address | The address to check |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

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

### unBlacklist

```solidity
function unBlacklist(address _account) external nonpayable
```



*Removes account from blacklist*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _account | address | The address to remove from the blacklist |

### updateBlacklister

```solidity
function updateBlacklister(address _newBlacklister) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _newBlacklister | address | undefined |



## Events

### Blacklisted

```solidity
event Blacklisted(address indexed _account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _account `indexed` | address | undefined |

### BlacklisterChanged

```solidity
event BlacklisterChanged(address indexed newBlacklister)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newBlacklister `indexed` | address | undefined |

### OwnershipTransferred

```solidity
event OwnershipTransferred(address previousOwner, address newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner  | address | undefined |
| newOwner  | address | undefined |

### UnBlacklisted

```solidity
event UnBlacklisted(address indexed _account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _account `indexed` | address | undefined |



