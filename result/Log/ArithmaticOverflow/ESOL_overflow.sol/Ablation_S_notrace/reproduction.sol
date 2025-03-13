interface IMyContract {
    function func_overflow() external;
}

contract ReproduceOverflow {
    IMyContract target;

    constructor(address _target) {
        target = IMyContract(_target);
    }

    function triggerOverflow() external {
        target.func_overflow();
    }
}