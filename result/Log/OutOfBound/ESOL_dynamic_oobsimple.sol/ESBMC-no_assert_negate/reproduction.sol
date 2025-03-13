interface IMyContract {
    function dyn_array_oob_loop(uint8 n) external;
}

contract Reproducer {
    IMyContract target;

    constructor(address _target) {
        target = IMyContract(_target);
    }

    function trigger() public {
        target.dyn_array_oob_simple(0);
    }
}