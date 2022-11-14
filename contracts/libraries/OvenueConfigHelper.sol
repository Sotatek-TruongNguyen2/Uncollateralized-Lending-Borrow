// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

// import {ImplementationRepository} from "./proxy/ImplementationRepository.sol";
import {OvenueConfigOptions} from "../core/OvenueConfigOptions.sol";

import {IOvenueCollateralCustody} from "../interfaces/IOvenueCollateralCustody.sol";

import {IOvenueConfig} from "../interfaces/IOvenueConfig.sol";
import {IOvenueSeniorLP} from "../interfaces/IOvenueSeniorLP.sol";
import {IOvenueSeniorPool} from "../interfaces/IOvenueSeniorPool.sol";
import {IOvenueSeniorPoolStrategy} from "../interfaces/IOvenueSeniorPoolStrategy.sol";
import {IERC20withDec} from "../interfaces/IERC20withDec.sol";
// import {ICUSDCContract} from "../../interfaces/ICUSDCContract.sol";
import {IOvenueJuniorLP} from "../interfaces/IOvenueJuniorLP.sol";
import {IOvenueJuniorRewards} from "../interfaces/IOvenueJuniorRewards.sol";
import {IOvenueFactory} from "../interfaces/IOvenueFactory.sol";
import {IGo} from "../interfaces/IGo.sol";

import {IOvenueExchange} from "../interfaces/IOvenueExchange.sol";

// import {IStakingRewards} from "../../interfaces/IStakingRewards.sol";
// import {ICurveLP} from "../../interfaces/ICurveLP.sol";

/**
 * @title ConfigHelper
 * @notice A convenience library for getting easy access to other contracts and constants within the
 *  protocol, through the use of the OvenueConfig contract
 * @author Goldfinch
 */

library OvenueConfigHelper {
  function getSeniorPool(IOvenueConfig config) internal view returns (IOvenueSeniorPool) {
    return IOvenueSeniorPool(seniorPoolAddress(config));
  }

  function getSeniorPoolStrategy(IOvenueConfig config) internal view returns (IOvenueSeniorPoolStrategy) {
    return IOvenueSeniorPoolStrategy(seniorPoolStrategyAddress(config));
  }

  function getUSDC(IOvenueConfig config) internal view returns (IERC20withDec) {
    return IERC20withDec(usdcAddress(config));
  }

  function getSeniorLP(IOvenueConfig config) internal view returns (IOvenueSeniorLP) {
    return IOvenueSeniorLP(fiduAddress(config));
  }

//   function getFiduUSDCCurveLP(OvenueConfig config) internal view returns (ICurveLP) {
//     return ICurveLP(fiduUSDCCurveLPAddress(config));
//   }

//   function getCUSDCContract(OvenueConfig config) internal view returns (ICUSDCContract) {
//     return ICUSDCContract(cusdcContractAddress(config));
//   }

  function getJuniorLP(IOvenueConfig config) internal view returns (IOvenueJuniorLP) {
    return IOvenueJuniorLP(juniorLPAddress(config));
  }

  function getJuniorRewards(IOvenueConfig config) internal view returns (IOvenueJuniorRewards) {
    return IOvenueJuniorRewards(juniorRewardsAddress(config));
  }

  function getOvenueFactory(IOvenueConfig config) internal view returns (IOvenueFactory) {
    return IOvenueFactory(ovenueFactoryAddress(config));
  }

  function getOVN(IOvenueConfig config) internal view returns (IERC20withDec) {
    return IERC20withDec(ovenueAddress(config));
  }

  function getGo(IOvenueConfig config) internal view returns (IGo) {
    return IGo(goAddress(config));
  }

  function getCollateralToken(IOvenueConfig config) internal view returns (IERC20withDec) {
    return IERC20withDec(collateralTokenAddress(config));
  }

  function getCollateralCustody(IOvenueConfig config) internal view returns (IOvenueCollateralCustody) {
    return IOvenueCollateralCustody(collateralCustodyAddress(config));
  }

  function getOvenueExchange(IOvenueConfig config) internal view returns (IOvenueExchange) {
    return IOvenueExchange(exchangeAddress(config));
  }

//   function getStakingRewards(OvenueConfig config) internal view returns (IStakingRewards) {
//     return IStakingRewards(stakingRewardsAddress(config));
//   }

  // function getTranchedPoolImplementationRepository(IOvenueConfig config)
  //   internal
  //   view
  //   returns (ImplementationRepository)
  // {
  //   return
  //     ImplementationRepository(
  //       config.getAddress(uint256(OvenueConfigOptions.Addresses.TranchedPoolImplementation))
  //     );
  // }

//   function oneInchAddress(OvenueConfig config) internal view returns (address) {
//     return config.getAddress(uint256(OvenueOvenueConfigOptions.Addresses.OneInch));
//   }

  function creditLineImplementationAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.CreditLineImplementation));
  }

//   /// @dev deprecated because we no longer use GSN
//   function trustedForwarderAddress(OvenueConfig config) internal view returns (address) {
//     return config.getAddress(uint256(OvenueOvenueConfigOptions.Addresses.TrustedForwarder));
//   }

function exchangeAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.OvenueExchange));
  }

  function collateralCustodyAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.CollateralCustody));
  }
  function configAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.OvenueConfig));
  }

  function juniorLPAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.PoolTokens));
  }

  function juniorRewardsAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.JuniorRewards));
  }

  function seniorPoolAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.SeniorPool));
  }

  function seniorPoolStrategyAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.SeniorPoolStrategy));
  }

  function ovenueFactoryAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.OvenueFactory));
  }

  function ovenueAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.OVENUE));
  }

  function fiduAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.Fidu));
  }

  function collateralTokenAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.CollateralToken));
  }

//   function fiduUSDCCurveLPAddress(OvenueConfig config) internal view returns (address) {
//     return config.getAddress(uint256(OvenueConfigOptions.Addresses.FiduUSDCCurveLP));
//   }

//   function cusdcContractAddress(OvenueConfig config) internal view returns (address) {
//     return config.getAddress(uint256(OvenueConfigOptions.Addresses.CUSDCContract));
//   }

  function usdcAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.USDC));
  }

  function collateralGovernanceAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.CollateralGovernanceImplementation));
  }

  function tranchedPoolAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.TranchedPoolImplementation));
  }

  function reserveAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.TreasuryReserve));
  }

  function protocolAdminAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.ProtocolAdmin));
  }

  function borrowerImplementationAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.BorrowerImplementation));
  }

  function goAddress(IOvenueConfig config) internal view returns (address) {
    return config.getAddress(uint256(OvenueConfigOptions.Addresses.Go));
  }

//   function stakingRewardsAddress(OvenueConfig config) internal view returns (address) {
//     return config.getAddress(uint256(OvenueConfigOptions.Addresses.StakingRewards));
//   }

  function getCollateraLockupPeriod(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.CollateralLockedUpInSeconds));
  }

  function getReserveDenominator(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.ReserveDenominator));
  }

  function getWithdrawFeeDenominator(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.WithdrawFeeDenominator));
  }

  function getLatenessGracePeriodInDays(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.LatenessGracePeriodInDays));
  }

  function getLatenessMaxDays(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.LatenessMaxDays));
  }

  function getDrawdownPeriodInSeconds(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.DrawdownPeriodInSeconds));
  }

  function getTransferRestrictionPeriodInDays(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.TransferRestrictionPeriodInDays));
  }

  function getLeverageRatio(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.LeverageRatio));
  }

  function getCollateralVotingPeriod(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.CollateralVotingPeriod));
  }

  function getCollateralVotingDelay(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.CollateralVotingDelay));
  }

  function getCollateralQuorumNumerator(IOvenueConfig config) internal view returns (uint256) {
    return config.getNumber(uint256(OvenueConfigOptions.Numbers.CollateralVotingQuorumNumerator));
  }
}