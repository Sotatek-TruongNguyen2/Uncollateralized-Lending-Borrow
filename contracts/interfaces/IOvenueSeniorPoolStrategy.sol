// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "./IOvenueSeniorPool.sol";
import "./IOvenueJuniorPool.sol";

abstract contract IOvenueSeniorPoolStrategy {
//   function getLeverageRatio(IOvenueJuniorPool pool) public view virtual returns (uint256);
  function getLeverageRatio() public view virtual returns (uint256);

  function invest(IOvenueJuniorPool pool) public view virtual returns (uint256 amount);

  function estimateInvestment(IOvenueJuniorPool pool) public view virtual returns (uint256);
}