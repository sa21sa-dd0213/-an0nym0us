contract Reproduction {
    MyContract public target;

    constructor(address _target) public {
        target = MyContract(_target);
    }

    function triggerUnderflow() public {
        target.func_underflow();
    }
}