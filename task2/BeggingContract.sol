// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;


contract BeggingContract{

    mapping(address=>uint256) public donations;
    uint256 public totalDonations;
    address  private _owner;


    
    constructor(){
        _owner = msg.sender;
    }
    modifier  onlyOwner(){
        require(msg.sender ==_owner,"only owner can withdraw");
        _;
    }


    function  donate() public payable{
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;

    }
    function  withdraw() public onlyOwner{
        uint balance = address(this).balance;
        require(balance>0,"No funds to withdraw");
        //转账给所有者
        payable(_owner).transfer(balance);
    }
    function getDonation(address _addr) public view returns(uint256){
        return donations[_addr];
    }
    // receive() external payable{
    //    // 当有人直接向合约地址转账时，也记录捐赠信息
    //     donations[msg.sender] += msg.value;
    //     totalDonations += msg.value;
    // }
   
}