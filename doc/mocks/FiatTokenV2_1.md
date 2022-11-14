# FiatTokenV2_1



> FiatToken V2.1

ERC20 Token backed by fiat reserves, version 2.1



## Methods

### CANCEL_AUTHORIZATION_TYPEHASH

```solidity
function CANCEL_AUTHORIZATION_TYPEHASH() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### PERMIT_TYPEHASH

```solidity
function PERMIT_TYPEHASH() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### RECEIVE_WITH_AUTHORIZATION_TYPEHASH

```solidity
function RECEIVE_WITH_AUTHORIZATION_TYPEHASH() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### TRANSFER_WITH_AUTHORIZATION_TYPEHASH

```solidity
function TRANSFER_WITH_AUTHORIZATION_TYPEHASH() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

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

### decreaseAllowance

```solidity
function decreaseAllowance(address spender, uint256 decrement) external nonpayable returns (bool)
```

Decrease the allowance by a given decrement



#### Parameters

| Name | Type | Description |
|---|---|---|
| spender | address | Spender&#39;s address |
| decrement | uint256 | Amount of decrease in allowance |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | True if successful |

### increaseAllowance

```solidity
function increaseAllowance(address spender, uint256 increment) external nonpayable returns (bool)
```

Increase the allowance by a given increment



#### Parameters

| Name | Type | Description |
|---|---|---|
| spender | address | Spender&#39;s address |
| increment | uint256 | Amount of increase in allowance |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | True if successful |

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

### initializeV2

```solidity
function initializeV2(string newName) external nonpayable
```

Initialize v2



#### Parameters

| Name | Type | Description |
|---|---|---|
| newName | string | New token name |

### initializeV2_1

```solidity
function initializeV2_1(address lostAndFound) external nonpayable
```

Initialize v2.1



#### Parameters

| Name | Type | Description |
|---|---|---|
| lostAndFound | address | The address to which the locked funds are sent |

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

### nonces

```solidity
function nonces(address owner) external view returns (uint256)
```

Nonces for permit



#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | Token owner&#39;s address (Authorizer) |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | Next nonce |

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

### permit

```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external nonpayable
```

Update allowance with a signed permit



#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | Token owner&#39;s address (Authorizer) |
| spender | address | Spender&#39;s address |
| value | uint256 | Amount of allowance |
| deadline | uint256 | Expiration time, seconds since the epoch |
| v | uint8 | v of the signature |
| r | bytes32 | r of the signature |
| s | bytes32 | s of the signature |

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

### updateRescuer

```solidity
function updateRescuer(address newRescuer) external nonpayable
```

Assign the rescuer role to a given address.



#### Parameters

| Name | Type | Description |
|---|---|---|
| newRescuer | address | New rescuer&#39;s address |

### version

```solidity
function version() external view returns (string)
```

Version string for the EIP712 domain separator




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | Version string |



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

### AuthorizationCanceled

```solidity
event AuthorizationCanceled(address indexed authorizer, bytes32 indexed nonce)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| authorizer `indexed` | address | undefined |
| nonce `indexed` | bytes32 | undefined |

### AuthorizationUsed

```solidity
event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| authorizer `indexed` | address | undefined |
| nonce `indexed` | bytes32 | undefined |

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

### RescuerChanged

```solidity
event RescuerChanged(address indexed newRescuer)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newRescuer `indexed` | address | undefined |

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








