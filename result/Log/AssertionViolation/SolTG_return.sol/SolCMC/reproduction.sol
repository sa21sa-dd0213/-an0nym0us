interface ICr1 {
    function add(uint y) external;
    function f() external;
}

contract Reproduction {
    ICr1 public target;

    constructor(address _target) {
        target = ICr1(_target);
    }

    function setupState() public {
        target.add(2);
        target.add(1);
    }

    function triggerExploit() public {
        target.f();
    }
}