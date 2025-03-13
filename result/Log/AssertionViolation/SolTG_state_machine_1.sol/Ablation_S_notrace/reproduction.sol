interface ICsm1 {
    function f() external;
    function g() external;
    function h() external;
    function j() external;
    function i() external view;
}

contract ReproduceCsm1 {
    ICsm1 public target;

    constructor(address _target) {
        target = ICsm1(_target);
    }

    function trigger() public {
        target.f();
        target.g();
        target.h();
        target.j();
        target.i();
    }
}