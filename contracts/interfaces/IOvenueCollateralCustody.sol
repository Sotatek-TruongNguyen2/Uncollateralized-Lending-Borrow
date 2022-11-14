// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "./IOvenueJuniorPool.sol";

interface IOvenueCollateralCustody {
    struct Collateral {
        address nftAddr;
        address governor;
        uint256 tokenId;
        uint256 fungibleAmount;
    }

    struct CollateralStatus {
        uint256 lockedUntil;
        uint256 fundedFungibleAmount;
        uint256 fundedNonfungibleAmount;
        bool nftLocked;
        bool inLiquidationProcess;
    }

    struct NFTLiquidationOrder {
        bytes32 orderHash;
        uint256 price;
        uint256 makerFee;
        uint64 listAt;
        bool fullfilled;
    }
    
    function isCollateralFullyFunded(IOvenueJuniorPool _poolAddr) external returns(bool);
    function createCollateralStats(
        IOvenueJuniorPool _poolAddr,
        address _nftAddr,
        address _governor,
        uint256 _tokenId,
        uint256 _fungibleAmount
    ) external;
    
    function collectFungibleCollateral(
        IOvenueJuniorPool _poolAddr,
        address _depositor,
        uint256 _amount
    ) external;

    function redeemAllCollateral(
        IOvenueJuniorPool _poolAddr,
        address receiver
    ) external;
}