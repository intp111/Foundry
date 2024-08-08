//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script} from "../forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
    }
    NetworkConfig public networkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            networkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            networkConfig = getMainNetEthConfig();
        } else {
            networkConfig = getAnbvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
    }

    function getAnbvilEthConfig() public returns (NetworkConfig memory) {
        if (networkConfig.priceFeed != address(0x00)) {
            return networkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();
        return NetworkConfig({priceFeed: address(mockV3Aggregator)});
    }

    function getMainNetEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            });
    }
}
