# OvenueJuniorLP

*Ovenue*

> PoolTokens

PoolTokens is an ERC721 compliant contract, which can represent  junior tranche or senior tranche shares of any of the borrower pools.



## Methods

### DEFAULT_ADMIN_ROLE

```solidity
function DEFAULT_ADMIN_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### MINTER_ROLE

```solidity
function MINTER_ROLE() external view returns (bytes32)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### OWNER_ROLE

```solidity
function OWNER_ROLE() external view returns (bytes32)
```

ID for OWNER_ROLE




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

### _tokenIdTracker

```solidity
function _tokenIdTracker() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### approve

```solidity
function approve(address to, uint256 tokenId) external nonpayable
```



*See {IERC721-approve}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | undefined |
| tokenId | uint256 | undefined |

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```



*See {IERC721-balanceOf}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### burn

```solidity
function burn(uint256 tokenId) external nonpayable
```



*Burns a specific ERC721 token, and removes the data from our mappings*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | uint256 id of the ERC721 token to be burned. |

### config

```solidity
function config() external view returns (contract IOvenueConfig)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOvenueConfig | undefined |

### extendTokenURI

```solidity
function extendTokenURI() external view returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### getApproved

```solidity
function getApproved(uint256 tokenId) external view returns (address)
```



*See {IERC721-getApproved}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

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

### getTokenInfo

```solidity
function getTokenInfo(uint256 tokenId) external view returns (struct IOvenueJuniorLP.TokenInfo)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | IOvenueJuniorLP.TokenInfo | undefined |

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

Determine whether msg.sender has OWNER_ROLE




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | isAdmin True when msg.sender has OWNER_ROLE |

### isApprovedForAll

```solidity
function isApprovedForAll(address owner, address operator) external view returns (bool)
```



*See {IERC721-isApprovedForAll}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |
| operator | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isApprovedOrOwner

```solidity
function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool)
```

Returns a boolean representing whether the spender is the owner or the approved spender of the token



#### Parameters

| Name | Type | Description |
|---|---|---|
| spender | address | The address to check |
| tokenId | uint256 | The token id to check for |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | True if approved to redeem/transfer/burn the token, false if not |

### mint

```solidity
function mint(IOvenueJuniorLP.MintParams params, address to) external nonpayable returns (uint256 tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| params | IOvenueJuniorLP.MintParams | undefined |
| to | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

### name

```solidity
function name() external view returns (string)
```



*See {IERC721Metadata-name}.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### onPoolCreated

```solidity
function onPoolCreated(address newPool) external nonpayable
```

Called by the GoldfinchFactory to register the pool as a valid pool. Only valid pools can mint/redeem tokens



#### Parameters

| Name | Type | Description |
|---|---|---|
| newPool | address | The address of the newly created pool |

### ownerOf

```solidity
function ownerOf(uint256 tokenId) external view returns (address)
```



*See {IERC721-ownerOf}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### pause

```solidity
function pause() external nonpayable
```



*Pauses all token transfers. See {ERC721Pausable} and {Pausable-_pause}. Requirements: - the caller must have the `PAUSER_ROLE`.*


### paused

```solidity
function paused() external view returns (bool)
```



*Returns true if the contract is paused, and false otherwise.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### pools

```solidity
function pools(address) external view returns (uint256 totalMinted, uint256 totalPrincipalRedeemed, bool created)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| totalMinted | uint256 | undefined |
| totalPrincipalRedeemed | uint256 | undefined |
| created | bool | undefined |

### redeem

```solidity
function redeem(uint256 tokenId, uint256 principalRedeemed, uint256 interestRedeemed) external nonpayable
```

Updates a token to reflect the principal and interest amounts that have been redeemed.



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The token id to update (must be owned by the pool calling this function) |
| principalRedeemed | uint256 | The incremental amount of principal redeemed (cannot be more than principal deposited) |
| interestRedeemed | uint256 | The incremental amount of interest redeemed |

### reducePrincipalAmount

```solidity
function reducePrincipalAmount(uint256 tokenId, uint256 amount) external nonpayable
```

reduce a given pool token&#39;s principalAmount and principalRedeemed by a specified amount

*uses safemath to prevent underflowthis function is only intended for use as part of the v2.6.0 upgrade    to rectify a bug that allowed users to create a PoolToken that had a    larger amount of principal than they actually made available to the    borrower.  This bug is fixed in v2.6.0 but still requires past pool tokens    to have their principal redeemed and deposited to be rectified.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | id of token to decrease |
| amount | uint256 | amount to decrease by |

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

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId) external nonpayable
```



*See {IERC721-safeTransferFrom}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | undefined |
| to | address | undefined |
| tokenId | uint256 | undefined |

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId, bytes data) external nonpayable
```



*See {IERC721-safeTransferFrom}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | undefined |
| to | address | undefined |
| tokenId | uint256 | undefined |
| data | bytes | undefined |

### setApprovalForAll

```solidity
function setApprovalForAll(address operator, bool approved) external nonpayable
```



*See {IERC721-setApprovalForAll}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| operator | address | undefined |
| approved | bool | undefined |

### setBaseURI

```solidity
function setBaseURI(string baseURI_) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| baseURI_ | string | undefined |

### supportsInterface

```solidity
function supportsInterface(bytes4 id) external pure returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| id | bytes4 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### symbol

```solidity
function symbol() external view returns (string)
```



*See {IERC721Metadata-symbol}.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### tokenURI

```solidity
function tokenURI(uint256 tokenId) external view returns (string)
```



*See {IERC721Metadata-tokenURI}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### tokens

```solidity
function tokens(uint256) external view returns (address pool, uint256 tranche, uint256 principalAmount, uint256 principalRedeemed, uint256 interestRedeemed)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| pool | address | undefined |
| tranche | uint256 | undefined |
| principalAmount | uint256 | undefined |
| principalRedeemed | uint256 | undefined |
| interestRedeemed | uint256 | undefined |

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 tokenId) external nonpayable
```



*See {IERC721-transferFrom}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | undefined |
| to | address | undefined |
| tokenId | uint256 | undefined |

### unpause

```solidity
function unpause() external nonpayable
```



*Unpauses all token transfers. See {ERC721Pausable} and {Pausable-_unpause}. Requirements: - the caller must have the `PAUSER_ROLE`.*


### validPool

```solidity
function validPool(address sender) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| sender | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### withdrawPrincipal

```solidity
function withdrawPrincipal(uint256 tokenId, uint256 principalAmount) external nonpayable
```

Decrement a token&#39;s principal amount. This is different from `redeem`, which captures changes to   principal and/or interest that occur when a loan is in progress.



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The token id to update (must be owned by the pool calling this function) |
| principalAmount | uint256 | The incremental amount of principal redeemed (cannot be more than principal deposited) |



## Events

### Approval

```solidity
event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| approved `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |

### ApprovalForAll

```solidity
event ApprovalForAll(address indexed owner, address indexed operator, bool approved)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| operator `indexed` | address | undefined |
| approved  | bool | undefined |

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

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

### TokenBurned

```solidity
event TokenBurned(address indexed owner, address indexed pool, uint256 indexed tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| pool `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |

### TokenMinted

```solidity
event TokenMinted(address indexed owner, address indexed pool, uint256 indexed tokenId, uint256 amount, uint256 tranche)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| pool `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |
| amount  | uint256 | undefined |
| tranche  | uint256 | undefined |

### TokenPrincipalWithdrawn

```solidity
event TokenPrincipalWithdrawn(address indexed owner, address indexed pool, uint256 indexed tokenId, uint256 principalWithdrawn, uint256 tranche)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| pool `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |
| principalWithdrawn  | uint256 | undefined |
| tranche  | uint256 | undefined |

### TokenRedeemed

```solidity
event TokenRedeemed(address indexed owner, address indexed pool, uint256 indexed tokenId, uint256 principalRedeemed, uint256 interestRedeemed, uint256 tranche)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| pool `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |
| principalRedeemed  | uint256 | undefined |
| interestRedeemed  | uint256 | undefined |
| tranche  | uint256 | undefined |

### Transfer

```solidity
event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| from `indexed` | address | undefined |
| to `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |

### Unpaused

```solidity
event Unpaused(address account)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| account  | address | undefined |



## Errors

### ExceededRedeemAmount

```solidity
error ExceededRedeemAmount()
```






### OnlyBeCalledByPool

```solidity
error OnlyBeCalledByPool()
```







