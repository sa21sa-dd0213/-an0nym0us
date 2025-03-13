pragma solidity ^0.8.0;


contract cs6 {
	uint x;
	function f() public returns (uint) {
		x = x + 1;
		return x;
	}
	function g(bool a) public returns (bool) {
		bool b;
		if (a) {
			x = 0;
			b = (f() > 0) || (f() > 0);
			//assert(x == 2);

		} else {
			assert(x < 10);

		}
		return b;
	}
}