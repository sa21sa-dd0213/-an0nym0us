interface IVulnerableContract {
    function func_overflow() external;
}

contract Reproduction {
    IVulnerableContract public target;

    constructor(address _target) public {
        target = IVulnerableContract(_target);
    }

    function triggerOverflow() public {
        target.func_overflow();
    }
}