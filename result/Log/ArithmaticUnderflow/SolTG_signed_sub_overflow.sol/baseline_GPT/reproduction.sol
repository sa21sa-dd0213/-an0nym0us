interface IVulnerable {
    function f(int x, int y) external pure returns (int);
}

contract Reproducer {
    function triggerOverflow(address _target) public view returns (int) {
	IVulnerable public target;
	target = IVulnerable(_target);
        return target.f(type(int).min, 1);
    }
}