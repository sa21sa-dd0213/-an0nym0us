contract Reproduction {
    C1 public target;

    constructor(address _target) {
        target = C1(_target);
    }

    function setup() public {
        target.f1(3);
    }

    function triggerVulnerability() public {
        target.f1(0);
    }
}