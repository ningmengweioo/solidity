const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying PriceOracle with the account:", deployer.address);
  
  // 注意：实际部署到测试网时，需要替换为真实的Chainlink价格Feed地址
  const ETH_USD_PRICE_FEED = "0x694AA1769357215DE4FAC081bf1f309aDC325306"; // Sepolia测试网的ETH/USD价格Feed
  
  // 部署价格预言机合约
  const PriceOracle = await ethers.getContractFactory("PriceOracle");
  const priceOracle = await PriceOracle.deploy(ETH_USD_PRICE_FEED);
  
  await priceOracle.deployed();
  
  console.log("PriceOracle deployed to:", priceOracle.address);
  
  // 更新部署地址文件
  const fs = require("fs");
  const addresses = JSON.parse(fs.readFileSync("deployedAddresses.json"));
  addresses.PriceOracle = priceOracle.address;
  fs.writeFileSync("deployedAddresses.json", JSON.stringify(addresses, null, 2));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });