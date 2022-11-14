// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "./IERC20withDec.sol";

interface IOvenueSeniorLP is IERC20withDec {
  function mintTo(address to, uint256 amount) external;

  function burnFrom(address to, uint256 amount) external;

  function renounceRole(bytes32 role, address account) external;

  function delegates(address account) external;
}
