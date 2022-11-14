// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import {IOvenueJuniorRewards} from "../interfaces/IOvenueJuniorRewards.sol";
import {IOvenueJuniorPool} from "../interfaces/IOvenueJuniorPool.sol";
import {IOvenueJuniorLP} from "../interfaces/IOvenueJuniorLP.sol";
import {IOvenueConfig} from "../interfaces/IOvenueConfig.sol";
import {IERC20withDec} from "../interfaces/IERC20withDec.sol";
import {OvenueTranchingLogic} from "./OvenueTranchingLogic.sol";
import {OvenueConfigHelper} from "./OvenueConfigHelper.sol";
import {IV2OvenueCreditLine} from "../interfaces/IV2OvenueCreditLine.sol";
import {IGo} from "../interfaces/IGo.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "./Math.sol";
import "hardhat/console.sol";

library OvenueJuniorPoolLogic {
    using OvenueTranchingLogic for IOvenueJuniorPool.PoolSlice;
    using OvenueTranchingLogic for IOvenueJuniorPool.TrancheInfo;
    using OvenueConfigHelper for IOvenueConfig;
    using SafeERC20Upgradeable for IERC20withDec;

    event ReserveFundsCollected(address indexed from, uint256 amount);

    event PaymentApplied(
        address indexed payer,
        address indexed pool,
        uint256 interestAmount,
        uint256 principalAmount,
        uint256 remainingAmount,
        uint256 reserveAmount
    );

    event DepositMade(
        address indexed owner,
        uint256 indexed tranche,
        uint256 indexed tokenId,
        uint256 amount
    );

    event WithdrawalMade(
        address indexed owner,
        uint256 indexed tranche,
        uint256 indexed tokenId,
        uint256 interestWithdrawn,
        uint256 principalWithdrawn
    );

    event SharePriceUpdated(
        address indexed pool,
        uint256 indexed tranche,
        uint256 principalSharePrice,
        int256 principalDelta,
        uint256 interestSharePrice,
        int256 interestDelta
    );

    event DrawdownMade(address indexed borrower, uint256 amount);
    event EmergencyShutdown(address indexed pool);
    event SliceCreated(address indexed pool, uint256 sliceId);

    function pay(
         mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        // IV2OvenueCreditLine creditLine,
        // IOvenueConfig config,
        // creditline - config
        address[2] calldata addresses,
        // numSlices - totalDeployed - juniorFeePercent - amount
        uint256[4] memory uints
    ) external returns(uint) {
        uint paymentAmount = uints[3];
        /// @dev  IA: cannot pay 0
        require(paymentAmount > 0, "IA");
        IOvenueConfig(addresses[1]).getUSDC().safeTransferFrom(msg.sender, addresses[0], paymentAmount);
        return assess(
            _poolSlices,
            addresses,
            [uints[0], uints[1], uints[2]]
        );
    }

    function deposit(
        IOvenueJuniorPool.TrancheInfo storage trancheInfo,
        IOvenueConfig config,
        uint256 amount
    ) external returns (uint256) {
        trancheInfo.principalDeposited =
            trancheInfo.principalDeposited +
            amount;

        uint256 tokenId = config.getJuniorLP().mint(
            IOvenueJuniorLP.MintParams({
                tranche: trancheInfo.id,
                principalAmount: amount
            }),
            msg.sender
        );

        config.getUSDC().safeTransferFrom(msg.sender, address(this), amount);
        emit DepositMade(msg.sender, trancheInfo.id, tokenId, amount);
        return tokenId;
    }

    function withdraw(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 numSlices,
        uint256 tokenId,
        uint256 amount,
        IOvenueConfig config
    ) public returns (uint256, uint256) {
        IOvenueJuniorLP.TokenInfo memory tokenInfo = config
            .getJuniorLP()
            .getTokenInfo(tokenId);
        IOvenueJuniorPool.TrancheInfo storage trancheInfo = _getTrancheInfo(
            _poolSlices,
            numSlices,
            tokenInfo.tranche
        );

        /// @dev IA: invalid amount. Cannot withdraw 0
        require(amount > 0, "IA");
        (
            uint256 interestRedeemable,
            uint256 principalRedeemable
        ) = OvenueTranchingLogic.redeemableInterestAndPrincipal(
                trancheInfo,
                tokenInfo
            );
        uint256 netRedeemable = interestRedeemable + principalRedeemable;
        /// @dev IA: invalid amount. User does not have enough available to redeem
        require(amount <= netRedeemable, "IA");
        /// @dev TL: Tranched Locked
        require(block.timestamp > trancheInfo.lockedUntil, "TL");

        uint256 interestToRedeem = 0;
        uint256 principalToRedeem = 0;

        // If the tranche has not been locked, ensure the deposited amount is correct
        if (trancheInfo.lockedUntil == 0) {
            trancheInfo.principalDeposited =
                trancheInfo.principalDeposited -
                amount;

            principalToRedeem = amount;

            config.getJuniorLP().withdrawPrincipal(tokenId, principalToRedeem);
        } else {
            interestToRedeem = Math.min(interestRedeemable, amount);
            principalToRedeem = Math.min(
                principalRedeemable,
                amount - interestToRedeem
            );

            config.getJuniorLP().redeem(
                tokenId,
                principalToRedeem,
                interestToRedeem
            );
        }

        config.getUSDC().safeTransferFrom(
            address(this),
            msg.sender,
            principalToRedeem + interestToRedeem
        );

        emit WithdrawalMade(
            msg.sender,
            tokenInfo.tranche,
            tokenId,
            interestToRedeem,
            principalToRedeem
        );

        return (interestToRedeem, principalToRedeem);
    }

    function withdrawMax(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 numSlices,
        uint256 tokenId,
        IOvenueConfig config
    ) external returns (uint256, uint256) {
        IOvenueJuniorLP.TokenInfo memory tokenInfo = config
            .getJuniorLP()
            .getTokenInfo(tokenId);
        IOvenueJuniorPool.TrancheInfo storage trancheInfo = _getTrancheInfo(
            _poolSlices,
            numSlices,
            tokenInfo.tranche
        );

        (
            uint256 interestRedeemable,
            uint256 principalRedeemable
        ) = OvenueTranchingLogic.redeemableInterestAndPrincipal(
                trancheInfo,
                tokenInfo
            );

        uint256 amount = interestRedeemable + principalRedeemable;

        return withdraw(_poolSlices, numSlices, tokenId, amount, config);
    }

    function drawdown(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        IV2OvenueCreditLine creditLine,
        IOvenueConfig config,
        uint256 numSlices,
        uint256 amount,
        uint256 totalDeployed
    ) external returns (uint256) {
        if (!_locked(_poolSlices, numSlices)) {
            // Assumes the senior pool has invested already (saves the borrower a separate transaction to lock the pool)
            _lockPool(_poolSlices, creditLine, config, numSlices);
        }
        // Drawdown only draws down from the current slice for simplicity. It's harder to account for how much
        // money is available from previous slices since depositors can redeem after unlock.
        IOvenueJuniorPool.PoolSlice storage currentSlice = _poolSlices[
            numSlices - 1
        ];
        uint256 amountAvailable = OvenueTranchingLogic.sharePriceToUsdc(
            currentSlice.juniorTranche.principalSharePrice,
            currentSlice.juniorTranche.principalDeposited
        );
        amountAvailable =
            amountAvailable +
            (
                OvenueTranchingLogic.sharePriceToUsdc(
                    currentSlice.seniorTranche.principalSharePrice,
                    currentSlice.seniorTranche.principalDeposited
                )
            );

        console.log("Amount available: ", amountAvailable, amount);

        // @dev IF: insufficient funds
        require(amount <= amountAvailable, "IF");

        creditLine.drawdown(amount);
        // Update the share price to reflect the amount remaining in the pool
        uint256 amountRemaining = amountAvailable - amount;
        uint256 oldJuniorPrincipalSharePrice = currentSlice
            .juniorTranche
            .principalSharePrice;
        uint256 oldSeniorPrincipalSharePrice = currentSlice
            .seniorTranche
            .principalSharePrice;
        currentSlice.juniorTranche.principalSharePrice = currentSlice
            .juniorTranche
            .calculateExpectedSharePrice(amountRemaining, currentSlice);
        currentSlice.seniorTranche.principalSharePrice = currentSlice
            .seniorTranche
            .calculateExpectedSharePrice(amountRemaining, currentSlice);
        currentSlice.principalDeployed =
            currentSlice.principalDeployed +
            amount;
        totalDeployed = totalDeployed + amount;

        address borrower = creditLine.borrower();

        // _calcJuniorRewards(config, numSlices);
        config.getUSDC().safeTransferFrom(address(this), borrower, amount);

        emit DrawdownMade(borrower, amount);
        emit SharePriceUpdated(
            address(this),
            currentSlice.juniorTranche.id,
            currentSlice.juniorTranche.principalSharePrice,
            int256(
                oldJuniorPrincipalSharePrice -
                    currentSlice.juniorTranche.principalSharePrice
            ) * -1,
            currentSlice.juniorTranche.interestSharePrice,
            0
        );
        emit SharePriceUpdated(
            address(this),
            currentSlice.seniorTranche.id,
            currentSlice.seniorTranche.principalSharePrice,
            int256(
                oldSeniorPrincipalSharePrice -
                    currentSlice.seniorTranche.principalSharePrice
            ) * -1,
            currentSlice.seniorTranche.interestSharePrice,
            0
        );

        return totalDeployed;
    }

    // function _calcJuniorRewards(IOvenueConfig config, uint256 numSlices)
    //     internal
    // {
    //     IOvenueJuniorRewards juniorRewards = IOvenueJuniorRewards(
    //         config.juniorRewardsAddress()
    //     );
    //     juniorRewards.onTranchedPoolDrawdown(numSlices - 1);
    // }

    function _lockPool(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        IV2OvenueCreditLine creditLine,
        IOvenueConfig config,
        uint256 numSlices
    ) internal {
        IOvenueJuniorPool.PoolSlice storage slice = _poolSlices[numSlices - 1];
        /// @dev NL: Not locked
        require(slice.juniorTranche.lockedUntil > 0, "NL");
        // Allow locking the pool only once; do not allow extending the lock of an
        // already-locked pool. Otherwise the locker could keep the pool locked
        // indefinitely, preventing withdrawals.
        /// @dev TL: tranche locked. The senior pool has already been locked.
        require(slice.seniorTranche.lockedUntil == 0, "TL");

        uint256 currentTotal = slice.juniorTranche.principalDeposited +
            slice.seniorTranche.principalDeposited;
        creditLine.setLimit(
            Math.min(creditLine.limit() + currentTotal, creditLine.maxLimit())
        );

        // We start the drawdown period, so backers can withdraw unused capital after borrower draws down
        OvenueTranchingLogic.lockTranche(slice.juniorTranche, config);
        OvenueTranchingLogic.lockTranche(slice.seniorTranche, config);
    }

    function _locked(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 numSlices
    ) internal view returns (bool) {
        return
            numSlices == 0 ||
            _poolSlices[numSlices - 1].seniorTranche.lockedUntil > 0;
    }

    function locked(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 numSlices
    ) internal view returns (bool) {
        return _locked(_poolSlices, numSlices);
    }

    function lockPool(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        IV2OvenueCreditLine creditLine,
        IOvenueConfig config,
        uint256 numSlices
    ) external {
        _lockPool(_poolSlices, creditLine, config, numSlices);
    }

    function availableToWithdraw(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 numSlices,
        IOvenueConfig config,
        uint256 tokenId
    ) external view returns (uint256, uint256) {
        IOvenueJuniorLP.TokenInfo memory tokenInfo = config
            .getJuniorLP()
            .getTokenInfo(tokenId);

        IOvenueJuniorPool.TrancheInfo
            storage trancheInfo = OvenueJuniorPoolLogic._getTrancheInfo(
                _poolSlices,
                numSlices,
                tokenInfo.tranche
            );

        console.log("HERE: ", tokenId);

        if (block.timestamp > trancheInfo.lockedUntil) {
            return
                OvenueTranchingLogic.redeemableInterestAndPrincipal(
                    trancheInfo,
                    tokenInfo
                );
        } else {
            return (0, 0);
        }
    }

    function emergencyShutdown(
        IOvenueConfig config,
        IV2OvenueCreditLine creditLine
    ) external {
        IERC20withDec usdc = config.getUSDC();
        address reserveAddress = config.reserveAddress();
        // // Sweep any funds to community reserve
        uint256 poolBalance = usdc.balanceOf(address(this));
        if (poolBalance > 0) {
            config.getUSDC().safeTransfer(reserveAddress, poolBalance);
        }

        uint256 clBalance = usdc.balanceOf(address(creditLine));
        if (clBalance > 0) {
            usdc.safeTransferFrom(
                address(creditLine),
                reserveAddress,
                clBalance
            );
        }
        emit EmergencyShutdown(address(this));
    }

    function assess(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        // creditline - config
        address[2] calldata addresses,
        // numSlices - totalDeployed - juniorFeePercent
        uint256[3] memory uints
    )
        public
        returns (
            // total deployed
            uint256
        )
    {
        require(_locked(_poolSlices, uints[0]), "NL");

        uint256 interestAccrued = IV2OvenueCreditLine(addresses[0])
            .totalInterestAccrued();
        (
            uint256 paymentRemaining,
            uint256 interestPayment,
            uint256 principalPayment
        ) = IV2OvenueCreditLine(addresses[0]).assess();
        interestAccrued =
            IV2OvenueCreditLine(addresses[0]).totalInterestAccrued() -
            interestAccrued;

        uint256[] memory principalPaymentsPerSlice = _calcInterest(
            _poolSlices,
            interestAccrued,
            principalPayment,
            uints[1],
            uints[0]
        );

        if (interestPayment > 0 || principalPayment > 0) {
            // uint256[] memory uintParams = new uint256[](5);
            uint256 reserveAmount = _applyToAllSlices(
                _poolSlices,
                [
                    uints[0],
                    interestPayment,
                    principalPayment + paymentRemaining,
                    uints[1],
                    uints[2]
                ],
                addresses
            );

            IOvenueConfig(addresses[1]).getUSDC().safeTransferFrom(
                addresses[0],
                address(this),
                principalPayment + paymentRemaining + interestPayment
            );
            IOvenueConfig(addresses[1]).getUSDC().safeTransferFrom(
                address(this),
                IOvenueConfig(addresses[1]).reserveAddress(),
                reserveAmount
            );

            emit ReserveFundsCollected(address(this), reserveAmount);

            // i < numSlices
            for (uint256 i = 0; i < uints[0]; i++) {
                _poolSlices[i].principalDeployed =
                    _poolSlices[i].principalDeployed -
                    principalPaymentsPerSlice[i];
                // totalDeployed = totalDeployed - principalPaymentsPerSlice[i];
                uints[1] = uints[1] - principalPaymentsPerSlice[i];
            }

            IOvenueConfig(addresses[1]).getJuniorRewards().allocateRewards(
                interestPayment
            );

            emit PaymentApplied(
                IV2OvenueCreditLine(addresses[0]).borrower(),
                address(this),
                interestPayment,
                principalPayment,
                paymentRemaining,
                reserveAmount
            );
        }

        // totaldeployed - uints[1]
        return uints[1];
    }

    function _applyToAllSlices(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        // numSlices - interest - principal - totalDeployed  - JuniorFeePercent
        uint256[5] memory uints,
        // creditline - config
        address[2] calldata addresses
    )
        internal
        returns (
            // IV2OvenueCreditLine creditLine
            uint256
        )
    {
        return
            OvenueTranchingLogic.applyToAllSlices(
                _poolSlices,
                uints[0],
                uints[1],
                uints[2],
                uint256(100) / (IOvenueConfig(addresses[1]).getReserveDenominator()), // Convert the denonminator to percent
                uints[3],
                IV2OvenueCreditLine(addresses[0]),
                uints[4]
            );
    }

    function _calcInterest(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 interestAccrued,
        uint256 principalPayment,
        uint256 totalDeployed,
        uint256 numSlices
    ) internal returns (uint256[] memory principalPaymentsPerSlice) {
        principalPaymentsPerSlice = new uint256[](numSlices);

        for (uint256 i = 0; i < numSlices; i++) {
            uint256 interestForSlice = OvenueTranchingLogic.scaleByFraction(
                interestAccrued,
                _poolSlices[i].principalDeployed,
                totalDeployed
            );
            principalPaymentsPerSlice[i] = OvenueTranchingLogic.scaleByFraction(
                principalPayment,
                _poolSlices[i].principalDeployed,
                totalDeployed
            );
            _poolSlices[i].totalInterestAccrued =
                _poolSlices[i].totalInterestAccrued +
                interestForSlice;
        }
    }

    function _getTrancheInfo(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 numSlices,
        uint256 trancheId
    ) internal view returns (IOvenueJuniorPool.TrancheInfo storage) {
        require(
            trancheId > 0 &&
                trancheId <= numSlices * OvenueTranchingLogic.NUM_TRANCHES_PER_SLICE,
            "invalid tranche"
        );
        uint256 sliceId = OvenueTranchingLogic.trancheIdToSliceIndex(trancheId);
        IOvenueJuniorPool.PoolSlice storage slice = _poolSlices[sliceId];
        IOvenueJuniorPool.TrancheInfo storage trancheInfo = OvenueTranchingLogic
            .isSeniorTrancheId(trancheId)
            ? slice.seniorTranche
            : slice.juniorTranche;
        return trancheInfo;
    }

    function getTrancheInfo(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 numSlices,
        uint256 trancheId
    ) external view returns (IOvenueJuniorPool.TrancheInfo storage) {
        return _getTrancheInfo(_poolSlices, numSlices, trancheId);
    }

    function initializeNextSlice(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 numSlices
    ) public returns (uint256) {
        /// @dev SL: slice limit
        require(numSlices < 2, "SL");
        OvenueTranchingLogic.initializeNextSlice(_poolSlices, numSlices);
        numSlices = numSlices + 1;

        return numSlices;
    }

    function initializeAnotherNextSlice(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        IV2OvenueCreditLine creditLine,
        uint256 numSlices
    ) external returns (uint256) {
        /// @dev NL: not locked
        require(_locked(_poolSlices, numSlices), "NL");
        /// @dev LP: late payment
        require(!creditLine.isLate(), "LP");
        /// @dev GP: beyond principal grace period
        require(creditLine.withinPrincipalGracePeriod(), "GP");
        emit SliceCreated(address(this), numSlices - 1);
        return initializeNextSlice(_poolSlices, numSlices);
    }

    function initialize(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 numSlices,
        IOvenueConfig config,
        address _borrower,
        // junior fee percent - late fee apr, interest apr
        uint256[3] calldata _fees,
        // _paymentPeriodInDays - _termInDays - _principalGracePeriodInDays - _fundableAt
        uint256[4] calldata _days,
        uint256 _limit
    )
        external
        returns (
            uint256,
            IV2OvenueCreditLine
        )
    {
        uint256 adjustedNumSlices = initializeNextSlice(
            _poolSlices,
            numSlices
        );

        IV2OvenueCreditLine creditLine = creditLineInitialize(
            config,
            _borrower,
            _fees,
            _days,
            _limit
        );

        return (adjustedNumSlices, creditLine);
    }

    function creditLineInitialize(
        IOvenueConfig config,
        address _borrower,
        // junior fee percent - late fee apr, interest apr
        uint256[3] calldata _fees,
        // _paymentPeriodInDays - _termInDays - _principalGracePeriodInDays - _fundableAt
        uint256[4] calldata _days,
        uint256 _maxLimit
    ) internal returns (IV2OvenueCreditLine) {
        IV2OvenueCreditLine creditLine = IV2OvenueCreditLine(
            config.getOvenueFactory().createCreditLine()
        );

        creditLine.initialize(
            address(config),
            address(this), // Set self as the owner
            _borrower,
            _maxLimit,
            _fees[2],
            _days[0],
            _days[1],
            _fees[1],
            _days[2]
        );

        return creditLine;
    }

    function lockJuniorCapital(
        mapping(uint256 => IOvenueJuniorPool.PoolSlice) storage _poolSlices,
        uint256 numSlices,
        IOvenueConfig config,
        uint256 sliceId
    ) external {
        // /// @dev TL: Collateral locked
        require(config.getCollateralCustody().isCollateralFullyFunded(IOvenueJuniorPool(address(this))), "Not fully funded!");

        /// @dev TL: tranch locked
        require(
            !_locked(_poolSlices, numSlices) &&
                _poolSlices[sliceId].juniorTranche.lockedUntil == 0,
            "TL"
        );

        OvenueTranchingLogic.lockTranche(_poolSlices[sliceId].juniorTranche, config);
    }
}
