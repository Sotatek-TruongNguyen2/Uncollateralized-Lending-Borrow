// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
// import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "../interfaces/IOvenueConfig.sol";
import "../interfaces/IOvenueSeniorPool.sol";
import "../interfaces/IOvenueJuniorLP.sol";
import "../helpers/Accountant.sol";
import "../upgradeable/BaseUpgradeablePausable.sol";
import "../libraries/OvenueConfigHelper.sol";
import "./OvenueConfigOptions.sol";
import "hardhat/console.sol";

/**
 * @title Ovenue's SeniorPool contract
 * @notice Main entry point for senior LPs (a.k.a. capital providers)
 *  Automatically invests across borrower pools using an adjustable strategy.
 * @author Ovenue
 */
contract OvenueSeniorPool is BaseUpgradeablePausable, IOvenueSeniorPool {
  IOvenueConfig public config;
  using OvenueConfigHelper for IOvenueConfig;
  // using SafeERC20 for IERC20withDec;

  error InvalidWithdrawAmount();

  bytes32 public constant ZAPPER_ROLE = keccak256("ZAPPER_ROLE");

  uint256 public compoundBalance;
  mapping(IOvenueJuniorPool => uint256) public writedowns;

  event DepositMade(address indexed capitalProvider, uint256 amount, uint256 shares);
  event WithdrawalMade(address indexed capitalProvider, uint256 userAmount, uint256 reserveAmount);
  event InterestCollected(address indexed payer, uint256 amount);
  event PrincipalCollected(address indexed payer, uint256 amount);
  event ReserveFundsCollected(address indexed user, uint256 amount);

  event PrincipalWrittenDown(address indexed tranchedPool, int256 amount);
  event InvestmentMadeInSenior(address indexed tranchedPool, uint256 amount);
  event InvestmentMadeInJunior(address indexed tranchedPool, uint256 amount);

  event OvenueConfigUpdated(address indexed who, address configAddress);
  event PauseToggled(bool isAllowed);

  function initialize(address owner, IOvenueConfig _config) public initializer {
    require(owner != address(0) && address(_config) != address(0), "Owner and config addresses cannot be empty");

    __BaseUpgradeablePausable__init(owner);

    config = _config;
    sharePrice = _fiduMantissa();
    totalLoansOutstanding = 0;
    totalWritedowns = 0;

    IERC20withDec usdc = config.getUSDC();
    // Sanity check the address
    usdc.totalSupply();
    // shoudl use safe approve in here
    usdc.approve(address(this), type(uint256).max);
  }

  /**
   * @notice Deposits `amount` USDC from msg.sender into the SeniorPool, and grants you the
   *  equivalent value of FIDU tokens
   * @param amount The amount of USDC to deposit
   */
  function deposit(uint256 amount) public override whenNotPaused nonReentrant returns (uint256 depositShares) {
    require(config.getGo().goSeniorPool(msg.sender), "This address has not been go-listed");
    require(amount > 0, "Must deposit more than zero");
    // Check if the amount of new shares to be added is within limits
    depositShares = getNumShares(amount);
    // uint256 potentialNewTotalShares = totalShares() + depositShares;
    // require(sharesWithinLimit(potentialNewTotalShares), "Deposit would put the senior pool over the total limit.");
    emit DepositMade(msg.sender, amount, depositShares);
    bool success = doUSDCTransfer(msg.sender, address(this), amount);
    require(success, "Failed to transfer for deposit");

    config.getSeniorLP().mintTo(msg.sender, depositShares);
    return depositShares;
  }

  /**
   * @notice Identical to deposit, except it allows for a passed up signature to permit
   *  the Senior Pool to move funds on behalf of the user, all within one transaction.
   * @param amount The amount of USDC to deposit
   * @param v secp256k1 signature component
   * @param r secp256k1 signature component
   * @param s secp256k1 signature component
   */
  function depositWithPermit(
    uint256 amount,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) public override returns (uint256 depositShares) {
    IERC20Permit(config.usdcAddress()).permit(msg.sender, address(this), amount, deadline, v, r, s);
    return deposit(amount);
  }

  /**
   * @notice Withdraws USDC from the SeniorPool to msg.sender, and burns the equivalent value of FIDU tokens
   * @param usdcAmount The amount of USDC to withdraw
   */
  function withdraw(uint256 usdcAmount) external override whenNotPaused nonReentrant returns (uint256 amount) {
    require(config.getGo().goSeniorPool(msg.sender), "This address has not been go-listed");
    require(usdcAmount > 0, "Must withdraw more than zero");
    // // This MUST happen before calculating withdrawShares, otherwise the share price
    // // changes between calculation and burning of Fidu, which creates a asset/liability mismatch
    // if (compoundBalance > 0) {
    //   _sweepFromCompound();
    // }
    uint256 withdrawShares = getNumShares(usdcAmount);
    return _withdraw(usdcAmount, withdrawShares);
  }

  /**
   * @notice Withdraws USDC (denominated in FIDU terms) from the SeniorPool to msg.sender
   * @param lpAmount The amount of USDC to withdraw in terms of FIDU shares
   */
  function withdrawInLP(uint256 lpAmount) external override whenNotPaused nonReentrant returns (uint256 amount) {
    require(config.getGo().goSeniorPool(msg.sender), "This address has not been go-listed");
    require(lpAmount > 0, "Must withdraw more than zero");
    // // This MUST happen before calculating withdrawShares, otherwise the share price
    // // changes between calculation and burning of Fidu, which creates a asset/liability mismatch
    // if (compoundBalance > 0) {
    //   _sweepFromCompound();
    // }
    uint256 usdcAmount = _getUSDCAmountFromShares(lpAmount);
    uint256 withdrawShares = lpAmount;
    return _withdraw(usdcAmount, withdrawShares);
  }

//   /**
//    * @notice Moves any USDC still in the SeniorPool to Compound, and tracks the amount internally.
//    * This is done to earn interest on latent funds until we have other borrowers who can use it.
//    *
//    * Requirements:
//    *  - The caller must be an admin.
//    */
//   function sweepToCompound() public override onlyAdmin whenNotPaused {
//     IERC20 usdc = config.getUSDC();
//     uint256 usdcBalance = usdc.balanceOf(address(this));

//     ICUSDCContract cUSDC = config.getCUSDCContract();
//     // Approve compound to the exact amount
//     bool success = usdc.approve(address(cUSDC), usdcBalance);
//     require(success, "Failed to approve USDC for compound");

//     _sweepToCompound(cUSDC, usdcBalance);

//     // Remove compound approval to be extra safe
//     success = config.getUSDC().approve(address(cUSDC), 0);
//     require(success, "Failed to approve USDC for compound");
//   }

//   /**
//    * @notice Moves any USDC from Compound back to the SeniorPool, and recognizes interest earned.
//    * This is done automatically on drawdown or withdraw, but can be called manually if necessary.
//    *
//    * Requirements:
//    *  - The caller must be an admin.
//    */
//   function sweepFromCompound() public override onlyAdmin whenNotPaused {
//     _sweepFromCompound();
//   }

  /**
   * @notice Invest in an ITranchedPool's senior tranche using the senior pool's strategy
   * @param pool An ITranchedPool whose senior tranche should be considered for investment
   */
  function invest(IOvenueJuniorPool pool) public override whenNotPaused nonReentrant {
    require(_isValidPool(pool), "Pool must be valid");

    IOvenueSeniorPoolStrategy strategy = config.getSeniorPoolStrategy();
    uint256 amount = strategy.invest(pool);

    require(amount > 0, "Investment amount must be positive");

    _approvePool(pool, amount);
    uint256 nSlices = pool.numSlices();
    require(nSlices >= 1, "Pool has no slices");
    uint256 sliceIndex = nSlices - 1;
    uint256 seniorTrancheId = _sliceIndexToSeniorTrancheId(sliceIndex);
    pool.deposit(seniorTrancheId, amount);

    emit InvestmentMadeInSenior(address(pool), amount);
    totalLoansOutstanding = totalLoansOutstanding + amount;
  }

  function estimateInvestment(IOvenueJuniorPool pool) public view override returns (uint256) {
    require(_isValidPool(pool), "Pool must be valid");
    IOvenueSeniorPoolStrategy strategy = config.getSeniorPoolStrategy();
    return strategy.estimateInvestment(pool);
  }

  /**
   * @notice Redeem interest and/or principal from an ITranchedPool investment
   * @param tokenId the ID of an IPoolTokens token to be redeemed
   */
  function redeem(uint256 tokenId) public override whenNotPaused nonReentrant {
    IOvenueJuniorLP juniorLP = config.getJuniorLP();
    IOvenueJuniorLP.TokenInfo memory tokenInfo = juniorLP.getTokenInfo(tokenId);

    IOvenueJuniorPool pool = IOvenueJuniorPool(tokenInfo.pool);
    (uint256 interestRedeemed, uint256 principalRedeemed) = pool.withdrawMax(tokenId);

    _collectInterestAndPrincipal(address(pool), interestRedeemed, principalRedeemed);
  }

  /**
   * @notice Write down an ITranchedPool investment. This will adjust the senior pool's share price
   *  down if we're considering the investment a loss, or up if the borrower has subsequently
   *  made repayments that restore confidence that the full loan will be repaid.
   * @param tokenId the ID of an IPoolTokens token to be considered for writedown
   */
  function writedown(uint256 tokenId) public override whenNotPaused nonReentrant {
    IOvenueJuniorLP juniorLP = config.getJuniorLP();
    require(address(this) == juniorLP.ownerOf(tokenId), "Only tokens owned by the senior pool can be written down");

    IOvenueJuniorLP.TokenInfo memory tokenInfo = juniorLP.getTokenInfo(tokenId);
    IOvenueJuniorPool pool = IOvenueJuniorPool(tokenInfo.pool);
    require(_isValidPool(pool), "Pool must be valid");

    uint256 principalRemaining = tokenInfo.principalAmount - tokenInfo.principalRedeemed;

    (uint256 writedownPercent, uint256 writedownAmount) = _calculateWritedown(pool, principalRemaining);

    uint256 prevWritedownAmount = writedowns[pool];

    if (writedownPercent == 0 && prevWritedownAmount == 0) {
      return;
    }

    int256 writedownDelta = int256(prevWritedownAmount) - int256(writedownAmount);
    writedowns[pool] = writedownAmount;
    _distributeLosses(writedownDelta);
    if (writedownDelta > 0) {
      // If writedownDelta is positive, that means we got money back. So subtract from totalWritedowns.
      totalWritedowns = totalWritedowns - uint256(writedownDelta);
    } else {
      totalWritedowns = totalWritedowns + uint256(writedownDelta * -1);
    }
    emit PrincipalWrittenDown(address(pool), writedownDelta);
  }

  function togglePaused() public onlyAdmin {
    paused() ? _unpause() : _pause();
    emit PauseToggled(paused());
  }

  /**
   * @notice Calculates the writedown amount for a particular pool position
   * @param tokenId The token reprsenting the position
   * @return The amount in dollars the principal should be written down by
   */
  function calculateWritedown(uint256 tokenId) public view override returns (uint256) {
    IOvenueJuniorLP.TokenInfo memory tokenInfo = config.getJuniorLP().getTokenInfo(tokenId);
    IOvenueJuniorPool pool = IOvenueJuniorPool(tokenInfo.pool);

    uint256 principalRemaining = tokenInfo.principalAmount - tokenInfo.principalRedeemed;

    (, uint256 writedownAmount) = _calculateWritedown(pool, principalRemaining);
    return writedownAmount;
  }

  /**
   * @notice Returns the net assests controlled by and owed to the pool
   */
  function assets() public view override returns (uint256) {
    return
      compoundBalance + (config.getUSDC().balanceOf(address(this))) + totalLoansOutstanding - totalWritedowns;
  }

  /**
   * @notice Converts and USDC amount to FIDU amount
   * @param amount USDC amount to convert to FIDU
   */
  function getNumShares(uint256 amount) public view override returns (uint256) {
    return _usdcToFidu(amount) * _fiduMantissa() / sharePrice;
  }

//   /* Internal Functions */

  function _calculateWritedown(IOvenueJuniorPool pool, uint256 principal)
    internal
    view
    returns (uint256 writedownPercent, uint256 writedownAmount)
  {
    return
      Accountant.calculateWritedownForPrincipal(
        pool.creditLine(),
        principal,
        currentTime(),
        config.getLatenessGracePeriodInDays(),
        config.getLatenessMaxDays()
      );
  }

  function currentTime() internal view virtual returns (uint256) {
    return block.timestamp;
  }

  function _distributeLosses(int256 writedownDelta) internal {
    if (writedownDelta > 0) {
      uint256 delta = _usdcToSharePrice(uint256(writedownDelta));
      sharePrice = sharePrice + delta;
    } else {
      // If delta is negative, convert to positive uint, and sub from sharePrice
      uint256 delta = _usdcToSharePrice(uint256(writedownDelta * -1));
      sharePrice = sharePrice - delta;
    }
  }

  function _fiduMantissa() internal pure returns (uint256) {
    return uint256(10)**uint256(18);
  }

  function _usdcMantissa() internal pure returns (uint256) {
    return uint256(10)**uint256(6);
  }

  function _usdcToFidu(uint256 amount) internal pure returns (uint256) {
    return amount * _fiduMantissa() / _usdcMantissa();
  }

  function _fiduToUSDC(uint256 amount) internal pure returns (uint256) {
    return amount / _fiduMantissa() * _usdcMantissa();
  }

  function _getUSDCAmountFromShares(uint256 fiduAmount) internal view returns (uint256) {
    return _fiduToUSDC(fiduAmount * sharePrice / _fiduMantissa()) ;
  }

  function sharesWithinLimit(uint256 _totalShares) internal view returns (bool) {
    return
      _totalShares * sharePrice / _fiduMantissa() <=
      _usdcToFidu(config.getNumber(uint256(OvenueConfigOptions.Numbers.TotalFundsLimit)));
  }

  function doUSDCTransfer(
    address from,
    address to,
    uint256 amount
  ) internal returns (bool) {
    require(to != address(0), "Can't send to zero address");
    IERC20withDec usdc = config.getUSDC();
    return usdc.transferFrom(from, to, amount);
  }

  function _withdraw(uint256 usdcAmount, uint256 withdrawShares) internal returns (uint256 userAmount) {
    IOvenueSeniorLP seniorLP = config.getSeniorLP();
    // Determine current shares the address has and the shares requested to withdraw
    uint256 currentShares = seniorLP.balanceOf(msg.sender);
    // Ensure the address has enough value in the pool
    require(withdrawShares <= currentShares, "Amount requested is greater than what this address owns");

    // Send to reserves
    userAmount = usdcAmount;
    uint256 reserveAmount = 0;

    if (!isZapper()) {
      reserveAmount = usdcAmount / (config.getWithdrawFeeDenominator());
      userAmount = userAmount - reserveAmount;
      _sendToReserve(reserveAmount, msg.sender);
    }

    // Send to user
    bool success = doUSDCTransfer(address(this), msg.sender, userAmount);
    require(success, "Failed to transfer for withdraw");

    // Burn the shares
    seniorLP.burnFrom(msg.sender, withdrawShares);

    emit WithdrawalMade(msg.sender, userAmount, reserveAmount);

    return userAmount;
  }

//   function _sweepToCompound(ICUSDCContract cUSDC, uint256 usdcAmount) internal {
//     // Our current design requires we re-normalize by withdrawing everything and recognizing interest gains
//     // before we can add additional capital to Compound
//     require(compoundBalance == 0, "Cannot sweep when we already have a compound balance");
//     require(usdcAmount != 0, "Amount to sweep cannot be zero");
//     uint256 error = cUSDC.mint(usdcAmount);
//     require(error == 0, "Sweep to compound failed");
//     compoundBalance = usdcAmount;
//   }

//   function _sweepFromCompound() internal {
//     ICUSDCContract cUSDC = config.getCUSDCContract();
//     _sweepFromCompound(cUSDC, cUSDC.balanceOf(address(this)));
//   }

//   function _sweepFromCompound(ICUSDCContract cUSDC, uint256 cUSDCAmount) internal {
//     uint256 cBalance = compoundBalance;
//     require(cBalance != 0, "No funds on compound");
//     require(cUSDCAmount != 0, "Amount to sweep cannot be zero");

//     IERC20 usdc = config.getUSDC();
//     uint256 preRedeemUSDCBalance = usdc.balanceOf(address(this));
//     uint256 cUSDCExchangeRate = cUSDC.exchangeRateCurrent();
//     uint256 redeemedUSDC = _cUSDCToUSDC(cUSDCExchangeRate, cUSDCAmount);

//     uint256 error = cUSDC.redeem(cUSDCAmount);
//     uint256 postRedeemUSDCBalance = usdc.balanceOf(address(this));
//     require(error == 0, "Sweep from compound failed");
//     require(postRedeemUSDCBalance.sub(preRedeemUSDCBalance) == redeemedUSDC, "Unexpected redeem amount");

//     uint256 interestAccrued = redeemedUSDC.sub(cBalance);
//     uint256 reserveAmount = interestAccrued.div(config.getReserveDenominator());
//     uint256 poolAmount = interestAccrued.sub(reserveAmount);

//     _collectInterestAndPrincipal(address(this), poolAmount, 0);

//     if (reserveAmount > 0) {
//       _sendToReserve(reserveAmount, address(cUSDC));
//     }

//     compoundBalance = 0;
//   }

//   function _cUSDCToUSDC(uint256 exchangeRate, uint256 amount) internal pure returns (uint256) {
//     // See https://compound.finance/docs#protocol-math
//     // But note, the docs and reality do not agree. Docs imply that that exchange rate is
//     // scaled by 1e18, but tests and mainnet forking make it appear to be scaled by 1e16
//     // 1e16 is also what Sheraz at Certik said.
//     uint256 usdcDecimals = 6;
//     uint256 cUSDCDecimals = 8;

//     // We multiply in the following order, for the following reasons...
//     // Amount in cToken (1e8)
//     // Amount in USDC (but scaled by 1e16, cause that's what exchange rate decimals are)
//     // Downscale to cToken decimals (1e8)
//     // Downscale from cToken to USDC decimals (8 to 6)
//     return amount.mul(exchangeRate).div(10**(18 + usdcDecimals - cUSDCDecimals)).div(10**2);
//   }

  function _collectInterestAndPrincipal(
    address from,
    uint256 interest,
    uint256 principal
  ) internal {
    uint256 increment = _usdcToSharePrice(interest);
    sharePrice = sharePrice + increment;

    if (interest > 0) {
      emit InterestCollected(from, interest);
    }
    if (principal > 0) {
      emit PrincipalCollected(from, principal);
      totalLoansOutstanding = totalLoansOutstanding - principal;
    }
  }

  function _sendToReserve(uint256 amount, address userForEvent) internal {
    emit ReserveFundsCollected(userForEvent, amount);
    bool success = doUSDCTransfer(address(this), config.reserveAddress(), amount);
    require(success, "Reserve transfer was not successful");
  }

  function _usdcToSharePrice(uint256 usdcAmount) internal view returns (uint256) {
    return _usdcToFidu(usdcAmount) * _fiduMantissa() / totalShares();
  }

  function totalShares() internal view returns (uint256) {
    return config.getSeniorLP().totalSupply();
  }

  function _isValidPool(IOvenueJuniorPool pool) internal view returns (bool) {
    return config.getJuniorLP().validPool(address(pool));
  }

  function _approvePool(IOvenueJuniorPool pool, uint256 allowance) internal {
    IERC20withDec usdc = config.getUSDC();
    bool success = usdc.approve(address(pool), allowance);
    require(success, "Failed to approve USDC");
  }

  function isZapper() public view returns (bool) {
    return hasRole(ZAPPER_ROLE, _msgSender());
  }

  function initZapperRole() external onlyAdmin {
    _setRoleAdmin(ZAPPER_ROLE, OWNER_ROLE);
  }

  /// @notice Returns the senion tranche id for the given slice index
  /// @param index slice index
  /// @return senior tranche id of given slice index
  function _sliceIndexToSeniorTrancheId(uint256 index) internal pure returns (uint256) {
    return index * 2 + 1;
  }
}