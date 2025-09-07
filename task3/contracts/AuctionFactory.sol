pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./interfaces/IAuction.sol";

contract AuctionFactory is UUPSUpgradeable, OwnableUpgradeable {
    address public auctionImplementation;
    mapping(uint256 => address) public auctions;
    uint256 public auctionCount;

    event AuctionCreated(address indexed auctionAddress, uint256 auctionId);

    function initialize(address _auctionImplementation) external initializer {
        __Ownable_init();
        auctionImplementation = _auctionImplementation;
        auctionCount = 0;
    }

    // UUPS升级所需的函数
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    // 创建新的拍卖
    function createAuction(
        address nftContract,
        uint256 tokenId,
        uint256 startingPrice,
        uint256 duration,
        address priceOracle
    ) external returns (address) {
        // 使用克隆工厂创建拍卖合约实例
        address auctionAddress = Clones.clone(auctionImplementation);
        uint256 auctionId = auctionCount;
        auctionCount++;
        auctions[auctionId] = auctionAddress;

        // 初始化拍卖合约
        IAuction(auctionAddress).initialize(
            nftContract,
            tokenId,
            msg.sender,
            startingPrice,
            block.timestamp + duration,
            priceOracle
        );

        emit AuctionCreated(auctionAddress, auctionId);
        return auctionAddress;
    }

    // 更新拍卖实现合约
    function setAuctionImplementation(address newImplementation) external onlyOwner {
        auctionImplementation = newImplementation;
    }

    // 获取拍卖地址
    function getAuctionAddress(uint256 auctionId) external view returns (address) {
        return auctions[auctionId];
    }
}