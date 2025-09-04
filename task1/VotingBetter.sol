// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;


//用版本号控制对应的投票选举信息
contract VotingBetter{
    
    struct CandidateVotes{
        uint256 version;
        uint256  count;
    }
    mapping(address => CandidateVotes) public votes;
    //当前版本号
    uint256 private currentVersion;


    //投票
    function vote(address _candidate) external{

        require(_candidate != address(0), "Invalid candidate address");
        if(votes[_candidate].version != currentVersion){
            votes[_candidate].version = currentVersion;
            votes[_candidate].count = 0; 
        }
        votes[_candidate].count++;
    }

     function getVotes(address _candidate) external view returns(uint256){
        require(_candidate != address(0), "Invalid candidate address");
        if(votes[_candidate].version != currentVersion){
            return 0;
        }

        return votes[_candidate].count;
     }

     //重置投票
    function resetVotes() external{   
        currentVersion += 1;
    }




}



