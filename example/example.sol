// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

interface Unknown {
    function run() external;
}

contract Mutex {
    uint x;
    Unknown immutable unknown;

    constructor(Unknown u) {
        require(address(u) != address(0));
        unknown = u;
    }

    function set(uint x_) public {
        x = x_;
    }

    function run() public {
        uint xPre = x;
        unknown.run();
        assert(xPre == x);
    }
}
// SMTChecker: External Calls and Reentrancy
