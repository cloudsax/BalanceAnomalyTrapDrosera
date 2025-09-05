// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external view returns (bool, bytes memory);
}

contract BalanceAnomalyTrap is ITrap {
    address public constant TARGET = 0x910aa0cEa20848F3F9A7a829c82Dc851519a4FB6; // замени на свой адрес
    uint256 public constant THRESHOLD_PERCENT = 2; // чуть изменён порог

    function collect() external view override returns (bytes memory) {
        // теперь сохраняем и блок.timestamp вместе с балансом
        return abi.encode(TARGET.balance, block.timestamp);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, "Insufficient data");

        (uint256 current, ) = abi.decode(data[0], (uint256, uint256));
        (uint256 previous, ) = abi.decode(data[1], (uint256, uint256));

        if (previous == 0) return (false, "No previous balance");

        uint256 diff = current > previous ? current - previous : previous - current;
        uint256 percent = (diff * 100) / previous;

        if (percent >= THRESHOLD_PERCENT) {
            return (true, abi.encodePacked("Balance changed by ", percent, "%"));
        }

        return (false, "");
    }
}
