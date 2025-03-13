contract Reproduction {
    MyContract public target;

    constructor(address _target) {
        target = MyContract(_target);
    }

    function triggerOverflow() public {
        target.func_overflow();
    }
}