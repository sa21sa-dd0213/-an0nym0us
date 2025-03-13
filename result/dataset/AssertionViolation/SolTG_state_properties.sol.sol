// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

contract Robot {
    int x = 0;
    int y = 0;


    function moveLeftUp()  public {
        --x;
        ++y;
    }

    function moveLeftDown()  public {
        --x;
        --y;
    }

    function moveRightUp()  public {
        ++x;
        ++y;
    }

    function moveRightDown()  public {
        ++x;
        --y;
    }

    function reach_2_4() public view {
    assert(!(x == 2 && y == 4));
}
}