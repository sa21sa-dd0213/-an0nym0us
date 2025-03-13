interface IC {
    function f(int x, int y) external pure returns (int);
}

contract Reproduction {
    IC public target;
    int public inputX;
    int public inputY;

    constructor(address _target) {
        target = IC(_target);
    }

    function setupOverflowInputs() public {
        inputX = type(int).max;
        inputY = 1;
    }

    function triggerVulnerability() public view returns (int) {
        return target.f(inputX, inputY);
    }
}