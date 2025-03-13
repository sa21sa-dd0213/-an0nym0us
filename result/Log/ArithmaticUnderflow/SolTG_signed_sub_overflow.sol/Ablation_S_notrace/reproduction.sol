interface IVulnerable {
    function f(int x, int y) external pure returns (int);
}

contract Reproducer {
    IVulnerable public target;

    constructor(address _target) {
        target = IVulnerable(_target);
    }

    function triggerOverflow() public view returns (int) {
        return target.f(type(int).min, 1);
    }
}