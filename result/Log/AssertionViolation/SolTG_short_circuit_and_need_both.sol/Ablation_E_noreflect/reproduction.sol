interface ICs4 {
    function f() external;
    function g() external;
}

contract Reproduction {
    ICs4 public target;

    constructor(address _target) {
        target = ICs4(_target);
    }

    function setup() public {
        target.f();
        target.f();
        target.f();
    }

    function trigger() public {
        target.g();
    }
}