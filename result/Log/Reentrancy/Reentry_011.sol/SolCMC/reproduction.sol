contract Reproduction {
    ICallWrapper public target;
    uint public reentryCount;

    constructor(address _target) {
        target = ICallWrapper(_target);
    }

    function trigger() external payable {
        target.callwrap(address(this));
    }

    receive() external payable {
        target.callwrap(address(this));
    }
}

interface ICallWrapper {
    function callwrap(address called) external;
}