// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
1. NFT 合约：
  - 使用 ERC721 标准实现一个 NFT 合约。
  - 支持 NFT 的铸造和转移。
*/  
contract MyNFT is ERC721, Ownable {
    uint256 private _tokenIdCounter;

    constructor() ERC721("MyNFT", "MNFT") Ownable(msg.sender) {
        _tokenIdCounter = 0;
    }

    /**
    2. 铸造 NFT：
      - 只有合约所有者可以铸造 NFT。
      - 每个 NFT 都有一个唯一的 ID，从 0 开始递增。
      - 铸造时需要提供接收 NFT 的地址和 NFT 的元数据 URI。
    */
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        _safeMint(to, tokenId);
    }

    /**
    3. 转移 NFT：
      - 支持 NFT 的转移，包括合约所有者和普通用户。
      - 转移时需要提供接收 NFT 的地址和 NFT 的 ID。
    */
   
    function transferNFT(address to, uint256 tokenId) public {
       
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");
        safeTransferFrom(msg.sender, to, tokenId);
    }

    // 支持NFT上架拍卖所需的接口
    function approveForAuction(address auctionContract, uint256 tokenId) public {
        approve(auctionContract, tokenId);
    }
}