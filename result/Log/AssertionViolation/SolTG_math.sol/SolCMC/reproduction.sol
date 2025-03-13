interface IMath {
    function min(uint256 a, uint256 b) external pure returns (uint256);
    function average(uint256 a, uint256 b) external pure returns (uint256);
}

contract Reproduction {
    IMath public mathContract;

    constructor(address _mathContract) {
        mathContract = IMath(_mathContract);
    }

    function triggerMinAssertionFail() public {
        mathContract.min(0, 0);
    }

    function triggerAverageAssertionFail() public {
        mathContract.average(type(uint256).max, type(uint256).max);
    }
}