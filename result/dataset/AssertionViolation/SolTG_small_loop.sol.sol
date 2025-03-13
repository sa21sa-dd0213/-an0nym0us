pragma solidity ^0.8.0;

contract Loop1{

  uint r;
  function mini(uint n) public{
     r = 0;

    while(n>0){
      r = r+1;
      n = n-1;
    }

  }

  function enter() public {
    uint x = 5;
    assert (x == r);
  }


}
