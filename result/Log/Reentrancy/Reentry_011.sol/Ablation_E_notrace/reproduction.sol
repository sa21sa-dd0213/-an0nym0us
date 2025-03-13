interface ICallWrapper {
    function callwrap(address called) external;
}

contract Trigger {
    CallWrapper target;

    constructor(address _target) {
        target = CallWrapper(_target);
    }

    function trigger() public payable {
        target.callwrap(address(this));
    }

    receive() external payable {
        target.callwrap(address(this));
    }
}