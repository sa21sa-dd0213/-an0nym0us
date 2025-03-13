pragma solidity ^0.8.0;

contract Csm1 {
	uint x;

	function f() public {
		if (x == 0)
			x = 1;
	}

	function g() public {
		if (x == 1)
			x = 2;
	}

	function h() public {
		if (x == 2)
			x = x + 1;
	}

	function j() public {
		if (x < 2)
			x = 100;
	}


	function i() public view {

		assert(x < 2);
	}
}
