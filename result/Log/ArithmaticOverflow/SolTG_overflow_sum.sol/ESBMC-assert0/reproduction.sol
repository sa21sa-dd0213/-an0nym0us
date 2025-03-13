contract Reproduce {
    C c;
	function trigger(address target) public returns (uint8) {
		c = C(target);
		return c.f(1);
	}
}