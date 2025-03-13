interface IVulnerable {
    function f(uint8 x) external pure returns (uint8);
}

contract Reproduction {
    IVulnerable public target;

    constructor(address _target) {
        target = IVulnerable(_target);
    }

    function setup() public {
        // Setup phase can include future initialization if needed
    }

    function triggerOverflow() public returns (uint8) {
        return target.f(0);
    }
}