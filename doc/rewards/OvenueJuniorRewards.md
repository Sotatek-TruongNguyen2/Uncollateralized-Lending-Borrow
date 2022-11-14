# OvenueJuniorRewards









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

### __BaseUpgradeablePausable__init

```solidity
function __BaseUpgradeablePausable__init(address owner) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

### allocateRewards

```solidity
function allocateRewards(uint256 _interestPaymentAmount) external nonpayable
```

Calculates the accRewardsPerPrincipalDollar for a given pool, when a interest payment is received by the protocol



#### Parameters

| Name | Type | Description |
|---|---|---|
| _interestPaymentAmount | uint256 | The amount of total dollars the interest payment, expects 10^6 value |

### config

```solidity
function config() external view returns (contract IOvenueConfig)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueConfig | undefined |

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

### initialize

```solidity
function initialize(address owner, contract IOvenueConfig _config) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |
| _config | contract IOvenueConfig | undefined |

### isAdmin

```solidity
function isAdmin() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### maxInterestDollarsEligible

```solidity
function maxInterestDollarsEligible() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### paused

```solidity
function paused() external view returns (bool)
```



*Returns true if the contract is paused, and false otherwise.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### poolTokenClaimableRewards

```solidity
function poolTokenClaimableRewards(uint256 tokenId) external view returns (uint256)
```

Calculate the gross available gfi rewards for a PoolToken



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Pool token id |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The amount of GFI claimable |

### pools

```solidity
function pools(address) external view returns (uint256 accRewardsPerPrincipalDollar)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| accRewardsPerPrincipalDollar | uint256 | undefined |

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

### setMaxInterestDollarsEligible

```solidity
function setMaxInterestDollarsEligible(uint256 _maxInterestDollarsEligible) external nonpayable
```

Set the max dollars across the entire protocol that are eligible for GFI rewards



#### Parameters

| Name | Type | Description |
|---|---|---|
| _maxInterestDollarsEligible | uint256 | The amount of interest dollars eligible for GFI rewards, expects 10^18 value |

### setPoolTokenAccRewardsPerPrincipalDollarAtMint

```solidity
function setPoolTokenAccRewardsPerPrincipalDollarAtMint(address poolAddress, uint256 tokenId) external nonpayable
```

When a pool token is minted for multiple drawdowns, set accRewardsPerPrincipalDollarAtMint to the current accRewardsPerPrincipalDollar price



#### Parameters

| Name | Type | Description |
|---|---|---|
| poolAddress | address | undefined |
| tokenId | uint256 | Pool token id |

### setTotalInterestReceived

```solidity
function setTotalInterestReceived(uint256 _totalInterestReceived) external nonpayable
```

Set the total interest received to date. This should only be called once on contract deploy.



#### Parameters

| Name | Type | Description |
|---|---|---|
| _totalInterestReceived | uint256 | The amount of interest the protocol has received to date, expects 10^6 value |

### setTotalRewards

```solidity
function setTotalRewards(uint256 _totalRewards) external nonpayable
```

Set the total gfi rewards and the % of total GFI



#### Parameters

| Name | Type | Description |
|---|---|---|
| _totalRewards | uint256 | The amount of GFI rewards available, expects 10^18 value |

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

### tokens

```solidity
function tokens(uint256) external view returns (uint256 rewardsClaimed, uint256 accRewardsPerPrincipalDollarAtMint)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| rewardsClaimed | uint256 | undefined |
| accRewardsPerPrincipalDollarAtMint | uint256 | undefined |

### totalInterestReceived

```solidity
function totalInterestReceived() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### totalRewardPercentOfTotalOVN

```solidity
function totalRewardPercentOfTotalOVN() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### totalRewards

```solidity
function totalRewards() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### updateOvenueConfig

```solidity
function updateOvenueConfig() external nonpayable
```






### withdraw

```solidity
function withdraw(uint256 tokenId) external nonpayable
```

PoolToken request to withdraw all allocated rewards



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Pool token id |

### withdrawMultiple

```solidity
function withdrawMultiple(uint256[] tokenIds) external nonpayable
```

PoolToken request to withdraw multiple PoolTokens allocated rewards



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenIds | uint256[] | Array of pool token id |



## Events

### BackerRewardsClaimed

```solidity
event BackerRewardsClaimed(address indexed owner, uint256 indexed tokenId, uint256 amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |
| amount  | uint256 | undefined |

### BackerRewardsSetMaxInterestDollarsEligible

```solidity
event BackerRewardsSetMaxInterestDollarsEligible(address indexed owner, uint256 maxInterestDollarsEligible)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| maxInterestDollarsEligible  | uint256 | undefined |

### BackerRewardsSetTotalInterestReceived

```solidity
event BackerRewardsSetTotalInterestReceived(address indexed owner, uint256 totalInterestReceived)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| totalInterestReceived  | uint256 | undefined |

### BackerRewardsSetTotalRewards

```solidity
event BackerRewardsSetTotalRewards(address indexed owner, uint256 totalRewards, uint256 totalRewardPercentOfTotalOVN)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| totalRewards  | uint256 | undefined |
| totalRewardPercentOfTotalOVN  | uint256 | undefined |

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

### OvenueConfigUpdated

```solidity
event OvenueConfigUpdated(address indexed who, address configAddress)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| who `indexed` | address | undefined |
| configAddress  | address | undefined |

### Paused

```solidity
event Paused(address account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| account  | address | undefined |

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



