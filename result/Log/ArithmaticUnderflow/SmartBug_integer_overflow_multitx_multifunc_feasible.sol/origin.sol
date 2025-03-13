pragma solidity ^0.8.10;

contract IntegerOverflowMultiTxMultiFuncFeasible {
    uint private initialized = 0;
    uint public count = 1;

    function init() public {
        initialized = 1;
    }

    function run(uint input) public returns (bool) {
        if (initialized == 0) {
            return true;
        }
        count -= input;
    }
}

