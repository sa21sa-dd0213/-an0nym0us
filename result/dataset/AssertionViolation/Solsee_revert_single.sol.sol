pragma solidity ^0.8.0;

contract _MAIN_ {
    uint a = 20;
    uint b = 24;

    uint t = 0;

    uint public totalSupply;

    function vul () public {

        t = getTotalSupply();

  
        assert(a <= b || t == 90);    


        assert(a > b || t != 100);
    }
    function test(uint x, uint y) public  {
        if (x > y) {
            totalSupply = 100;
        }
        else {
            totalSupply = 90;
        }
        
    }

    function getTotalSupply() public returns (uint) {
        return totalSupply;
    }
}
