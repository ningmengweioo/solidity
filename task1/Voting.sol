// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract Voting{
   
// 一个mapping来存储候选人的得票数
// 一个vote函数，允许用户投票给某个候选人
// 一个getVotes函数，返回某个候选人的得票数
// 一个resetVotes函数，重置所有候选人的得票数

    mapping(address => uint256) public votes;
    address[] public candidates;

    mapping(address => bool) public isCandidate;//地址是否在该数组中
    function vote(address _candidate) external {
        require(_candidate != address(0), "invalid candidate address");
        if(!isCandidate[_candidate]){
            candidates.push(_candidate);
            isCandidate[_candidate] = true;
        }
        votes[_candidate]++;
    }

    function getVotes(address _candidate) external view returns(uint256){
        require(_candidate != address(0), "invalid candidate address");
        return votes[_candidate];
    }

    function resetVotes() public{
        for(uint256 i = 0; i < candidates.length; i++){
            votes[candidates[i]] = 0;
        }
        //todo 这是什么意思
        candidates = new address[](0);
    }


}