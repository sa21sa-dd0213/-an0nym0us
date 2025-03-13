contract Reproduction {
    Csma public target;

    constructor(address _target) {
        target = Csma(_target);
    }

    function setup() public {
        target.f();
    }

    function trigger() public {
        target.h();
        target.h();
        target.h();
        target.h();
        target.h();
        target.h();
        target.h();
    }

    function finalize() public {
        target.j();
    }

    function verify() public view {
        target.i();
    }

    function exploit() public {
        setup();
        trigger();
        finalize();
        verify();
    }
}