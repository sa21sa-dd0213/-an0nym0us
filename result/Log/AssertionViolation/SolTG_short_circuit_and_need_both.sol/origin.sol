pragma solidity ^0.8.0;

contract cs4 {
	uint x;
	function f() public  {
		x = x + 1;
	}
	function g() public  {
		assert(x <= 2);

	}
}