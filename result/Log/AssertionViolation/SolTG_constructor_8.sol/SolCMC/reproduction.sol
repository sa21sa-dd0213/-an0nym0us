interface B8Interface {
    function f8() external;
}

contract Reproduction {
    B8 public target;
    A8 public aInstance;

    constructor(address _target) {
        target = B8(_target);
    }

    function setupVulnerability() public {
        // Manually deploying A8 to interact with it
        aInstance = new A8();
        aInstance.set8(2);
    }

    function trigger() public {
        target.f8();
    }
}