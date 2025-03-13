pragma solidity ^0.8.2;

contract C {
	function f(uint x, uint y) public pure returns (uint) {
		return x % y;
	}
}