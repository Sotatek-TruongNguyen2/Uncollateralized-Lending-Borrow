// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import {IV2OvenueCreditLine} from "./IV2OvenueCreditLine.sol";

abstract contract IOvenueJuniorPool {
    IV2OvenueCreditLine public creditLine;
    uint256 public createdAt;

     struct Collateral {
        address nftAddr;
        uint tokenId;
        uint collateralAmount;
        bool isLocked;
    }

    enum Tranches {
        Reserved,
        Senior,
        Junior
    }

    struct TrancheInfo {
        uint256 id;
        uint256 principalDeposited;
        uint256 principalSharePrice;
        uint256 interestSharePrice;
        uint256 lockedUntil;
    }

    struct PoolSlice {
        TrancheInfo seniorTranche;
        TrancheInfo juniorTranche;
        uint256 totalInterestAccrued;
        uint256 principalDeployed;
        uint256 collateralDeposited;
    }

    function initialize(
        // config - borrower
        address[2] calldata _addresses,
        // junior fee percent - late fee apr, interest apr
        uint256[3] calldata _fees,
        // _paymentPeriodInDays - _termInDays - _principalGracePeriodInDays - _fundableAt
        uint256[4] calldata _days,
        uint256 _limit,
        uint256[] calldata _allowedUIDTypes
    ) external virtual;

    function getTranche(uint256 tranche)
        external
        view
        virtual
        returns (TrancheInfo memory);

    function pay(uint256 amount) external virtual;

    function poolSlices(uint256 index)
        external
        view
        virtual
        returns (PoolSlice memory);

    function cancel() external virtual;

    function setCancelStatus(bool status) external virtual;

    function lockJuniorCapital() external virtual;

    function lockPool() external virtual;

    function initializeNextSlice(uint256 _fundableAt) external virtual;

    function totalJuniorDeposits() external view virtual returns (uint256);

    function drawdown(uint256 amount) external virtual;

    function setFundableAt(uint256 timestamp) external virtual;

    function deposit(uint256 tranche, uint256 amount)
        external
        virtual
        returns (uint256 tokenId);

    function assess() external virtual;

    function depositWithPermit(
        uint256 tranche,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual returns (uint256 tokenId);

    function availableToWithdraw(uint256 tokenId)
        external
        view
        virtual
        returns (uint256 interestRedeemable, uint256 principalRedeemable);

    function withdraw(uint256 tokenId, uint256 amount)
        external
        virtual
        returns (uint256 interestWithdrawn, uint256 principalWithdrawn);

    function withdrawMax(uint256 tokenId)
        external
        virtual
        returns (uint256 interestWithdrawn, uint256 principalWithdrawn);

    function withdrawMultiple(
        uint256[] calldata tokenIds,
        uint256[] calldata amounts
    ) external virtual;

    // function claimCollateralNFT() external virtual;

    function numSlices() external view virtual returns (uint256);
    // function isCollateralLocked() external view virtual returns (bool);

    // function getCollateralInfo() external view virtual returns(address, uint, bool);
}
