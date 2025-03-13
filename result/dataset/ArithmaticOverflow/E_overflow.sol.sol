// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.26;

contract MyContract {
    uint8 _x;
    uint8 _y;
    uint8 sum;

    function func_overflow() external {
      _x = 100;
      _y = 240;
      sum = _x + _y;
      assert(sum > 100);
    }
}
