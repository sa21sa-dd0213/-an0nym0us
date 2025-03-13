interface ICallWrapper {
    function callwrap(address called) external;
}

contract Trigger {
    ICallWrapper target;

    constructor(address _target) {
        target = ICallWrapper(_target);
    }

    function trigger() public payable {
        target.callwrap(address(this));
    }

    receive() external payable {
        target.callwrap(address(this));
    }
}