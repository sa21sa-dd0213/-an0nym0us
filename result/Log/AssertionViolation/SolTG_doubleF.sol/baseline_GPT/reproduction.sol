interface IDoubleF {
    function f() external;
    function g() external view returns (uint256);
}

contract Reproduction {

    function trigger(address _target) public {
	IDoubleF public target;
	target = IDoubleF(_target);
        target.f();
        target.f();
        target.f();
        target.g();
    }
}