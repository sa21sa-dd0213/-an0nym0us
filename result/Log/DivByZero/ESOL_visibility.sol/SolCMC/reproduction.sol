interface IBase {
    function test(int rand) external;
}

contract Reproduction {
    IBase public target;

    constructor(address _target) {
        target = IBase(_target);
    }

    function trigger() public {
        target.test(100);
    }
}