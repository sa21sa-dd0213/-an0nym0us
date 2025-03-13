
contract Reproduction {
    Csm1 public target;

    constructor(address _target) {
        target = Csm1(_target);
    }

    function trigger() public {
        target.f();
        target.g();
        target.h();
        target.i();
    }
}