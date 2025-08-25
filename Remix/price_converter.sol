// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library price_converter {

    /**
     * Network: ZKSync Sepolia Testnet (https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1&testnetSearch=ETH%2FUSD&network=zksync&search=eth+)
     * Aggregator: ETH/USD
     * Address: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
     */
    
    // Interface: https://github.com/smartcontractkit/chainlink-evm/blob/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol

    function getDecimals() internal view returns (uint8) {
        return AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).decimals();
    }

    function getPrice() internal view returns (uint256) {
        (, int256 answer ,,,) = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).latestRoundData();
        return uint256(answer * 1e10);
    }

    function getConversionValue(uint _eth) internal view returns (uint256) {
        uint _price = getPrice();
        uint eth = _eth * 1e18;
        return (_price * eth) / 1e18;
    }


}