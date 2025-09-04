// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract MergeBytes{

    function merged(bytes memory _a,bytes memory _b)public pure returns(bytes memory){
        bytes memory res =new bytes(_a.length+_b.length);
        for(uint256 i=0;i<_a.length;i++){
            res[i] = _a[i];
        }
        for(uint256 j=0;j<_b.length;j++){
            res[_a.length+j] = _b[j];
        }
        return res;
    }

}