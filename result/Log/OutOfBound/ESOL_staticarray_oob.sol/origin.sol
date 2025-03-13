// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.26;

contract MyContract {

    function func_array_loop() external pure {
      uint8[2] memory a;

      a[0] = 100;
      for (uint8 i = 1; i < 3; ++i)
      {
        a[i] = 100;
        assert(a[i-1] == 100);
      }
    }
}
