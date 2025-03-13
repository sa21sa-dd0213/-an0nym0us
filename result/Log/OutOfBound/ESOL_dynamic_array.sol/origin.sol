pragma solidity ^0.8.0;


contract MyContract {
  uint8 i;
  function dyn_array_oob_loop(uint8 n) public {
    uint8[] memory a = new uint8[](n);
    for (i = 0; i < n; ++i){
      a[i] = 100;
    }
    assert(a[0] == 100);
  }
}