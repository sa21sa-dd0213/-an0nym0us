// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0;

contract _MAIN_ {
    constructor () public {
        uint8 a = 255;
        uint8 b = 255;

        uint8 c = a + b;

        assert(c == 254);
        assert(c == a + b);
        assert(c > 255);

    }
}