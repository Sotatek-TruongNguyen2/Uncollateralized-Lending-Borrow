// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "../interfaces/IOvenueCreditLine.sol";
import "../libraries/WadRayMath.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol";
import "hardhat/console.sol";
/**
 * @title The Accountant`
 * @notice Library for handling key financial calculations, such as interest and principal accrual.
 * @author Goldfinch
 */

library Accountant {
  using WadRayMath for int256;
  using WadRayMath for uint256;

  // Scaling factor used by FixedPoint.sol. We need this to convert the fixed point raw values back to unscaled
  uint256 private constant INTEREST_DECIMALS = 1e18;
  uint256 private constant SECONDS_PER_DAY = 1 days;
  uint256 private constant SECONDS_PER_YEAR = (SECONDS_PER_DAY * 365);

  struct PaymentAllocation {
    uint256 interestPayment;
    uint256 principalPayment;
    uint256 additionalBalancePayment;
  }

  function calculateInterestAndPrincipalAccrued(
    IOvenueCreditLine cl,
    uint256 timestamp,
    uint256 lateFeeGracePeriod
  ) public view returns (uint256, uint256) {
    uint256 balance = cl.balance(); // gas optimization
    uint256 interestAccrued = calculateInterestAccrued(cl, balance, timestamp, lateFeeGracePeriod);
    uint256 principalAccrued = calculatePrincipalAccrued(cl, balance, timestamp);
    return (interestAccrued, principalAccrued);
  }

  function calculateInterestAndPrincipalAccruedOverPeriod(
    IOvenueCreditLine cl,
    uint256 balance,
    uint256 startTime,
    uint256 endTime,
    uint256 lateFeeGracePeriod
  ) public view returns (uint256, uint256) {
    uint256 interestAccrued = calculateInterestAccruedOverPeriod(cl, balance, startTime, endTime, lateFeeGracePeriod);
    uint256 principalAccrued = calculatePrincipalAccrued(cl, balance, endTime);
    return (interestAccrued, principalAccrued);
  }

  function calculatePrincipalAccrued(
    IOvenueCreditLine cl,
    uint256 balance,
    uint256 timestamp
  ) public view returns (uint256) {
    // If we've already accrued principal as of the term end time, then don't accrue more principal
    uint256 termEndTime = cl.termEndTime();
    if (cl.interestAccruedAsOf() >= termEndTime) {
      return 0;
    }
    if (timestamp >= termEndTime) {
      return balance;
    } else {
      return 0;
    }
  }

  function calculateWritedownFor(
    IOvenueCreditLine cl,
    uint256 timestamp,
    uint256 gracePeriodInDays,
    uint256 maxDaysLate
  ) public view returns (uint256, uint256) {
    return calculateWritedownForPrincipal(cl, cl.balance(), timestamp, gracePeriodInDays, maxDaysLate);
  }

  function calculateWritedownForPrincipal(
    IOvenueCreditLine cl,
    uint256 principal,
    uint256 timestamp,
    uint256 gracePeriodInDays,
    uint256 maxDaysLate
  ) public view returns (uint256, uint256) {
    uint256 amountOwedPerDay = calculateAmountOwedForOneDay(cl);
    if (amountOwedPerDay == 0) {
      return (0, 0);
    }
    uint256 daysLate;

    // Excel math: =min(1,max(0,periods_late_in_days-graceperiod_in_days)/MAX_ALLOWED_DAYS_LATE) grace_period = 30,
    // Before the term end date, we use the interestOwed to calculate the periods late. However, after the loan term
    // has ended, since the interest is a much smaller fraction of the principal, we cannot reliably use interest to
    // calculate the periods later.
    uint256 totalOwed = cl.interestOwed() + cl.principalOwed();
    daysLate = totalOwed.wadDiv(amountOwedPerDay);
    if (timestamp > cl.termEndTime()) {
      uint256 secondsLate = timestamp- cl.termEndTime();
      daysLate = daysLate + secondsLate / SECONDS_PER_DAY;
    }

    uint256 writedownPercent;
    if (daysLate <= gracePeriodInDays) {
      // Within the grace period, we don't have to write down, so assume 0%
      writedownPercent = 0;
    } else {
      writedownPercent = MathUpgradeable.min(WadRayMath.WAD, (daysLate - gracePeriodInDays).wadDiv(maxDaysLate));
    }

    uint256 writedownAmount = writedownPercent.wadMul(principal);
    // This will return a number between 0-100 representing the write down percent with no decimals
    uint256 unscaledWritedownPercent = writedownPercent.wadMul(100);
    return (unscaledWritedownPercent, writedownAmount);
  }

  function calculateAmountOwedForOneDay(IOvenueCreditLine cl) public view returns (uint256 interestOwed) {
    // Determine theoretical interestOwed for one full day
    uint256 totalInterestPerYear = cl.balance().wadMul(cl.interestApr());
    interestOwed = totalInterestPerYear.wadDiv(365);
    return interestOwed;
  }

  function calculateInterestAccrued(
    IOvenueCreditLine cl,
    uint256 balance,
    uint256 timestamp,
    uint256 lateFeeGracePeriodInDays
  ) public view returns (uint256) {
    // We use Math.min here to prevent integer overflow (ie. go negative) when calculating
    // numSecondsElapsed. Typically this shouldn't be possible, because
    // the interestAccruedAsOf couldn't be *after* the current timestamp. However, when assessing
    // we allow this function to be called with a past timestamp, which raises the possibility
    // of overflow.
    // This use of min should not generate incorrect interest calculations, since
    // this function's purpose is just to normalize balances, and handing in a past timestamp
    // will necessarily return zero interest accrued (because zero elapsed time), which is correct.
    uint256 startTime = MathUpgradeable.min(timestamp, cl.interestAccruedAsOf());
    return calculateInterestAccruedOverPeriod(cl, balance, startTime, timestamp, lateFeeGracePeriodInDays);
  }

  function calculateInterestAccruedOverPeriod(
    IOvenueCreditLine cl,
    uint256 balance,
    uint256 startTime,
    uint256 endTime,
    uint256 lateFeeGracePeriodInDays
  ) public view returns (uint256 interestOwed) {
    uint256 secondsElapsed = endTime - startTime;
    uint256 totalInterestPerYear = balance * cl.interestApr() / INTEREST_DECIMALS;
    interestOwed = totalInterestPerYear * secondsElapsed / SECONDS_PER_YEAR;
    if (lateFeeApplicable(cl, endTime, lateFeeGracePeriodInDays)) {
      console.log("Apply late fee: ", balance, cl.lateFeeApr());
      uint256 lateFeeInterestPerYear = balance * cl.lateFeeApr() / INTEREST_DECIMALS;
      uint256 additionalLateFeeInterest = lateFeeInterestPerYear * secondsElapsed / SECONDS_PER_YEAR;
      console.log("Additional interest: ", endTime, startTime, additionalLateFeeInterest);
      interestOwed = interestOwed + additionalLateFeeInterest;
    }

    return interestOwed;
  }

  function lateFeeApplicable(
    IOvenueCreditLine cl,
    uint256 timestamp,
    uint256 gracePeriodInDays
  ) public view returns (bool) {
    uint256 secondsLate = timestamp - cl.lastFullPaymentTime();
    return cl.lateFeeApr() > 0 && secondsLate > gracePeriodInDays * SECONDS_PER_DAY;
  }

  function allocatePayment(
    uint256 paymentAmount,
    uint256 balance,
    uint256 interestOwed,
    uint256 principalOwed
  ) public pure returns (PaymentAllocation memory) {
    uint256 paymentRemaining = paymentAmount;
    uint256 interestPayment = MathUpgradeable.min(interestOwed, paymentRemaining);
    paymentRemaining = paymentRemaining - interestPayment;

    uint256 principalPayment = MathUpgradeable.min(principalOwed, paymentRemaining);
    paymentRemaining = paymentRemaining - principalPayment;

    uint256 balanceRemaining = balance - principalPayment;
    uint256 additionalBalancePayment = MathUpgradeable.min(paymentRemaining, balanceRemaining);

    return
      PaymentAllocation({
        interestPayment: interestPayment,
        principalPayment: principalPayment,
        additionalBalancePayment: additionalBalancePayment
      });
  }
}