pragma solidity ^0.8.11;

contract C
{
	function f(uint8 x) public pure returns (uint8) {
		x = 100;
		uint8 y = x * 3;
		assert(y == 44);
		x = 128;
		y = x * 4;
		assert(y == 0);
		return y;
	}
}
