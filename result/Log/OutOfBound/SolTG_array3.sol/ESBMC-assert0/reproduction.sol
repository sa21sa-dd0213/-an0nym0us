contract Reproduction {
    C public target;

    constructor(address _target) {
        target = C(_target);
    }


    function triggerOutOfBounds() public view returns (uint) {
        return target.r(0);
    }
}