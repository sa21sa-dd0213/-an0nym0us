// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.26;

contract MyContract {
    uint8 x;

    function func_loop() external {
      x = 2;
      for (uint8 i=0; i<3; ++i) {
        --x;
        assert(x < 5);
      }
    }
}
