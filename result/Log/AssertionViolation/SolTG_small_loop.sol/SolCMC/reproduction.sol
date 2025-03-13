interface ILoop1 {
    function mini(uint n) external;
    function enter() external;
}

contract Reproduction {
    ILoop1 public target;

    constructor(address _target) {
        target = ILoop1(_target);
    }

    function setup() public {
        target.mini(0);
    }

    function trigger() public {
        target.enter();
    }
}