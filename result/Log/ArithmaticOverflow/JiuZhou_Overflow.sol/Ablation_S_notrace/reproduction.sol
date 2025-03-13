
interface IOverflow {
    function add(uint value) external returns (bool);
}

contract OverflowRepro {
    IOverflow public target;
    
    constructor(address _target) {
        target = IOverflow(_target);
    }
    
    function exploit(uint value) public {
        target.add(value);
    }
}