// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "../libraries/SaleKindInterface.sol";

interface IOvenueExchange {
    enum HowToCall { Call, Delegate }

    function approveOrder_(
        address[6] memory addrs,
        uint[6] memory uints,
        SaleKindInterface.Side side,
        SaleKindInterface.SaleKind saleKind,
        HowToCall howToCall,
        bytes memory callData,
        bytes memory replacementPattern,
        bool orderbookInclusionDesired
    ) external;
    
    function cancelOrder_(
        address[6] memory addrs,
        uint[6] memory uints,
        SaleKindInterface.Side side,
        SaleKindInterface.SaleKind saleKind,
        HowToCall howToCall,
        bytes memory callData,
        bytes memory replacementPattern,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function cancelledOrFinalized(
        bytes32 orderHash
    ) external view returns(bool);
}