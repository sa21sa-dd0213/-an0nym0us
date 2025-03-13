contract Reproduce {
    
	function trigger(address target) public view returns (uint8) {
		C c = C(target);
		return c.f(1);
	}
}