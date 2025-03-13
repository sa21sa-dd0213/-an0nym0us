interface IMyContract {
    function func_loop() external;
}

contract Reproduction {
    IMyContract public vulnerableContract;

    constructor(address _vulnerableAddress) {
        vulnerableContract = IMyContract(_vulnerableAddress);
    }

    function triggerVulnerability() external {
        vulnerableContract.func_loop();
    }
}