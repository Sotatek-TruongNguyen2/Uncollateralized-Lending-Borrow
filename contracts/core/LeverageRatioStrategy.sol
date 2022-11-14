// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "../upgradeable/BaseUpgradeablePausable.sol";
import "../libraries/OvenueConfigHelper.sol";
import "../interfaces/IOvenueSeniorPoolStrategy.sol";
import "../interfaces/IOvenueSeniorPool.sol";
import "../interfaces/IOvenueJuniorPool.sol";
import "hardhat/console.sol";

abstract contract LeverageRatioStrategy is BaseUpgradeablePausable, IOvenueSeniorPoolStrategy {

  uint256 internal constant LEVERAGE_RATIO_DECIMALS = 1e18;

  /**
   * @notice Determines how much money to invest in the senior tranche based on what is committed to the junior
   * tranche, what is committed to the senior tranche, and a leverage ratio to the junior tranche. Because
   * it takes into account what is already committed to the senior tranche, the value returned by this
   * function can be used "idempotently" to achieve the investment target amount without exceeding that target.
   * @param pool The tranched pool to invest into (as the senior)
   * @return The amount of money to invest into the tranched pool's senior tranche, from the senior pool
   */
  function invest(IOvenueJuniorPool pool) public view override returns (uint256) {
    uint256 nSlices = pool.numSlices();
    // If the pool has no slices, we cant invest
    if (nSlices == 0) {
      return 0;
    }
    uint256 sliceIndex = nSlices - 1;
    (
      IOvenueJuniorPool.TrancheInfo memory juniorTranche,
      IOvenueJuniorPool.TrancheInfo memory seniorTranche
    ) = _getTranchesInSlice(pool, sliceIndex);
    // console.log("THERE: ", juniorTranche.lockedUntil);
    // If junior capital is not yet invested, or pool already locked, then don't invest anything.
    if (juniorTranche.lockedUntil == 0 || seniorTranche.lockedUntil > 0) {
      return 0;
    }

    // return _invest(pool, juniorTranche, seniorTranche);
    return _invest(juniorTranche, seniorTranche);
  }

  /**
   * @notice A companion of `invest()`: determines how much would be returned by `invest()`, as the
   * value to invest into the senior tranche, if the junior tranche were locked and the senior tranche
   * were not locked.
   * @param pool The tranched pool to invest into (as the senior)
   * @return The amount of money to invest into the tranched pool's senior tranche, from the senior pool
   */
  function estimateInvestment(IOvenueJuniorPool pool) public view override returns (uint256) {
    uint256 nSlices = pool.numSlices();
    // If the pool has no slices, we cant invest
    if (nSlices == 0) {
      return 0;
    }
    uint256 sliceIndex = nSlices - 1;
    (
      IOvenueJuniorPool.TrancheInfo memory juniorTranche,
      IOvenueJuniorPool.TrancheInfo memory seniorTranche
    ) = _getTranchesInSlice(pool, sliceIndex);

    // return _invest(pool, juniorTranche, seniorTranche);
    return _invest(juniorTranche, seniorTranche);
  }

  function _invest(
    // IOvenueJuniorPool pool,
    IOvenueJuniorPool.TrancheInfo memory juniorTranche,
    IOvenueJuniorPool.TrancheInfo memory seniorTranche
  ) internal view returns (uint256) {
    uint256 juniorCapital = juniorTranche.principalDeposited;
    uint256 existingSeniorCapital = seniorTranche.principalDeposited;
    
    uint256 seniorTarget = juniorCapital * (getLeverageRatio() / LEVERAGE_RATIO_DECIMALS);
    if (existingSeniorCapital >= seniorTarget) {
      return 0;
    }

    return seniorTarget - existingSeniorCapital;
  }

  /// @notice Return the junior and senior tranches from a given pool in a specified slice
  /// @param pool pool to fetch tranches from
  /// @param sliceIndex slice index to fetch tranches from
  /// @return (juniorTranche, seniorTranche)
  function _getTranchesInSlice(IOvenueJuniorPool pool, uint256 sliceIndex)
    internal
    view
    returns (
      IOvenueJuniorPool.TrancheInfo memory, // junior tranche
      IOvenueJuniorPool.TrancheInfo memory // senior tranche
    )
  {
    uint256 juniorTrancheId = _sliceIndexToJuniorTrancheId(sliceIndex);
    uint256 seniorTrancheId = _sliceIndexToSeniorTrancheId(sliceIndex);

    IOvenueJuniorPool.TrancheInfo memory juniorTranche = pool.getTranche(juniorTrancheId);
    IOvenueJuniorPool.TrancheInfo memory seniorTranche = pool.getTranche(seniorTrancheId);
    return (juniorTranche, seniorTranche);
  }

  /// @notice Returns the junior tranche id for the given slice index
  /// @param index slice index
  /// @return junior tranche id of given slice index
  function _sliceIndexToJuniorTrancheId(uint256 index) internal pure returns (uint256) {
    return index * 2 + 2;
  }

  /// @notice Returns the senion tranche id for the given slice index
  /// @param index slice index
  /// @return senior tranche id of given slice index
  function _sliceIndexToSeniorTrancheId(uint256 index) internal pure returns (uint256) {
    return index * 2 + 1;
  }
}