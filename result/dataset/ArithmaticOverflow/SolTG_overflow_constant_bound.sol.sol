// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OverflowVulnerable {
    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor() {
        balances[msg.sender] = 1000; 
    }


    function deposit(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        balances[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

}