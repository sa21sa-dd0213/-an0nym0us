interface IC1 {
    function f1(uint _x) external;
    function set_max1(uint _x, uint _y) external;
}

contract Reproduction {
    IC1 public target;

    constructor(address _target) {
        target = IC1(_target);
    }

    function setup() public {
        target.set_max1(3, 1);
    }

    function trigger() public {
        target.f1(3);
    }
}