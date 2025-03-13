interface IVulnerable {
	function f(uint8 x) external pure returns (uint8);
}

contract Reproduction is IVulnerable {
	C public target;

	constructor(address _target) {
		target = C(_target);
	}

	function setup() external pure returns (uint8) {
		return 128;
	}

	function triggerOverflow() external view returns (uint8) {
		uint8 x = this.setup();
		return target.f(x);
	}
}