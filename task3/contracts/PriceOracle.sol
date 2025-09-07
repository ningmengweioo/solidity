// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "./interfaces/IPriceOracle.sol";

/**
 * @title PriceOracle
 * @dev 预言机合约，用于获取代币价格
 */
contract PriceOracle is IPriceOracle {
    // 价格Feed映射
    mapping(address => AggregatorV3Interface) public priceFeeds;
    // ETH/USD价格Feed
    AggregatorV3Interface public ethPriceFeed;

    constructor(address _ethPriceFeed) {
        ethPriceFeed = AggregatorV3Interface(_ethPriceFeed);
    }

    // 添加或更新token价格Feed
    function setPriceFeed(address token, address feed) external {
        priceFeeds[token] = AggregatorV3Interface(feed);
    }

    // 获取token对USD的价格
    function getPriceInUSD(address token) public view override returns (uint256) {
        AggregatorV3Interface feed = priceFeeds[token];
        require(address(feed) != address(0), "No price feed for this token");
        
        // (, int price, , , ) = feed.latestRoundData();
         (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = feed.latestRoundData();
        require(price > 0, "Invalid price");
        
        // Chainlink价格Feed返回的是8位小数，我们转换为18位小数
        return uint256(price) * 10 ** 10;
    }

    // 获取ETH对USD的价格
    function getETHPriceInUSD() public view override returns (uint256) {
        (, int price, , , ) = ethPriceFeed.latestRoundData();
        require(price > 0, "Invalid price");
        
        // Chainlink价格Feed返回的是8位小数，我们转换为18位小数
        return uint256(price) * 10 ** 10;
    }
}