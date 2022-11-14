pragma solidity 0.8.5;

import "../interfaces/IOvenueCollateralCustody.sol";
import "../interfaces/IOvenueExchange.sol";
import "../interfaces/IOvenueConfig.sol";

import "../libraries/OvenueConfigHelper.sol";
import "hardhat/console.sol";

library OvenueCollateralCustodyLogic {
    using OvenueConfigHelper for IOvenueConfig;

    error InvalidPoolGovernor();
    error NotExceedsLatenessGracePeriod();

    uint public constant INVERSE_BASIS_POINT = 10000;

    event JuniorPoolDebtRecover(
        address indexed poolAddr,
        uint256 totalOwned,
        uint256 timestamp
    );

    function recoverLossFundsForInvestors(
        IOvenueConfig config,
        IOvenueJuniorPool pool,
        IOvenueExchange exchange,
        IOvenueCollateralCustody.NFTLiquidationOrder memory liquidationOrder,
        IOvenueCollateralCustody.Collateral storage collateral,
        IOvenueCollateralCustody.CollateralStatus storage collateralStatus,
        bool usingFungible
    ) external {
        // if (collateral.governor != msg.sender) {
        //     revert InvalidPoolGovernor();
        // }

        // Check if latesness grace period is passed
        _notExceedsLatenessGracePeriod(pool, config);

        // Get total owned and get the condition of distribute liquidation
        IV2OvenueCreditLine creditLine = pool.creditLine();
        uint loanBalance = creditLine.balance();

        if (loanBalance > 0) {
            pool.assess();
        }

        uint totalOwned = creditLine.interestOwed() + creditLine.principalOwed();
        console.log("Total owned: ", totalOwned);
        // check if liquidation amount of pool is still enough for covering debt
        if (!usingFungible) {
            bytes32 orderHash = liquidationOrder.orderHash;
            bool isFullfilled = exchange.cancelledOrFinalized(orderHash);
            
            if (!liquidationOrder.fullfilled && isFullfilled) {
                liquidationOrder.fullfilled = true;
                collateralStatus.fundedNonfungibleAmount = liquidationOrder.price * (INVERSE_BASIS_POINT - liquidationOrder.makerFee) / INVERSE_BASIS_POINT;
            }
            
            collateralStatus.fundedNonfungibleAmount -= totalOwned;
        } else {
            collateralStatus.fundedFungibleAmount -= totalOwned;
        }
        

        // Approve USDC for creditline contract for assessing
        config.getUSDC().approve(
            address(pool),
            totalOwned
        );

        pool.pay(
            totalOwned
        );

        emit JuniorPoolDebtRecover(
            address(pool),
            totalOwned,
            block.timestamp
        );
    }

    function _notExceedsLatenessGracePeriod(IOvenueJuniorPool poolAddr, IOvenueConfig config) internal view {
        IV2OvenueCreditLine creditLine = poolAddr.creditLine();

        if (creditLine.lastFullPaymentTime() + config.getLatenessGracePeriodInDays() > block.timestamp) {
            revert NotExceedsLatenessGracePeriod();
        }
    }
}