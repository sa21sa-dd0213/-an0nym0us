interface IMyContract {
    function func_underflow() external;
}

contract Reproduction {
    IMyContract public vulnerableContract;

    constructor(address _vulnerableContract) public {
        vulnerableContract = IMyContract(_vulnerableContract);
    }

    function triggerUnderflow() public {
        vulnerableContract.func_underflow();
    }
}