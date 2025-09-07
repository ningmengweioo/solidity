const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("MyNFT", function () {
  let myNFT, owner, addr1, addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    
    const MyNFT = await ethers.getContractFactory("MyNFT");
    myNFT = await MyNFT.deploy();
    await myNFT.deployed();
  });

  it("Should mint NFT successfully", async function () {
    await myNFT.safeMint(addr1.address);
    expect(await myNFT.ownerOf(0)).to.equal(addr1.address);
  });

  it("Should approve NFT for auction", async function () {
    await myNFT.safeMint(addr1.address);
    await myNFT.connect(addr1).approveForAuction(addr2.address, 0);
    expect(await myNFT.getApproved(0)).to.equal(addr2.address);
  });

  it("Should not allow non-owner to mint", async function () {
    await expect(myNFT.connect(addr1).safeMint(addr1.address)).to.be.revertedWith("Ownable: caller is not the owner");
  });
});