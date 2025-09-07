const { ethers, upgrades } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying auction system with the account:", deployer.address);
  
  // 读取已部署的合约地址
  const fs = require("fs");
  const addresses = JSON.parse(fs.readFileSync("deployedAddresses.json"));
  
  // 部署拍卖实现合约
  const Auction = await ethers.getContractFactory("Auction");
  const auctionImplementation = await Auction.deploy();
  await auctionImplementation.deployed();
  console.log("Auction implementation deployed to:", auctionImplementation.address);
  
  // 使用UUPS代理模式部署拍卖工厂合约
  const AuctionFactory = await ethers.getContractFactory("AuctionFactory");
  const auctionFactory = await upgrades.deployProxy(AuctionFactory, [auctionImplementation.address], {
    kind: "uups"
  });
  await auctionFactory.deployed();
  
  console.log("AuctionFactory deployed to:", auctionFactory.address);
  
  // 更新部署地址文件
  addresses.AuctionImplementation = auctionImplementation.address;
  addresses.AuctionFactory = auctionFactory.address;
  fs.writeFileSync("deployedAddresses.json", JSON.stringify(addresses, null, 2));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });