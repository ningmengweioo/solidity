const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  
  // 部署NFT合约
  const MyNFT = await ethers.getContractFactory("MyNFT");
  const myNFT = await MyNFT.deploy();
  
  await myNFT.deployed();
  
  console.log("MyNFT deployed to:", myNFT.address);
  
  // 保存合约地址到文件，方便其他脚本使用
  const fs = require("fs");
  const addresses = {
    MyNFT: myNFT.address
  };
  fs.writeFileSync("deployedAddresses.json", JSON.stringify(addresses, null, 2));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });