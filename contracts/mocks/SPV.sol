// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";

contract SPV is ERC721PresetMinterPauserAutoId{
    constructor() ERC721PresetMinterPauserAutoId(
        "Special Vehicle Purpose",
        "SPV",
        ""
    ) {

    }
}