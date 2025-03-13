contract ReproduceCr1 {
    ICr1 public target;

    constructor(address _target) {
        target = ICr1(_target);
    }

    function trigger() public {
        target.add(1);
        target.add(1);
        target.f();
    }
}

interface ICr1 {
    function add(uint y) external;
    function f() external;
}