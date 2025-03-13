interface IMyContract {
    function func_underflow() external;
}

contract ReproduceUnderflow {
    IMyContract public target;

    constructor(address _target) {
        target = IMyContract(_target);
    }

    function trigger() external {
        target.func_underflow();
    }
}