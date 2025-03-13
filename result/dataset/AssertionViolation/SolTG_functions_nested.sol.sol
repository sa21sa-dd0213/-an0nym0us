pragma solidity ^0.8.0;

contract C {
	uint x;
	function f() public {

		assert(x < 2); 
	}

	function inc() public  {
		require(x < 100);
		++x;
	}
}