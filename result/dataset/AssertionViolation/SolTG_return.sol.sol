pragma solidity ^0.8.0;

contract Cr1 {
    uint public x;
	function add(uint y) public  {
		if (y == 0)

		if (y == 1)
			++x;
		if (y == 2)
			x = x + 2;
	}

	function f() public {
        assert(x < 2);

	}
}