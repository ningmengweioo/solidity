// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

/**
 * 题:https://leetcode.cn/problems/integer-to-roman/description/
 */
contract IntToRoman{
    
    function intToRoman(uint256 num) public pure returns (string memory) {
        // 映射
        string[13] memory symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];
        uint256[13] memory values = [uint256(1000), uint256(900), uint256(500), uint256(400), uint256(100), uint256(90), uint256(50), uint256(40), uint256(10), uint256(9), uint256(5), uint256(4), uint256(1)];

        string memory result = "";
        for (uint256 i = 0; i < 13; i++) {
            while (num >= values[i]) {
                result = string(abi.encodePacked(result, symbols[i]));
                num -= values[i];
            }
        }
        return result;
    }


    function test() external pure {
        
        require(keccak256(abi.encodePacked(intToRoman(4))) == keccak256(abi.encodePacked("IV")), "Test failed for IV");
        require(keccak256(abi.encodePacked(intToRoman(40))) == keccak256(abi.encodePacked("XL")), "Test failed for XL");
        require(keccak256(abi.encodePacked(intToRoman(3999))) == keccak256(abi.encodePacked("MMMCMXCIX")), "Test failed for MMMCMXCIX");
    }
}
