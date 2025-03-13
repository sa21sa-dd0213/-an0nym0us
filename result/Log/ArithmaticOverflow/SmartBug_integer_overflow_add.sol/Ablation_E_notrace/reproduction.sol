interface IVulnerable {
    function run(uint256 input) external;
}

contract Reproduction {
    IVulnerable public vulnerableContract;
    
    constructor(address _vulnerableContract) {
        vulnerableContract = IVulnerable(_vulnerableContract);
    }

    function setup(uint256 initialValue) public {
        vulnerableContract.run(initialValue);
    }

    function triggerOverflow(uint256 input) public {
        vulnerableContract.run(input);
    }
}