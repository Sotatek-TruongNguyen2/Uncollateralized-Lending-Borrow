# FiatTokenV1



> FiatToken



*ERC20 Token backed by fiat reserves*

## Methods

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

Amount of remaining tokens spender is allowed to transfer on behalf of the token owner



#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | Token owner&#39;s address |
| spender | address | Spender&#39;s address |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | Allowance amount |

### approve

```solidity
function approve(address spender, uint256 value) external nonpayable returns (bool)
```

Set spender&#39;s allowance over the caller&#39;s tokens to be a given value.



#### Parameters

| Name | Type | Description |
|---|---|---|
| spender | address | Spender&#39;s address |
| value | uint256 | Allowance amount |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | True if successful |

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```



*Get token balance of an account*

#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | address The account |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

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

### burn

```solidity
function burn(uint256 _amount) external nonpayable
```



*allows a minter to burn some of its own tokens Validates that caller is a minter and that sender is not blacklisted amount is less than or equal to the minter&#39;s account balance*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | uint256 the amount of tokens to be burned |

### configureMinter

```solidity
function configureMinter(address minter, uint256 minterAllowedAmount) external nonpayable returns (bool)
```



*Function to add/update a new minter*

#### Parameters

| Name | Type | Description |
|---|---|---|
| minter | address | The address of the minter |
| minterAllowedAmount | uint256 | The minting amount allowed for the minter |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | True if the operation was successful. |

### currency

```solidity
function currency() external view returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### decimals

```solidity
function decimals() external view returns (uint8)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint8 | undefined |

### initialize

```solidity
function initialize(string tokenName, string tokenSymbol, string tokenCurrency, uint8 tokenDecimals, address newMasterMinter, address newPauser, address newBlacklister, address newOwner) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenName | string | undefined |
| tokenSymbol | string | undefined |
| tokenCurrency | string | undefined |
| tokenDecimals | uint8 | undefined |
| newMasterMinter | address | undefined |
| newPauser | address | undefined |
| newBlacklister | address | undefined |
| newOwner | address | undefined |

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

### isMinter

```solidity
function isMinter(address account) external view returns (bool)
```



*Checks if account is a minter*

#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | The address to check |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### masterMinter

```solidity
function masterMinter() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### mint

```solidity
function mint(address _to, uint256 _amount) external nonpayable returns (bool)
```



*Function to mint tokens*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _to | address | The address that will receive the minted tokens. |
| _amount | uint256 | The amount of tokens to mint. Must be less than or equal to the minterAllowance of the caller. |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | A boolean that indicates if the operation was successful. |

### minterAllowance

```solidity
function minterAllowance(address minter) external view returns (uint256)
```



*Get minter allowance for an account*

#### Parameters

| Name | Type | Description |
|---|---|---|
| minter | address | The address of the minter |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### name

```solidity
function name() external view returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

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

### removeMinter

```solidity
function removeMinter(address minter) external nonpayable returns (bool)
```



*Function to remove a minter*

#### Parameters

| Name | Type | Description |
|---|---|---|
| minter | address | The address of the minter to remove |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | True if the operation was successful. |

### symbol

```solidity
function symbol() external view returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```



*Get totalSupply of token*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### transfer

```solidity
function transfer(address to, uint256 value) external nonpayable returns (bool)
```

Transfer tokens from the caller



#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | Payee&#39;s address |
| value | uint256 | Transfer amount |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | True if successful |

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external nonpayable returns (bool)
```

Transfer tokens by spending allowance



#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | Payer&#39;s address |
| to | address | Payee&#39;s address |
| value | uint256 | Transfer amount |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | True if successful |

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

### unpause

```solidity
function unpause() external nonpayable
```



*called by the owner to unpause, returns to normal state*


### updateBlacklister

```solidity
function updateBlacklister(address _newBlacklister) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _newBlacklister | address | undefined |

### updateMasterMinter

```solidity
function updateMasterMinter(address _newMasterMinter) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _newMasterMinter | address | undefined |

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

### Approval

```solidity
event Approval(address indexed owner, address indexed spender, uint256 value)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| spender `indexed` | address | undefined |
| value  | uint256 | undefined |

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

### Burn

```solidity
event Burn(address indexed burner, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| burner `indexed` | address | undefined |
| amount  | uint256 | undefined |

### MasterMinterChanged

```solidity
event MasterMinterChanged(address indexed newMasterMinter)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newMasterMinter `indexed` | address | undefined |

### Mint

```solidity
event Mint(address indexed minter, address indexed to, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| minter `indexed` | address | undefined |
| to `indexed` | address | undefined |
| amount  | uint256 | undefined |

### MinterConfigured

```solidity
event MinterConfigured(address indexed minter, uint256 minterAllowedAmount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| minter `indexed` | address | undefined |
| minterAllowedAmount  | uint256 | undefined |

### MinterRemoved

```solidity
event MinterRemoved(address indexed oldMinter)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| oldMinter `indexed` | address | undefined |

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

### Transfer

```solidity
event Transfer(address indexed from, address indexed to, uint256 value)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| from `indexed` | address | undefined |
| to `indexed` | address | undefined |
| value  | uint256 | undefined |

### UnBlacklisted

```solidity
event UnBlacklisted(address indexed _account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _account `indexed` | address | undefined |

### Unpause

```solidity
event Unpause()
```








