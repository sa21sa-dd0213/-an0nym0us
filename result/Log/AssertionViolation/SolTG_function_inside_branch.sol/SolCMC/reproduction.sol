interface IC {
    function f() external;
    function g() external;
}

contract Reproduction {
    IC public target;

    constructor(address _target) {
        target = IC(_target);
    }

    function trigger() public {
        target.f();
        target.f();
        target.g();
    }
}