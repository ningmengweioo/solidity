const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("Auction System", function () {
  let myNFT, priceOracle, auctionImplementation, auctionFactory, auction, owner, seller, bidder1, bidder2;
  let tokenId = 0;
  let startingPrice = ethers.utils.parseEther("0.1");
  let duration = 86400; // 1天

  beforeEach(async function () {
    [owner, seller, bidder1, bidder2] = await ethers.getSigners();
    
    // 部署NFT合约
    const MyNFT = await ethers.getContractFactory("MyNFT");
    myNFT = await MyNFT.deploy();
    await myNFT.deployed();
    
    // 部署价格预言机合约（使用模拟地址）
    const PriceOracle = await ethers.getContractFactory("PriceOracle");
    priceOracle = await PriceOracle.deploy(ethers.constants.AddressZero);
    await priceOracle.deployed();
    
    // 部署拍卖实现合约
    const Auction = await ethers.getContractFactory("Auction");
    auctionImplementation = await Auction.deploy();
    await auctionImplementation.deployed();
    
    // 部署拍卖工厂合约
    const AuctionFactory = await ethers.getContractFactory("AuctionFactory");
    auctionFactory = await upgrades.deployProxy(AuctionFactory, [auctionImplementation.address], {
      kind: "uups"
    });
    await auctionFactory.deployed();
    
    // 铸造NFT给卖家
    await myNFT.safeMint(seller.address);
    
    // 卖家授权拍卖合约转移NFT
    await myNFT.connect(seller).approveForAuction(auctionFactory.address, tokenId);
    
    // 创建拍卖
    const tx = await auctionFactory.connect(seller).createAuction(
      myNFT.address,
      tokenId,
      startingPrice,
      duration,
      priceOracle.address
    );
    
    // 获取新创建的拍卖合约地址
    const receipt = await tx.wait();
    const auctionCreatedEvent = receipt.events.find(event => event.event === "AuctionCreated");
    const auctionAddress = auctionCreatedEvent.args.auctionAddress;
    
    // 获取拍卖合约实例
    auction = await ethers.getContractAt("Auction", auctionAddress);
  });

  it("Should create auction successfully", async function () {
    expect(await auction.seller()).to.equal(seller.address);
    expect(await auction.tokenId()).to.equal(tokenId);
    expect(await auction.startingPrice()).to.equal(startingPrice);
  });

  it("Should place bid successfully", async function () {
    const bidAmount = ethers.utils.parseEther("0.2");
    await auction.connect(bidder1).bid({ value: bidAmount });
    
    expect(await auction.highestBid()).to.equal(bidAmount);
    expect(await auction.highestBidder()).to.equal(bidder1.address);
  });

  it("Should not allow lower bid", async function () {
    const firstBid = ethers.utils.parseEther("0.2");
    const lowerBid = ethers.utils.parseEther("0.15");
    
    await auction.connect(bidder1).bid({ value: firstBid });
    await expect(auction.connect(bidder2).bid({ value: lowerBid })).to.be.revertedWith("There's already a higher bid");
  });

  it("Should end auction and transfer NFT and funds", async function () {
    const bidAmount = ethers.utils.parseEther("0.2");
    await auction.connect(bidder1).bid({ value: bidAmount });
    
    // 增加时间以结束拍卖
    await ethers.provider.send("evm_increaseTime", [duration + 1]);
    await ethers.provider.send("evm_mine");
    
    // 结束拍卖
    await auction.connect(bidder1).endAuction();
    
    // 验证NFT所有权转移
    expect(await myNFT.ownerOf(tokenId)).to.equal(bidder1.address);
  });

  it("Should allow seller to cancel auction", async function () {
    await auction.connect(seller).cancelAuction();
    
    // 验证拍卖已结束
    expect(await auction.auctionEnded()).to.be.true;
  });
});