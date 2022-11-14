// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "../upgradeable/BaseUpgradeablePausable.sol";
import "../libraries/OvenueConfigHelper.sol";
import "./LeverageRatioStrategy.sol";
import "../interfaces/IOvenueSeniorPoolStrategy.sol";
import "../interfaces/IOvenueSeniorPool.sol";
import "../interfaces/IOvenueJuniorPool.sol";

contract FixedLeverageRatioStrategy is LeverageRatioStrategy {
  IOvenueConfig public config;
  using OvenueConfigHelper for IOvenueConfig;

  event OvenueConfigUpdated(address indexed who, address configAddress);

  function initialize(address owner, IOvenueConfig _config) public initializer {
    require(owner != address(0) && address(_config) != address(0), "Owner and config addresses cannot be empty");
    __BaseUpgradeablePausable__init(owner);
    config = _config;
  }

  function updateOvenueConfig() external onlyAdmin {
    config = IOvenueConfig(config.configAddress());
    emit OvenueConfigUpdated(msg.sender, address(config));
  }

  function getLeverageRatio() public view override returns (uint256) {
    return config.getLeverageRatio();
  }
}
