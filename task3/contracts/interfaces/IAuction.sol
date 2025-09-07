// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

interface IAuction {
    function initialize(
        address _nftContract,
        uint256 _tokenId,
        address _seller,
        uint256 _startingPrice,
        uint256 _endTime,
        address _oracleContract
    ) external;
    
    function bid() external payable;
    function bidWithERC20(address token, uint256 amount) external;
    function endAuction() external;
    function cancelAuction() external;
}