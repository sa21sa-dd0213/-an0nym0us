contract ReproduceOverflow {
    IIntegerOverflowMappingSym1 public target;

    constructor(address _target) {
        target = IIntegerOverflowMappingSym1(_target);
    }

    function triggerUnderflow(uint256 k, uint256 v) public {
        target.init(k, v);
    }
}