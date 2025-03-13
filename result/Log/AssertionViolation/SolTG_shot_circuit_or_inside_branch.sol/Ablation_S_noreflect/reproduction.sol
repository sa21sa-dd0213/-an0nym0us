interface ICS6 {
    function f() external returns (uint);
    function g(bool a) external returns (bool);
}

contract Reproduction {
    ICS6 public target;

    constructor(address _target) {
        target = ICS6(_target);
    }

    function setup() public {
        for (uint i = 0; i < 10; i++) {
            target.f();
        }
    }

    function trigger() public {
        target.g(false);
    }
}