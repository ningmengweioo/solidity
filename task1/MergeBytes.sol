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
        // 使用冒泡排序算法对字节数组进行排序
        for(uint256 k = 0; k < res.length - 1; k++) {
            for(uint256 l = 0; l < res.length - k - 1; l++) {
                // 如果前一个字节大于后一个字节，则交换它们的位置
                if(uint8(res[l]) > uint8(res[l+1])) {
                    bytes1 temp = res[l];
                    res[l] = res[l+1];
                    res[l+1] = temp;
                }
            }
        }
        
        return res;
    }

}