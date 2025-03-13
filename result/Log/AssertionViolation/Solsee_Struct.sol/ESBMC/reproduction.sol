
interface IBank {
    function test() external;
}

contract Reproduction {
    IBank public vulnerableContract;

    constructor(address _vulnerableAddress) {
        vulnerableContract = IBank(_vulnerableAddress);
    }

    function triggerVulnerability() public {
        vulnerableContract.test();
    }
}