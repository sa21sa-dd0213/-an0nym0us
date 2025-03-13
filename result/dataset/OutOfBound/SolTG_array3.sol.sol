pragma solidity ^0.8.0;

contract C {
	uint[] a;
	function r(uint i) public view returns (uint) {
		return a[i]; 
	}
}