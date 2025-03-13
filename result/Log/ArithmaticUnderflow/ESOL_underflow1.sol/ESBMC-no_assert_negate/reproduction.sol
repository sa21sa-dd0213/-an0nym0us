interface IMyContract {
    function func_loop() external;
}

contract Reproduction {
    IMyContract public target;

    constructor(address _target) public {
        target = IMyContract(_target);
    }

    function trigger() public {
        target.func_loop();
    }
}