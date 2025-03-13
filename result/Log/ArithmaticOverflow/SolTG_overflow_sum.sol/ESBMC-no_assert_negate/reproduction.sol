interface I {
    function f(uint8 x) external pure returns (uint8);
}

contract Reproduce {
	function trigger(address target) public returns (uint8) {
		I c = I(target);
		return c.f(1);
	}
}