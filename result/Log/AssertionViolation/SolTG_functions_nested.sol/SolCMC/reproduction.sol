interface IC {
    function inc() external;
    function f() external;
}

contract Reproduction {
    IC public target;

    constructor(address _target) {
        target = IC(_target);
    }

    function setup() public {
        target.inc();
        target.inc();
    }

    function trigger() public {
        target.f();
    }
}