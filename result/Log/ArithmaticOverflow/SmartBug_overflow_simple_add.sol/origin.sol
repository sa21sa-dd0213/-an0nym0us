pragma solidity ^0.8.19;

contract Overflow_Add {
    uint public balance = 1;

    function add(uint256 deposit) public {

        balance += deposit;
    }
}

