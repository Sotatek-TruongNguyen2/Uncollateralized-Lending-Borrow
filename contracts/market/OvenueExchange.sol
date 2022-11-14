// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.5;

import "./exchange/Exchange.sol";

contract OvenueExchange is Exchange {
    string public constant name = "Ovenue Exchange";

    string public constant version = "1.0";

    constructor () {}
}