pragma solidity ^0.8.19;

contract C  {
	function f(int x, int y) public pure returns (int) {
		require(x < y)
		return x - y;
	}
}

