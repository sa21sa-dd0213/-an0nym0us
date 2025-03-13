interface IC {
    function f() external;
    function inc() external;
}

contract Reproducer {
    IC target;

    constructor(address _target) {
        target = IC(_target);
    }

    function trigger() public {
        for (uint i = 0; i < 2; i++) {
            target.inc();
        }
        target.f();
    }
}