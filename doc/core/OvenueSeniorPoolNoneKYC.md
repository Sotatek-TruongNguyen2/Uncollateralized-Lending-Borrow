# OvenueSeniorPoolNoneKYC

*Ovenue*

> Ovenue&#39;s SeniorPool contract

Main entry point for senior LPs (a.k.a. capital providers)  Automatically invests across borrower pools using an adjustable strategy.



## Methods

### DEFAULT_ADMIN_ROLE

```solidity
function DEFAULT_ADMIN_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### OWNER_ROLE

```solidity
function OWNER_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### PAUSER_ROLE

```solidity
function PAUSER_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### ZAPPER_ROLE

```solidity
function ZAPPER_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### __BaseUpgradeablePausable__init

```solidity
function __BaseUpgradeablePausable__init(address owner) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

### assets

```solidity
function assets() external view returns (uint256)
```

Returns the net assests controlled by and owed to the pool




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### calculateWritedown

```solidity
function calculateWritedown(uint256 tokenId) external view returns (uint256)
```

Calculates the writedown amount for a particular pool position



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The token reprsenting the position |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The amount in dollars the principal should be written down by |

### compoundBalance

```solidity
function compoundBalance() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### config

```solidity
function config() external view returns (contract IOvenueConfig)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueConfig | undefined |

### deposit

```solidity
function deposit(uint256 amount) external nonpayable returns (uint256 depositShares)
```

Deposits `amount` USDC from msg.sender into the SeniorPool, and grants you the  equivalent value of FIDU tokens



#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | The amount of USDC to deposit |

#### Returns

| Name | Type | Description |
|---|---|---|
| depositShares | uint256 | undefined |

### depositWithPermit

```solidity
function depositWithPermit(uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external nonpayable returns (uint256 depositShares)
```

Identical to deposit, except it allows for a passed up signature to permit  the Senior Pool to move funds on behalf of the user, all within one transaction.



#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | The amount of USDC to deposit |
| deadline | uint256 | undefined |
| v | uint8 | secp256k1 signature component |
| r | bytes32 | secp256k1 signature component |
| s | bytes32 | secp256k1 signature component |

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

Converts and USDC amount to FIDU amount



#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | USDC amount to convert to FIDU |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getRoleAdmin

```solidity
function getRoleAdmin(bytes32 role) external view returns (bytes32)
```



*Returns the admin role that controls `role`. See {grantRole} and {revokeRole}. To change a role&#39;s admin, use {_setRoleAdmin}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### grantRole

```solidity
function grantRole(bytes32 role, address account) external nonpayable
```



*Grants `role` to `account`. If `account` had not been already granted `role`, emits a {RoleGranted} event. Requirements: - the caller must have ``role``&#39;s admin role. May emit a {RoleGranted} event.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### hasRole

```solidity
function hasRole(bytes32 role, address account) external view returns (bool)
```



*Returns `true` if `account` has been granted `role`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### initZapperRole

```solidity
function initZapperRole() external nonpayable
```






### initialize

```solidity
function initialize(address owner, contract IOvenueConfig _config) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |
| _config | contract IOvenueConfig | undefined |

### invest

```solidity
function invest(contract IOvenueJuniorPool pool) external nonpayable
```

Invest in an ITranchedPool&#39;s senior tranche using the senior pool&#39;s strategy



#### Parameters

| Name | Type | Description |
|---|---|---|
| pool | contract IOvenueJuniorPool | An ITranchedPool whose senior tranche should be considered for investment |

### isAdmin

```solidity
function isAdmin() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isZapper

```solidity
function isZapper() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### paused

```solidity
function paused() external view returns (bool)
```



*Returns true if the contract is paused, and false otherwise.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### redeem

```solidity
function redeem(uint256 tokenId) external nonpayable
```

Redeem interest and/or principal from an ITranchedPool investment



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | the ID of an IPoolTokens token to be redeemed |

### renounceRole

```solidity
function renounceRole(bytes32 role, address account) external nonpayable
```



*Revokes `role` from the calling account. Roles are often managed via {grantRole} and {revokeRole}: this function&#39;s purpose is to provide a mechanism for accounts to lose their privileges if they are compromised (such as when a trusted device is misplaced). If the calling account had been revoked `role`, emits a {RoleRevoked} event. Requirements: - the caller must be `account`. May emit a {RoleRevoked} event.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### revokeRole

```solidity
function revokeRole(bytes32 role, address account) external nonpayable
```



*Revokes `role` from `account`. If `account` had been granted `role`, emits a {RoleRevoked} event. Requirements: - the caller must have ``role``&#39;s admin role. May emit a {RoleRevoked} event.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### sharePrice

```solidity
function sharePrice() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) external view returns (bool)
```



*See {IERC165-supportsInterface}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| interfaceId | bytes4 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

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

Withdraws USDC from the SeniorPool to msg.sender, and burns the equivalent value of FIDU tokens



#### Parameters

| Name | Type | Description |
|---|---|---|
| usdcAmount | uint256 | The amount of USDC to withdraw |

#### Returns

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

### withdrawInLP

```solidity
function withdrawInLP(uint256 lpAmount) external nonpayable returns (uint256 amount)
```

Withdraws USDC (denominated in FIDU terms) from the SeniorPool to msg.sender



#### Parameters

| Name | Type | Description |
|---|---|---|
| lpAmount | uint256 | The amount of USDC to withdraw in terms of FIDU shares |

#### Returns

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

### writedown

```solidity
function writedown(uint256 tokenId) external nonpayable
```

Write down an ITranchedPool investment. This will adjust the senior pool&#39;s share price  down if we&#39;re considering the investment a loss, or up if the borrower has subsequently  made repayments that restore confidence that the full loan will be repaid.



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | the ID of an IPoolTokens token to be considered for writedown |

### writedowns

```solidity
function writedowns(contract IOvenueJuniorPool) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueJuniorPool | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |



## Events

### DepositMade

```solidity
event DepositMade(address indexed capitalProvider, uint256 amount, uint256 shares)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| capitalProvider `indexed` | address | undefined |
| amount  | uint256 | undefined |
| shares  | uint256 | undefined |

### GoldfinchConfigUpdated

```solidity
event GoldfinchConfigUpdated(address indexed who, address configAddress)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| who `indexed` | address | undefined |
| configAddress  | address | undefined |

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

### InterestCollected

```solidity
event InterestCollected(address indexed payer, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| payer `indexed` | address | undefined |
| amount  | uint256 | undefined |

### InvestmentMadeInJunior

```solidity
event InvestmentMadeInJunior(address indexed tranchedPool, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tranchedPool `indexed` | address | undefined |
| amount  | uint256 | undefined |

### InvestmentMadeInSenior

```solidity
event InvestmentMadeInSenior(address indexed tranchedPool, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tranchedPool `indexed` | address | undefined |
| amount  | uint256 | undefined |

### Paused

```solidity
event Paused(address account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| account  | address | undefined |

### PrincipalCollected

```solidity
event PrincipalCollected(address indexed payer, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| payer `indexed` | address | undefined |
| amount  | uint256 | undefined |

### PrincipalWrittenDown

```solidity
event PrincipalWrittenDown(address indexed tranchedPool, int256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tranchedPool `indexed` | address | undefined |
| amount  | int256 | undefined |

### ReserveFundsCollected

```solidity
event ReserveFundsCollected(address indexed user, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| user `indexed` | address | undefined |
| amount  | uint256 | undefined |

### RoleAdminChanged

```solidity
event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| previousAdminRole `indexed` | bytes32 | undefined |
| newAdminRole `indexed` | bytes32 | undefined |

### RoleGranted

```solidity
event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| account `indexed` | address | undefined |
| sender `indexed` | address | undefined |

### RoleRevoked

```solidity
event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| account `indexed` | address | undefined |
| sender `indexed` | address | undefined |

### Unpaused

```solidity
event Unpaused(address account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| account  | address | undefined |

### WithdrawalMade

```solidity
event WithdrawalMade(address indexed capitalProvider, uint256 userAmount, uint256 reserveAmount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| capitalProvider `indexed` | address | undefined |
| userAmount  | uint256 | undefined |
| reserveAmount  | uint256 | undefined |



## Errors

### InvalidWithdrawAmount

```solidity
error InvalidWithdrawAmount()
```







