pragma solidity ^0.8.0;


contract Base {
    uint[] public a;

    function SelectionSort(uint array_size) public {
        uint i;
        uint j;
        uint min;
        uint temp;
        for (i = 0; i < array_size - 1; ++i) {
            min = i;
            for (j = i + 1; j < array_size; ++j) {
                if (a[j] < a[min]) min = j;
            }
            temp = a[i];
            a[i] = a[min];
            a[min] = temp;
        }
    }
}