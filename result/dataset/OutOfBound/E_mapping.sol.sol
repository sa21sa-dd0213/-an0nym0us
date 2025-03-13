// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0;

contract Base {
    constructor() {
        // "1": dereference failure: array bounds violate
        assert(test2[1] == 0);
        assert(test[1] == 0);
    }
    mapping(int => uint) test;
    uint[] test2;
}