interface IDoubleF {
    function f() external;
    function g() external view returns (uint256);
}

contract Reproduction {
    IDoubleF public target;

    constructor(address _target) {
        target = IDoubleF(_target);
    }

    function setup() public {
        target.f();
        target.f();
        target.f();
    }

    function trigger() public view {
        target.g();
    }
}