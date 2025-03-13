contract Reproduction {
    Base public base;

    constructor(address _base) {
        base = Base(_base);
    }

    function triggerOverflow() public {
        base.SelectionSort(2);
    }
}