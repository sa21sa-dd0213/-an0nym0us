// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract OverflowReproduction {
    uint private sellerBalance = 0;
    
    constructor() {}

    function add(uint value) public returns (bool) {
        sellerBalance += value;  // Potential overflow in older Solidity versions
        return true;  // Fix missing return statement
    }
}
