pragma solidity ^0.8.11;

contract C
{
	function f(uint8 x) public pure returns (uint8) {
		uint8 y;
		unchecked { y = x + 255; }
		require(y >= x);
		x = 255;
		unchecked { y = x + 1; }
		assert(y == 0);
		y = x + 255;
		assert(y == 254);
		return y;
	}
}