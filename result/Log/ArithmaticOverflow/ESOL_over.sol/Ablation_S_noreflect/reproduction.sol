interface IVulnerable {
    function func_overflow() external;
}

contract Reproduction {
    IVulnerable public target;

    constructor(address _target) public {
        target = IVulnerable(_target);
    }

    function triggerOverflow() public {
        target.func_overflow();
    }
}