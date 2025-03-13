interface IC {
    function f() external;
    function g() external;
}

contract Reproduction {
    IC public target;

    constructor(address _target) {
        target = IC(_target);
    }

    function setup() public {
        target.f();
    }

    function trigger() public {
        target.f();
    }

    function exploit() public {
        target.g();
    }
}