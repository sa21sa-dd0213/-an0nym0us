contract Reproduction {
    Base public base;

    constructor(address _base) {
        base = Base(_base);
    }

    function triggerOverflow() public {
        uint size = 1;
        base.SelectionSort(size + 1);
    }
}