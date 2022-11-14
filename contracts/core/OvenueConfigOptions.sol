// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

/**
 * @title ConfigOptions
 * @notice A central place for enumerating the configurable options of our GoldfinchConfig contract
 * @author Goldfinch
 */

library OvenueConfigOptions {
  // NEVER EVER CHANGE THE ORDER OF THESE!
  // You can rename or append. But NEVER change the order.
  enum Numbers {
    TransactionLimit, // 0
    /// @dev: TotalFundsLimit used to represent a total cap on senior pool deposits
    /// but is now deprecated
    TotalFundsLimit, // 1
    MaxUnderwriterLimit, // 2
    ReserveDenominator, // 3
    WithdrawFeeDenominator, // 4
    LatenessGracePeriodInDays, // 5
    LatenessMaxDays, // 6
    DrawdownPeriodInSeconds, // 7
    TransferRestrictionPeriodInDays, // 8
    LeverageRatio, // 9
    CollateralLockedUpInSeconds, // 10
    CollateralVotingDelay, // 11
    CollateralVotingPeriod, // 12
    CollateralVotingQuorumNumerator // 13,
  }
  /// @dev TrustedForwarder is deprecated because we no longer use GSN. CreditDesk
  ///   and Pool are deprecated because they are no longer used in the protocol.
  enum Addresses {
    CreditLineImplementation, // 0
    OvenueFactory, // 1
    Fidu, // 2
    USDC, // 3
    OVENUE, // 4
    TreasuryReserve, // 5
    ProtocolAdmin, // 6
    // OneInch,
    // CUSDCContract,
    OvenueConfig, // 7
    PoolTokens, // 8
    SeniorPool, // 9
    SeniorPoolStrategy, // 10
    TranchedPoolImplementation, // 11
    BorrowerImplementation, // 12
    // OVENUE, 
    Go, // 13
    JuniorRewards, // 14
    CollateralToken, // 15
    CollateralCustody, // 16
    CollateralGovernanceImplementation, // 17
    OvenueExchange // 18
    // StakingRewards
    // FiduUSDCCurveLP
  }
}