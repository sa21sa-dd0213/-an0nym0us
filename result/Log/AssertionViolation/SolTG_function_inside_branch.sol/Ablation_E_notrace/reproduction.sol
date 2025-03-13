interface IC {
    function f() external;
    function g() external;
}

contract Reproduce {
    IC target;

    constructor(address _target) {
        target = IC(_target);
    }

    function exploit() public {
        for (uint i = 0; i < 10000; i++) {
            target.f();
        }
        target.g();
    }
}