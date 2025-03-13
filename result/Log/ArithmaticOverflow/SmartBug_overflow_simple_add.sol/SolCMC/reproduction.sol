pragma solidity ^0.8.19;

interface IVulnerable {
    function add(uint256 deposit) external;
}

contract Reproduction is IVulnerable {
    uint public balance = 1;
    
    function setup(address vulnerableAddress) public {
        IVulnerable(vulnerableAddress).add(1);
    }

    function triggerOverflow(address vulnerableAddress) public {
        uint256 deposit = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
        IVulnerable(vulnerableAddress).add(deposit);
    }

    function add(uint256 deposit) external override {
        balance += deposit;
    }
}
