interface IMyContract {
    function func_array_loop() external pure;
}

contract Reproduction {
    IMyContract public vulnerableContract;

    constructor(address _vulnerableContract) public {
        vulnerableContract = IMyContract(_vulnerableContract);
    }

    function triggerVulnerability() public {
        vulnerableContract.func_array_loop();
    }
}