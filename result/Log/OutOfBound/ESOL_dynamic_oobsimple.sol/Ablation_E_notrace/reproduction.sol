contract Reproducer {
    MyContract target;

    constructor(address _target) {
        target = MyContract(_target);
    }

    function trigger() public {
        target.dyn_array_oob_simple(0);
    }
}