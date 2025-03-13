interface IBase {
    function test(int rand) external;
}

contract Reproduction {
    IBase public target;

    constructor(address _target) {
        target = IBase(_target);
    }

    function triggerVulnerability() public {
        // Carefully chosen input to cause division by zero in test function
        int rand = 100; // A small value that will likely cause phi to be zero
        target.test(rand);
    }
}