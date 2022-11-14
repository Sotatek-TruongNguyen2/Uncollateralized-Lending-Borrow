// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.5;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../libraries/ArrayUtils.sol";
import "../libraries/SaleKindInterface.sol";
import "../libraries/ReentrancyGuarded.sol";
import "./ExchangeCore.sol";

contract Exchange is ExchangeCore {
    // /**
    //  * @dev Call guardedArrayReplace - library function exposed for testing.
    //  */
    // function guardedArrayReplace(bytes memory array, bytes memory desired, bytes memory mask)
    //     public
    //     pure
    //     returns (bytes memory)
    // {
    //     ArrayUtils.guardedArrayReplace(array, desired, mask);
    //     return array;
    // }

    // /**
    //  * Test copy byte array
    //  *
    //  * @param arrToCopy Array to copy
    //  * @return byte array
    //  */
    // function testCopy(bytes memory arrToCopy)
    //     public
    //     pure
    //     returns (bytes memory)
    // {
    //     bytes memory arr = new bytes(arrToCopy.length);
    //     uint index;
    //     assembly {
    //         index := add(arr, 0x20)
    //     }
    //     ArrayUtils.unsafeWriteBytes(index, arrToCopy);
    //     return arr;
    // }

    // /**
    //  * Test write address to bytes
    //  *
    //  * @param addr Address to write
    //  * @return byte array
    //  */
    // function testCopyAddress(address addr)
    //     public
    //     pure
    //     returns (bytes memory)
    // {
    //     bytes memory arr = new bytes(0x14);
    //     uint index;
    //     assembly {
    //         index := add(arr, 0x20)
    //     }
    //     ArrayUtils.unsafeWriteAddress(index, addr);
    //     return arr;
    // }

    /**
     * @dev Call calculateFinalPrice - library function exposed for testing.
     */
    function calculateFinalPrice(SaleKindInterface.Side side, SaleKindInterface.SaleKind saleKind, uint basePrice, uint extra, uint listingTime, uint expirationTime)
    public
    view
    returns (uint)
    {
        return SaleKindInterface.calculateFinalPrice(side, saleKind, basePrice, extra, listingTime, expirationTime);
    }

    /**
     * @dev Call hashOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
     */
    function hashOrder_(
        address[6] memory addrs,
        uint[6] memory uints,
        SaleKindInterface.Side side,
        SaleKindInterface.SaleKind saleKind,
        HowToCall howToCall,

        bytes memory callData,
        bytes memory replacementPattern
    )
    public
    pure
    returns (bytes32)
    {
        return hashOrder(
            Order(
                addrs[0],
                addrs[1],
                addrs[2],
                uints[0],
                uints[1],
                addrs[3],
                side,
                saleKind,
                howToCall,
                addrs[4],
                callData,
                replacementPattern,
                addrs[5],
                uints[2],
                uints[3],
                uints[4],
                uints[5]
            )
        );
    }

    /**
     * @dev Call hashToSign - Solidity ABI encoding limitation workaround, hopefully temporary.
     */
    function hashToSign_(
        address[6] memory addrs,
        uint[6] memory uints,
        SaleKindInterface.Side side,
        SaleKindInterface.SaleKind saleKind,
        HowToCall howToCall,

        bytes memory callData,
        bytes memory replacementPattern
    )
    public
    pure
    returns (bytes32)
    {
        return hashToSign(
            Order(
                addrs[0],
                addrs[1],
                addrs[2],
                uints[0],
                uints[1],
                addrs[3],
                side,
                saleKind,
                howToCall,
                addrs[4],
                callData,
                replacementPattern,
                addrs[5],
                uints[2],
                uints[3],
                uints[4],
                uints[5]
            )
        );
    }

    /**
     * @dev Call validateOrderParameters - Solidity ABI encoding limitation workaround, hopefully temporary.
     */
    function validateOrderParameters_(
        address[6] memory addrs,
        uint[6] memory uints,
        SaleKindInterface.Side side,
        SaleKindInterface.SaleKind saleKind,
        HowToCall howToCall,

        bytes memory callData,
        bytes memory replacementPattern
    )
    view
    public
    returns (bool)
    {
        Order memory order = Order(
            addrs[0],
            addrs[1],
            addrs[2],
            uints[0],
            uints[1],
            addrs[3],
            side,
            saleKind,
            howToCall,
            addrs[4],
            callData,
            replacementPattern,
            addrs[5],
            uints[2],
            uints[3],
            uints[4],
            uints[5]
        );
        return validateOrderParameters(
            order
        );
    }

    /**
     * @dev Call validateOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
     */
    function validateOrder_(
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
    )
    view
    public
    returns (bool)
    {
        Order memory order = Order(
            addrs[0],
            addrs[1],
            addrs[2],
            uints[0],
            uints[1],
            addrs[3],
            side,
            saleKind,
            howToCall,
            addrs[4],
            callData,
            replacementPattern,
            addrs[5],
            uints[2],
            uints[3],
            uints[4],
            uints[5]
        );

        return validateOrder(
            hashToSign(order),
            order,
            Sig(v, r, s)
        );
    }

    /**
     * @dev Call approveOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
     */
    function approveOrder_(
        address[6] memory addrs,
        uint[6] memory uints,
        SaleKindInterface.Side side,
        SaleKindInterface.SaleKind saleKind,
        HowToCall howToCall,
        bytes memory callData,
        bytes memory replacementPattern,
        bool orderbookInclusionDesired
    )
    public
    {

        Order memory order = Order(
            addrs[0],
            addrs[1],
            addrs[2],
            uints[0],
            uints[1],
            addrs[3],
            side,
            saleKind,
            howToCall,
            addrs[4],
            callData,
            replacementPattern,
            addrs[5],
            uints[2],
            uints[3],
            uints[4],
            uints[5]
        );

        return approveOrder(order, orderbookInclusionDesired);
    }

    /**
     * @dev Call cancelOrder - Solidity ABI encoding limitation workaround, hopefully temporary.
     */
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
        bytes32 s)
    public
    {

        return cancelOrder(
            Order(
                addrs[0],
                addrs[1],
                addrs[2],
                uints[0],
                uints[1],
                addrs[3],
                side,
                saleKind,
                howToCall,
                addrs[4],
                callData,
                replacementPattern,
                addrs[5],
                uints[2],
                uints[3],
                uints[4],
                uints[5]
            ),
            Sig(v, r, s)
        );
    }

    /**
     * @dev Call calculateCurrentPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
     */
    function calculateCurrentPrice_(
        address[6] memory addrs,
        uint[6] memory uints,
        SaleKindInterface.Side side,
        SaleKindInterface.SaleKind saleKind,
        HowToCall howToCall,
        bytes memory callData,
        bytes memory replacementPattern
    )
    public
    pure
    returns (uint)
    {
        return calculateCurrentPrice(
            Order(
                addrs[0],
                addrs[1],
                addrs[2],
                uints[0],
                uints[1],
                addrs[3],
                side,
                saleKind,
                howToCall,
                addrs[4],
                callData,
                replacementPattern,
                addrs[5],
                uints[2],
                uints[3],
                uints[4],
                uints[5]
            )
        );
    }

    /**
     * @dev Call ordersCanMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
     */
    function ordersCanMatch_(
        address[12] memory addrs,
        uint[12] memory uints,
        uint8[6] memory saleKinds,
        bytes memory calldataBuy,
        bytes memory calldataSell,
        bytes memory replacementPatternBuy,
        bytes memory replacementPatternSell
    )
    public
    view
    returns (bool)
    {

        Order memory buy = Order(
            addrs[0],
            addrs[1],
            addrs[2],
            uints[0],
            uints[1],
            addrs[3],
            SaleKindInterface.Side(saleKinds[0]),
            SaleKindInterface.SaleKind(saleKinds[1]),
            HowToCall(saleKinds[2]),
            addrs[4],
            calldataBuy,
            replacementPatternBuy,
            addrs[5],
            uints[2],
            uints[3],
            uints[4],
            uints[5]
        );
        Order memory sell = Order(
            addrs[6],
            addrs[7],
            addrs[8],
            uints[6],
            uints[7],
            addrs[9],
            SaleKindInterface.Side(saleKinds[3]),
            SaleKindInterface.SaleKind(saleKinds[4]),
            HowToCall(saleKinds[5]),
            addrs[10],
            calldataSell,
            replacementPatternSell,
            addrs[11],
            uints[8],
            uints[9],
            uints[10],
            uints[11]
        );

        return ordersCanMatch(
            buy,
            sell
        );
    }

    /**
     * @dev Return whether or not two orders' calldata specifications can match
     * @param buyCalldata Buy-side order calldata
     * @param buyReplacementPattern Buy-side order calldata replacement mask
     * @param sellCalldata Sell-side order calldata
     * @param sellReplacementPattern Sell-side order calldata replacement mask
     * @return Whether the orders' calldata can be matched
     */
    function orderCalldataCanMatch(bytes memory buyCalldata, bytes memory buyReplacementPattern, bytes memory sellCalldata, bytes memory sellReplacementPattern)
    public
    pure
    returns (bool)
    {
        if (buyReplacementPattern.length > 0) {
            ArrayUtils.guardedArrayReplace(buyCalldata, sellCalldata, buyReplacementPattern);
        }
        if (sellReplacementPattern.length > 0) {
            ArrayUtils.guardedArrayReplace(sellCalldata, buyCalldata, sellReplacementPattern);
        }
        return ArrayUtils.arrayEq(buyCalldata, sellCalldata);
    }

    /**
     * @dev Call calculateMatchPrice - Solidity ABI encoding limitation workaround, hopefully temporary.
     */
    function calculateMatchPrice_(
        address[12] memory addrs,
        uint[12] memory uints,
        uint8[6] memory saleKinds,
        bytes memory calldataBuy,
        bytes memory calldataSell,
        bytes memory replacementPatternBuy,
        bytes memory replacementPatternSell
    )
    public
    pure
    returns (uint)
    {
        Order memory buy = Order(
            addrs[0],
            addrs[1],
            addrs[2],
            uints[0],
            uints[1],
            addrs[3],
            SaleKindInterface.Side(saleKinds[0]),
            SaleKindInterface.SaleKind(saleKinds[1]),
            HowToCall(saleKinds[2]),
            addrs[4],
            calldataBuy,
            replacementPatternBuy,
            addrs[5],
            uints[2],
            uints[3],
            uints[4],
            uints[5]
        );
        Order memory sell = Order(
            addrs[6],
            addrs[7],
            addrs[8],
            uints[6],
            uints[7],
            addrs[9],
            SaleKindInterface.Side(saleKinds[3]),
            SaleKindInterface.SaleKind(saleKinds[4]),
            HowToCall(saleKinds[5]),
            addrs[10],
            calldataSell,
            replacementPatternSell,
            addrs[11],
            uints[8],
            uints[9],
            uints[10],
            uints[11]
        );
        return calculateMatchPrice(
            buy,
            sell
        );
    }

    /**
     * @dev Call atomicMatch - Solidity ABI encoding limitation workaround, hopefully temporary.
     */
    function atomicMatch_(
        address[12] memory addrs,
        uint[12] memory uints,
        uint8[6] memory saleKinds,
        bytes memory calldataBuy,
        bytes memory calldataSell,
        bytes memory replacementPatternBuy,
        bytes memory replacementPatternSell,
        uint8[2] memory vs,
        bytes32[4] memory rssMetadata
    )
    public
    payable
    {
        return atomicMatch(
            Order(
                addrs[0],
                addrs[1],
                addrs[2],
                uints[0],
                uints[1],
                addrs[3],
                SaleKindInterface.Side(saleKinds[0]),
                SaleKindInterface.SaleKind(saleKinds[1]),
                HowToCall(saleKinds[2]),
                addrs[4],
                calldataBuy,
                replacementPatternBuy,
                addrs[5],
                uints[2],
                uints[3],
                uints[4],
                uints[5]
            ),
            Sig(vs[0], rssMetadata[0], rssMetadata[1]),
            Order(
                addrs[6],
                addrs[7],
                addrs[8],
                uints[6],
                uints[7],
                addrs[9],
                SaleKindInterface.Side(saleKinds[3]),
                SaleKindInterface.SaleKind(saleKinds[4]),
                HowToCall(saleKinds[5]),
                addrs[10],
                calldataSell,
                replacementPatternSell,
                addrs[11],
                uints[8],
                uints[9],
                uints[10],
                uints[11]
            ),
            Sig(vs[1],
            rssMetadata[2],
            rssMetadata[3])
        );
    }
}