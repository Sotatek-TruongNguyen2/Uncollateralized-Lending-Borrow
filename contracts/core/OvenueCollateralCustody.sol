// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "../upgradeable/BaseUpgradeablePausable.sol";
import "../interfaces/IOvenueConfig.sol";
import "../interfaces/IOvenueFactory.sol";
import "../interfaces/IOvenueCollateralCustody.sol";
import "../interfaces/IOvenueExchange.sol";

import "../interfaces/IV2OvenueCreditLine.sol";
import "../libraries/OvenueConfigHelper.sol";
import "../libraries/OvenueExchangeHelper.sol";
import "../libraries/OvenueCollateralCustodyLogic.sol";

import {IERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import {IERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IAccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/IAccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";

contract OvenueCollateralCustody is
    BaseUpgradeablePausable,
    IERC721Receiver,
    IOvenueCollateralCustody
{
    using OvenueConfigHelper for IOvenueConfig;
    using SafeERC20Upgradeable for IERC20withDec;

    // ------------- ERROR -----------------
    error UnauthorizedCaller();
    error WrongNFTCollateral();
    error CollateralAlreadyInitialized(address poolAddr);
    error PoolNotExisted(address poolAddr);
    error ConfigNotSetup();
    error InvalidAmount();
    error InLockupPeriod();
    error PoolNotEligibleForLiquidation();
    error InvalidPoolGovernor();
    error NFTListingMismatched();
    error NFTAlreadyInLiquidationProcess();
    error NFTNotLocked();
    error NoListingOrderToCancel();
    error ListingOrderAlreadyExists();
    error OrderHashMismatched();
    error NFTNotLiquidated();
    error NotExceedsLatenessGracePeriod();

    uint public constant SECONDS_IN_DAY = 1 days;
    uint public constant INVERSE_BASIS_POINT = 10000;
    bytes32 public constant LOCKER_ROLE = keccak256("LOCKER_ROLE");

    IOvenueConfig public config;
    IOvenueExchange public exchange;

    // mapping(address => mapping(uint => IOvenueJuniorPool)) public lockedNftCollaterals;
    mapping(IOvenueJuniorPool => Collateral) public poolCollaterals;
    mapping(IOvenueJuniorPool => CollateralStatus) public poolCollateralStatus;
    mapping(IOvenueJuniorPool => NFTLiquidationOrder) public poolNFTCollateralLiquidation;

    event OvenueExchangeUpdated(address indexed who, address exchangeAddress);
    event OvenueConfigUpdated(address indexed who, address configAddress);
    event CollateralStatsCreated(
        address indexed nftAddr,
        uint256 tokenId,
        uint256 collateralAmount
    );
    event NFTCollateralLocked(
        address indexed nftAddr,
        uint256 tokenId,
        address indexed poolAddr
    );
    event FungibleCollateralCollected(
        address indexed poolAddr,
        uint256 funded,
        uint256 amount
    );
    event NFTCollateralRedeemed(
        address indexed poolAddr,
        address indexed nftAddr,
        uint256 tokenId
    );
    event FungibleCollateralRedeemed(address indexed poolAddr, uint256 amount);
    event NFTLiquidationStarted(address indexed poolAddr, bytes32 orderhash, uint64 timestamp);
    event NFTLiquidationCancelled(address indexed poolAddr, bytes32 orderhash, uint64 timestamp);

    function initialize(address owner, address _config) public initializer {
        __BaseUpgradeablePausable__init(owner);
        config = IOvenueConfig(_config);
        exchange = config.getOvenueExchange();
        IERC20Upgradeable(config.getUSDC()).approve(address(exchange), type(uint256).max);
    }

    // ------------- NFT MARKETPLACE (LIQUIDATION) -----------
    function recoverLossFundsForInvestors(
        address poolAddr,
        bool usingFungible
    ) external {
        IOvenueJuniorPool pool = IOvenueJuniorPool(poolAddr);

        NFTLiquidationOrder memory liquidationOrder = poolNFTCollateralLiquidation[pool];
        
        Collateral storage collateral = poolCollaterals[
            pool
        ];
        CollateralStatus storage collateralStatus = poolCollateralStatus[
            pool
        ];

        OvenueCollateralCustodyLogic.recoverLossFundsForInvestors(
            config, 
            pool, 
            exchange, 
            liquidationOrder, 
            collateral, 
            collateralStatus, 
            usingFungible
        );
    }

    function listNFTToMarketplace(
        address poolAddr,
        address[6] memory addrs,
        uint256[6] memory uints,
        SaleKindInterface.Side side,
        SaleKindInterface.SaleKind saleKind,
        IOvenueExchange.HowToCall howToCall,
        bytes memory callData,
        bytes memory replacementPattern,
        bool orderbookInclusionDesired
    ) external {
        IOvenueJuniorPool pool = IOvenueJuniorPool(poolAddr);

        // Check if latesness grace period is passed
        if (!eligibleForLiquidation(pool)) {
            revert PoolNotEligibleForLiquidation();
        }

        // get nFT Address from array
        address nftAddr = addrs[4];

        uint256 tokenId = _checkEligibleFromGovernor(
            poolAddr,
            nftAddr,
            callData
        );

         // Check if pool is already in liquidation process
        _checkPoolInLiquidation(pool);

        // _notExceedsLatenessGracePeriod(pool);

        // Get the hash of order to save for validation later on
        bytes32 orderHash = OvenueExchangeHelper.hashToSignRaw(
            addrs,
            uints,
            side,
            saleKind,
            howToCall,
            callData,
            replacementPattern
        );


        NFTLiquidationOrder memory liquidationOrder = poolNFTCollateralLiquidation[IOvenueJuniorPool(poolAddr)];

        if (liquidationOrder.orderHash != bytes32(0)) {
            revert ListingOrderAlreadyExists();
        }

        // Create pool liquidation status
        _createPoolLiquidation(
            poolAddr,
            orderHash,
            uints[0],
            uints[2]
        );
        
        IERC721Upgradeable(nftAddr).approve(address(exchange), tokenId);
        
        

        exchange.approveOrder_(
            addrs,
            uints,
            side,
            saleKind,
            howToCall,
            callData,
            replacementPattern,
            orderbookInclusionDesired
        );

        emit NFTLiquidationStarted(
            poolAddr,
            orderHash,
            uint64(block.timestamp)
        );
    }

    function cancelListingNFTMarketplace(
        address poolAddr,
        address[6] memory addrs,
        uint256[6] memory uints,
        SaleKindInterface.Side side,
        SaleKindInterface.SaleKind saleKind,
        IOvenueExchange.HowToCall howToCall,
        bytes memory callData,
        bytes memory replacementPattern,
        bool orderbookInclusionDesired
    ) external {
        // NFT - Addr
        address nftAddr = addrs[4];

        uint256 tokenId = _checkEligibleFromGovernor(
            poolAddr,
            nftAddr,
            callData
        );

        bytes32 orderHash = OvenueExchangeHelper.hashToSignRaw(
            addrs,
            uints,
            side,
            saleKind,
            howToCall,
            callData,
            replacementPattern
        );

        NFTLiquidationOrder memory liquidationOrder = poolNFTCollateralLiquidation[IOvenueJuniorPool(poolAddr)];

        if (liquidationOrder.orderHash == bytes32(0)) {
            revert NoListingOrderToCancel();
        }

        if (liquidationOrder.orderHash != orderHash) {
            revert OrderHashMismatched();
        }

        IERC721Upgradeable(nftAddr).approve(address(0), tokenId);
        
        exchange.cancelOrder_(
            addrs,
            uints,
            side,
            saleKind,
            howToCall,
            callData,
            replacementPattern,
            0,
            "",
            ""
        );

        emit NFTLiquidationCancelled(
            poolAddr,
            orderHash,
            uint64(block.timestamp)
        ); 

        CollateralStatus storage collateralStatus = poolCollateralStatus[
            IOvenueJuniorPool(poolAddr)
        ];

        collateralStatus.inLiquidationProcess = false;

        delete poolNFTCollateralLiquidation[IOvenueJuniorPool(poolAddr)];
    }

    function createCollateralStats(
        IOvenueJuniorPool _poolAddr,
        address _nftAddr,
        address _governor,
        uint256 _tokenId,
        uint256 _fungibleAmount
    ) external override onlyFactory {
        Collateral storage collateral = poolCollaterals[_poolAddr];
        CollateralStatus storage collateralStatus = poolCollateralStatus[
            _poolAddr
        ];

        if (collateral.nftAddr != address(0)) {
            revert CollateralAlreadyInitialized(address(_poolAddr));
        }

        collateral.nftAddr = _nftAddr;
        collateral.tokenId = _tokenId;
        collateral.fungibleAmount = _fungibleAmount;
        collateral.governor = _governor;

        collateralStatus.inLiquidationProcess = false;
        collateralStatus.nftLocked = false;
        collateralStatus.fundedFungibleAmount = 0;
        collateralStatus.fundedNonfungibleAmount = 0;

        emit CollateralStatsCreated(_nftAddr, _tokenId, _fungibleAmount);
    }

    function collectFungibleCollateral(
        IOvenueJuniorPool _poolAddr,
        address _depositor,
        uint256 _amount
    ) external override {
        if (_amount == 0) {
            revert InvalidAmount();
        }

        _checkPoolExisted(_poolAddr);

        if (
            !IAccessControlUpgradeable(address(_poolAddr)).hasRole(
                LOCKER_ROLE,
                msg.sender
            )
        ) {
            revert UnauthorizedCaller();
        }

        if (address(config) == address(0)) {
            revert ConfigNotSetup();
        }

        CollateralStatus storage collateralStatus = poolCollateralStatus[
            _poolAddr
        ];

        collateralStatus.fundedFungibleAmount += _amount;
        collateralStatus.lockedUntil =
            config.getCollateraLockupPeriod() +
            block.timestamp;

        config.getCollateralToken().safeTransferFrom(
            _depositor,
            address(this),
            _amount
        );

        // totalFungibleCollateralAmount += amount;

        emit FungibleCollateralCollected(
            address(_poolAddr),
            collateralStatus.fundedFungibleAmount,
            _amount
        );
    }

    function redeemAllCollateral(IOvenueJuniorPool _poolAddr, address receiver)
        external
        override
    {
        _checkPoolExisted(_poolAddr);
        _checkPoolInLiquidation(IOvenueJuniorPool(_poolAddr));

        if (
            !IAccessControlUpgradeable(address(_poolAddr)).hasRole(
                LOCKER_ROLE,
                msg.sender
            )
        ) {
            revert UnauthorizedCaller();
        }

        CollateralStatus storage collateralStatus = poolCollateralStatus[
            _poolAddr
        ];
        Collateral storage collateral = poolCollaterals[_poolAddr];

        /// @dev: check if lock up period is passed
        if (block.timestamp <= collateralStatus.lockedUntil) {
            revert InLockupPeriod();
        }

        if (collateralStatus.nftLocked) {
            address nftAddr = collateral.nftAddr;
            uint256 tokenId = collateral.tokenId;

            collateralStatus.nftLocked = false;

            IERC721Upgradeable(collateral.nftAddr).approve(address(0), tokenId);

            IERC721Upgradeable(nftAddr).safeTransferFrom(
                address(this),
                receiver,
                tokenId,
                ""
            );
            emit NFTCollateralRedeemed(address(_poolAddr), nftAddr, tokenId);
        }

        if (collateralStatus.fundedFungibleAmount > 0) {
            uint256 fundedFungibleAmount = collateralStatus
                .fundedFungibleAmount;

            config.getCollateralToken().safeTransfer(
                receiver,
                fundedFungibleAmount
            );
            collateralStatus.fundedFungibleAmount = 0;

            emit FungibleCollateralRedeemed(
                address(_poolAddr),
                fundedFungibleAmount
            );
        }
    }

    function updateOvenueConfig() external onlyAdmin {
        config = IOvenueConfig(config.configAddress());
        emit OvenueConfigUpdated(msg.sender, address(config));
    }

    function updateOvenueExchange() external onlyAdmin {
        exchange = IOvenueExchange(config.exchangeAddress());
        emit OvenueExchangeUpdated(msg.sender, address(exchange));
    }

    // function updateOvenueFactory() external onlyAdmin {
    //     factory = IOvenueFactory(config.ovenueFactoryAddress());
    //     emit OvenueFactoryUpdated(msg.sender, address(factory));
    // }

    function eligibleForLiquidation(
        IOvenueJuniorPool pool 
    ) public view returns(bool) {
        IV2OvenueCreditLine creditLine = pool.creditLine();
        uint loanBalance = creditLine.balance();
        return (
            creditLine.lastFullPaymentTime() + config.getLatenessGracePeriodInDays() * SECONDS_IN_DAY < block.timestamp
        ) && (loanBalance > 0);
    }

    function isCollateralFullyFunded(IOvenueJuniorPool _poolAddr)
        public
        view
        override
        returns (bool)
    {
        CollateralStatus storage collateralStatus = poolCollateralStatus[
            _poolAddr
        ];
        Collateral storage collateral = poolCollaterals[_poolAddr];

        return
            collateralStatus.nftLocked &&
            collateralStatus.fundedFungibleAmount >= collateral.fungibleAmount;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        address poolAddr = abi.decode(data, (address));

        Collateral storage collateral = poolCollaterals[
            IOvenueJuniorPool(poolAddr)
        ];
        CollateralStatus storage collateralStatus = poolCollateralStatus[
            IOvenueJuniorPool(poolAddr)
        ];

        _checkPoolExisted(IOvenueJuniorPool(poolAddr));

        if (
            !(msg.sender == collateral.nftAddr && tokenId == collateral.tokenId)
        ) {
            revert WrongNFTCollateral();
        }

        collateralStatus.nftLocked = true;
        collateralStatus.lockedUntil =
            config.getCollateraLockupPeriod() +
            block.timestamp;

        emit NFTCollateralLocked(msg.sender, tokenId, poolAddr);

        return IERC721Receiver.onERC721Received.selector;
    }

    function _createPoolLiquidation(
        address poolAddr,
        bytes32 orderHash,
        uint256 makerFee,
        uint256 price
    ) internal {
        poolNFTCollateralLiquidation[IOvenueJuniorPool(poolAddr)] = NFTLiquidationOrder({
            orderHash: orderHash,
            makerFee: makerFee,
            price: price,
            listAt: uint64(block.timestamp),
            fullfilled: false
        });

        CollateralStatus storage collateralStatus = poolCollateralStatus[
            IOvenueJuniorPool(poolAddr)
        ];

        collateralStatus.inLiquidationProcess = true;
    }

    /**
        @dev Check the encoded calldata from governance and whether it's a valid governor
    */
    function _checkEligibleFromGovernor(
        address poolAddr,
        address nftAddr,
        bytes memory callData
    ) internal view returns (uint256 tokenId) {
        address from;

        assembly {
            let length := mload(callData)
            tokenId := mload(add(callData, length))
            from := mload(add(callData, 0x24))
        }

        Collateral storage collateral = poolCollaterals[
            IOvenueJuniorPool(poolAddr)
        ];
        // CollateralStatus storage collateralStatus = poolCollateralStatus[
        //     IOvenueJuniorPool(poolAddr)
        // ];

        if (collateral.governor != msg.sender) {
            revert InvalidPoolGovernor();
        }

        if (
            nftAddr != collateral.nftAddr ||
            tokenId != collateral.tokenId ||
            from != address(this)
        ) {
            revert NFTListingMismatched();
        }
    }

    // function _notExceedsLatenessGracePeriod(IOvenueJuniorPool poolAddr) internal view {
    //     IV2OvenueCreditLine creditLine = poolAddr.creditLine();

    //     if (creditLine.lastFullPaymentTime() + config.getLatenessGracePeriodInDays() * SECONDS_IN_DAY > block.timestamp) {
    //         revert NotExceedsLatenessGracePeriod();
    //     }
    // }

    function _checkPoolInLiquidation(IOvenueJuniorPool poolAddr) internal view {
        CollateralStatus storage collateralStatus = poolCollateralStatus[
            poolAddr
        ];

        if (collateralStatus.inLiquidationProcess) {
            revert NFTAlreadyInLiquidationProcess();
        }
    }

    function _checkPoolExisted(IOvenueJuniorPool poolAddr) internal view {
        Collateral storage collateral = poolCollaterals[poolAddr];

        if (collateral.nftAddr == address(0)) {
            revert PoolNotExisted(address(poolAddr));
        }
    }

    modifier onlyFactory() {
        if (msg.sender != address(config.getOvenueFactory())) {
            revert UnauthorizedCaller();
        }
        _;
    }
}
