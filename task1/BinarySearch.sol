// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract BinarySearch{
    //从一个有序数组查找目标值

    function search(int256[] memory _arr,int256 _want) public pure returns(int256){

        require(_arr.length > 0,"arr is empty");
        int256 left = 0;
        int256 right = int256(_arr.length - 1);
        while(left <= right){
            if(_arr[uint256(left)] == _want){
                return left;
            }
            if(_arr[uint256(right)] == _want){
                return right;
            }

            int256 mid = (left + right) / 2;
            if (_arr[uint256(mid)] == _want){
                return mid;//返回整数索引,进行整数除法
            }else if(_arr[uint256(mid)]< _want){
                left = mid+1;
            }else{
                right = mid-1;
            }
        }
        return -1;

        
    }
    //写一个测试函数
    function test() external pure {
        int256[] memory arr = new int256[](10);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        arr[5] = 6;
        arr[6] = 7;
        arr[7] = 8;
        arr[8] = 9;
        arr[9] = 10;
        require(search(arr,5) == 4,"test failed");
    }
    

    


}