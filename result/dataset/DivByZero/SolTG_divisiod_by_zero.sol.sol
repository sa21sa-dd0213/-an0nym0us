pragma solidity ^0.8.2;

contract C {
    function div(uint256 a, uint256 b) public returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) public returns (uint256) {
        return a % b;
    }
}