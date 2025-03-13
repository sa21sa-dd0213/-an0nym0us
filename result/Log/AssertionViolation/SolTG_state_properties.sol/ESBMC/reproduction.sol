contract Reproduction {
    Robot public robot;

    constructor(address _robot) {
        robot = Robot(_robot);
    }

    function setup() public {
        robot.moveRightUp(); // x = 1, y = 1
        robot.moveRightUp(); // x = 2, y = 2
        robot.moveRightUp(); // x = 3, y = 3
        robot.moveLeftUp();  // x = 2, y = 4
    }

    function trigger() public {
        robot.inv();
    }
}