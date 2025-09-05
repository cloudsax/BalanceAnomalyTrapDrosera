// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BalanceAnomalyTrap — пример ловушки Drosera, которая реагирует на аномалии баланса адреса
/// @notice Измените константы target и thresholdPercent под свои нужды.
interface ITrap {
    function collect() external returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external view returns (bool, bytes memory);
}

contract BalanceAnomalyTrap is ITrap {
    /// @dev Адрес, чей баланс мониторим (замените на свой).
    address public constant target = 0xABcDEF1234567890abCDef1234567890AbcDeF12;

    /// @dev Порог срабатывания (в процентах). Пример: 1 = 1%.
    uint256 public constant thresholdPercent = 1;

    /// @notice Собирает метрику — текущий баланс target в wei.
    function collect() external override returns (bytes memory) {
        return abi.encode(target.balance);
    }

    /// @notice Возвращает true, если отклонение баланса превысило thresholdPercent.
    function shouldRespond(bytes[] calldata data) external view override returns (bool, bytes memory) {
        if (data.length < 2) return (false, "Insufficient data");
        uint256 current = abi.decode(data[0], (uint256));
        uint256 previous = abi.decode(data[1], (uint256));
        if (previous == 0) return (false, "Previous is zero");
        uint256 diff = current > previous ? current - previous : previous - current;
        uint256 percent = (diff * 100) / previous;
        if (percent >= thresholdPercent) {
            return (true, "");
        }
        return (false, "");
    }
}