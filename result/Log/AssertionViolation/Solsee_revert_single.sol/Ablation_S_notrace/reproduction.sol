contract ReproduceVul {
    _MAIN_ public target;

    constructor(address _target) {
        target = _MAIN_(_target);
    }

    function trigger() public {
        target.test(100, 50);
        target.getTotalSupply();
        target.vul();
    }

}