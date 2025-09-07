// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IAuction.sol";
import "./interfaces/IPriceOracle.sol";

contract Auction is IAuction, UUPSUpgradeable, OwnableUpgradeable {
    address public nftContract;
    uint256 public tokenId;
    address public seller;
    uint256 public highestBid;
    address public highestBidder;
    uint256 public startingPrice;
    uint256 public endTime;
    bool public auctionEnded;
    address public priceOracle;

    // 存储之前的出价，以便退款
    mapping(address => uint256) public pendingReturns;

    event AuctionCreated(address indexed seller, uint256 tokenId, uint256 startingPrice);
    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address indexed winner, uint256 amount);
    event AuctionCanceled();

    // 防止重入
    modifier nonReentrant() {
        _;
    }

    // 初始化函数，替代构造函数
    function initialize(
        address _nftContract,
        uint256 _tokenId,
        address _seller,
        uint256 _startingPrice,
        uint256 _endTime,
        address _oracleContract
    ) external initializer {
        __Ownable_init();
        nftContract = _nftContract;
        tokenId = _tokenId;
        seller = _seller;
        startingPrice = _startingPrice;
        endTime = _endTime;
        highestBid = 0;
        auctionEnded = false;
        priceOracle = _oracleContract;

        emit AuctionCreated(_seller, _tokenId, _startingPrice);
    }

    // UUPS升级所需的函数
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    // 以太币出价
    function bid() external payable nonReentrant {
        require(!auctionEnded, "Auction already ended");
        require(block.timestamp < endTime, "Auction time ended");
        require(msg.value > highestBid, "There's already a higher bid");

        // 如果之前有最高出价者，将其出价加入待退款
        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit BidPlaced(msg.sender, msg.value);
    }

    // ERC20代币出价
    function bidWithERC20(address token, uint256 amount) external nonReentrant {
        require(!auctionEnded, "Auction already ended");
        require(block.timestamp < endTime, "Auction time ended");

        // 使用预言机将ERC20金额转换为USD价值进行比较
        IPriceOracle oracle = IPriceOracle(priceOracle);
        uint256 tokenPriceInUSD = oracle.getPriceInUSD(token);
        uint256 ethPriceInUSD = oracle.getETHPriceInUSD();
        
        // 将ERC20金额转换为等效的ETH价值
        uint256 equivalentEthValue = (amount * tokenPriceInUSD) / ethPriceInUSD;
        
        require(equivalentEthValue > highestBid, "There's already a higher bid in ETH equivalent");

        // 转移ERC20代币
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // 如果之前有最高出价者，将其出价加入待退款
        if (highestBidder != address(0) && highestBidder != msg.sender) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBid = equivalentEthValue;
        highestBidder = msg.sender;

        emit BidPlaced(msg.sender, equivalentEthValue);
    }

    // 结束拍卖
    function endAuction() external nonReentrant {
        require(!auctionEnded, "Auction already ended");
        require(block.timestamp >= endTime, "Auction time not ended");

        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 如果有最高出价者，转移NFT和资金
        if (highestBidder != address(0)) {
            // 转移NFT给出价最高者
            IERC721(nftContract).safeTransferFrom(seller, highestBidder, tokenId);
            
            // 转移资金给卖家
            payable(seller).transfer(highestBid);
        } else {
            // 如果没有出价，将NFT归还卖家
            IERC721(nftContract).safeTransferFrom(address(this), seller, tokenId);
        }
    }

    // 取消拍卖（仅卖家可以取消）
    function cancelAuction() external {
        require(msg.sender == seller, "Only seller can cancel");
        require(!auctionEnded, "Auction already ended");

        auctionEnded = true;
        emit AuctionCanceled();

        // 将NFT归还卖家
        IERC721(nftContract).safeTransferFrom(address(this), seller, tokenId);
        //退还所有出价者的资金
        for (address bidder : pendingReturns) {
            if (pendingReturns[bidder] > 0) {
                payable(bidder).transfer(pendingReturns[bidder]);
                pendingReturns[bidder] = 0;
            }
        }
    
    }

    // 领取退款
    function withdraw() external nonReentrant {
        uint256 amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
    }
}