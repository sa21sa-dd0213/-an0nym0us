pragma solidity ^0.8.0;

contract C5 {
     uint x;
	constructor(uint a, uint b) {
		if (b > a) {
			x = b;
			return;
		}
		else {
			x = a;
			return;
		}
	}

    function f5(uint _x) public {
        uint a = 3;
        if (x > 2) {
            a = 5;
        }
        x = _x;
        assert(a == 3);
    }

    function g5(uint _x, uint _y) public {
        if (_x > _y) {
            x = _x;
        }else{
            x = _y;
        }
        if (x > 100){
            x = x - 100;
        }
    }
}