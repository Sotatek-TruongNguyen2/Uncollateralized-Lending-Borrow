// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.5;

interface IOvenueBorrower {
  function initialize(address owner, address protocol, address _config) external;
}
