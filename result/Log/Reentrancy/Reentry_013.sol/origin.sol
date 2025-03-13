//https://github.com/fsainas/contracts-verification-benchmark/blob/main/contracts/call-wrapper
//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.2;

/// @custom:version reentrant `callwrap`.
contract CallWrapper {
    uint data;

    function callwrap(address called) public {
        /// @custom:preghost function callwrap
        uint _data = data;

        called.call("");

        /// @custom:postghost function callwrap
        assert(_data == data);
    }
    
    function modifystorage(uint newdata) public {
        data = newdata;
    }

}
