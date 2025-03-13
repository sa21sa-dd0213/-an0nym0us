interface ICr1 {
    function add(uint y) external;
    function f() external;
}

contract Reproduction {
    ICr1 public target;

    constructor(address _target) {
        target = ICr1(_target);
    }

    function setup() public {
        target.add(2); // Set x = 2 to match counterexample state
    }

    function trigger() public {
        target.f(); // Assertion failure expected here
    }

    function exploit() public {
        setup();
        trigger();
    }
}