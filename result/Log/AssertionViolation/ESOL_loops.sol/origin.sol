pragma solidity ^0.8.0;

contract Loop1{

  uint sum = 0;
  uint number = 0;
  uint a = 0;
  
  function multiply() public {
    
    for(uint i = 0; i<a; i++){
      sum = sum+number;
    }
    assert (sum < 25);

  }

  function enter(uint x) public {
    number = 5;
    if (a < x){
      a = a+1;
    }   
  }

}
