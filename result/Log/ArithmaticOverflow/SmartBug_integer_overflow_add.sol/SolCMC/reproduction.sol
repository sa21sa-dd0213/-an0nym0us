pragma solidity ^0.8.0;

interface IVulnerableContract {
    function run(uint256 input) external;
}

contract Reproduction is IVulnerableContract {
    uint public count = 1;
    IVulnerableContract public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = IVulnerableContract(_vulnerableContract);
    }

    function setup(uint256 input) public {
        count = 1;
        triggerOverflow(input);
    }

    function triggerOverflow(uint256 input) public {
        vulnerableContract.run(input);
    }

    function run(uint256 input) external override {
        count += input;
    }
}
