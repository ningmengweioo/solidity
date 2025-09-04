// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract ReverseString{

    function reverse(string memory _str) public pure returns(string memory){
        //转化
        bytes memory memo = bytes(_str);
        // 1种
        // for(uint256 i = 0; i < memo.length / 2; i++){
        //     (memo[i], memo[memo.length - 1 - i]) = (memo[memo.length - 1 - i], memo[i]);
        // }
        // return string(memo);

        //2种 创建一个数组
        bytes memory res = new bytes(memo.length);
        for(uint256 i=0;i<memo.length;i++){
            res[i] = memo[memo.length - 1 - i];
        }
        return string(res);


    }
}