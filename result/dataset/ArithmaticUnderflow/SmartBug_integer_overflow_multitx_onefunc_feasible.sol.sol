pragma solidity ^0.8.19;

contract IntegerOverflowMultiTxOneFuncFeasible {
    uint256 private initialized = 0;
    uint256 public count = 1;

    function run(uint256 input) public returns (bool) {
        if (initialized == 0) {
            initialized = 1;
            return true;
        }
        count -= input;
    }
}

