pragma solidity ^0.8.11;

contract C
{
	function f(int8 x) public pure returns (int8) {
		x = 100;
		int8 y;
		y = x * 2;
		assert(y == -56);
		y = x * 100;
		assert(y == 16);
		return y;
	}
}