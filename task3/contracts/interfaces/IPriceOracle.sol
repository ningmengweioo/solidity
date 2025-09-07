// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;


/**
 * @title IPriceOracle
 * @dev 预言机接口，用于获取代币价格
 */
interface IPriceOracle {
    function getPriceInUSD(address token) external view returns (uint256);
    function getETHPriceInUSD() external view returns (uint256);
}