interface IC5 {
    function f5(uint _x) external;
    function g5(uint _x, uint _y) external;
}

contract Reproduction{
    IC5 public target;

    constructor(address _target) {
        target = IC5(_target);
    }

    function exploit() public {
        target.g5(200, 50);
        target.f5(10);
    }
}