interface IMain {
    function set() external;
    function check() external;
    function a() external view returns (uint);
}

contract Reproduction {
    IMain public target;

    constructor(address _target) {
        target = IMain(_target);
    }

    function setup() public {
        target.set();
    }

    function trigger() public {
        target.check();
    }
}