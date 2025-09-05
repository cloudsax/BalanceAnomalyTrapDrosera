// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogAlertReceiver {
    event Alert(string message, uint256 timestamp);

    function logAnomaly(string calldata message) external {
        emit Alert(message, block.timestamp);
    }
}
