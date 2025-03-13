contract ReproduceOverflow {
    IntegerOverflowBenign1 target;

    constructor(address _target) {
        target = IntegerOverflowBenign1(_target);
    }

    function trigger(uint256 10) public {
        target.run(input);
    }
}