interface IC1 {
    function set_max1(uint _x, uint _y) external;
    function f1(uint _x) external;
}

contract Reproduce {
    IC1 public target;

    constructor(address _target) {
        target = IC1(_target);
    }

    function trigger() public {
        target.set_max1(3, 4);
        target.f1(1);
    }
}