pragma solidity ^0.8.0;

contract Overflow {
    uint private sellerBalance = 0;

    function add(uint value) public returns (bool) {
        sellerBalance += value;
        return true;
    }
}