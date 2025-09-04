// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;


/**
 * 题:https://leetcode.cn/problems/roman-to-integer/description/
 */
contract RomanToInt{

     function getValue(bytes1 c) private pure returns (uint256) {
        if (c == 'I') return 1;
        if (c == 'V') return 5;
        if (c == 'X') return 10;
        if (c == 'L') return 50;
        if (c == 'C') return 100;
        if (c == 'D') return 500;
        if (c == 'M') return 1000;
        // 根据题目约束，输入是有效的罗马数字，所以不会走到这一步
        return 0;
    }

    function romanToInt(string memory s) public pure returns (uint256) {
        uint256 result = 0;
        uint256 length = bytes(s).length;
        
        // 从左到右遍历罗马数字
        for (uint256 i = 0; i < length; i++) {
            uint256 currentValue = getValue(bytes(s)[i]);
            
            // 检查下一个字符是否存在，以及当前值是否小于下一个值
            if (i < length - 1 && currentValue < getValue(bytes(s)[i + 1])) {
                // 如果当前值小于下一个值，则减去当前值（特殊情况：IV=4, IX=9等）
                result -= currentValue;
            } else {
                // 否则加上当前值（正常情况：VI=6, XI=11等）
                result += currentValue;
            }
        }
        
        return result;
    }

     function test() external pure {
        require(romanToInt("IV")==4,"test2 fail");
        require(romanToInt("XXVII")==27,"test3 fail");
        require(romanToInt("XV")==14,"test5 fail");
    }



}
