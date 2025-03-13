interface ICallWrapper {
    function callwrap(address called) external;
}

contract Reproduction {
    ICallWrapper public target;
    uint public reentryCount;

    constructor(address _target) {
        target = ICallWrapper(_target);
    }

    function trigger() external payable {
        target.callwrap(address(this));
    }

    fallback() external payable {
        if (reentryCount < 1) {
            reentryCount++;
            target.callwrap(address(this));
        }
    }
}