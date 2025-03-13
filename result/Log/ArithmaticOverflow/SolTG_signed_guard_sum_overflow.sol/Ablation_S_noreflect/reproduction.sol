contract Reproduction {
    C public target;
    int public inputX;
    int public inputY;

    constructor(address _target) {
        target = C(_target);
    }

    function setup() public {
        inputX = type(int).max;
        inputY = 1;
    }

    function trigger() public view returns (int) {
        return target.f(inputX, inputY);
    }
}