// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

interface IOvenueConfig {
  function getNumber(uint256 index) external view returns (uint256);

  function getAddress(uint256 index) external view returns (address);

  function setAddress(uint256 index, address newAddress) external returns (address);

  function setNumber(uint256 index, uint256 newNumber) external returns (uint256);

  function goList(address account) external view returns(bool);
}