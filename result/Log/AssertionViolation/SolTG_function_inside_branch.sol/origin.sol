pragma solidity ^0.8.0;

contract C
{
	uint x;
	function f() public {
		require(x < 10000);
		x = x + 1;
	}
	function g() public {


		assert(x < 2);
	}
}