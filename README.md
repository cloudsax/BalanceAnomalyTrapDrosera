## Быстрый старт

1. Установите инструменты:
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   curl -L https://app.drosera.io/install | bash
   foundryup && droseraup
   ```

2. Склонируйте репозиторий и установите зависимости:
   ```bash
   git clone <ваш-репозиторий>.git
   cd <ваш-репозиторий>
   forge install
   ```

3. Отредактируйте целевой адрес и порог в `src/BalanceAnomalyTrap.sol`:
   ```solidity
   address public constant target = 0xABcDEF1234567890abCDef1234567890AbcDeF12; // Замените на свой
   uint256 public constant thresholdPercent = 1;                                  // % порог
   ```

4. Скомпилируйте:
   ```bash
   forge build
   ```

5. Задайте приватный ключ (только для тестнета!) и примените конфиг в сеть Drosera:
   ```bash
   export DROSERA_PRIVATE_KEY=0x<PRIVATE_KEY>
   drosera apply
   ```

---

## `drosera.toml` — важные поля

- `path` — путь к артефакту ловушки (JSON из `out/` после `forge build`).
- `response_contract` — адрес вашего `LogAlertReceiver` (или другого контракта‑реакции).
- `response_function` — сигнатура вызываемой функции.

Файл уже добавлен в репозиторий, но проверьте значения под себя.

---

## Автоматическая публикация на GitHub

Частый сценарий — экспортировать/публиковать код и конфиг ловушки в GitHub **автоматически**. Есть два удобных пути:

### Вариант A — через GitHub Personal Access Token (PAT)

1. Создайте **fine‑grained** токен:
   - Откройте: GitHub → Settings → **Developer settings** → **Personal access tokens** → **Fine‑grained tokens** → **Generate new token**.
   - Владелец ресурса: ваш аккаунт/организация.
   - Доступ к репозиторию: выберите конкретный репозиторий.
   - Разрешения: как минимум **Contents: Read and Write** (при необходимости — Actions: Read/Write).
2. Сохраните токен как секрет репозитория:
   - Repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**.
   - Имя секрета: `GH_PAT`.
3. В workflow `.github/workflows/publish.yml` уже предусмотрена работа с `GH_PAT`. При пуше в `main` он может перегенерировать артефакты и создать релиз/коммит.

### Вариант B — через встроенный `GITHUB_TOKEN` (без PAT)

Если публикация идёт **из GitHub Actions**, можно использовать автоматический `GITHUB_TOKEN` (репо → Settings → Actions → General → Workflow permissions: **Read and write**). Он позволяет коммитить/создавать релизы внутри того же репозитория.

> Если вы хотите инициировать экспорт **из интерфейса Drosera**, используйте PAT из Варианта A, когда сервис попросит токен с правами записи в репозиторий.

---

## Развёртывание контрактов (пример Foundry)

```bash
forge create src/BalanceAnomalyTrap.sol:BalanceAnomalyTrap   --rpc-url https://ethereum-holesky-rpc.publicnode.com   --private-key $DEPLOYER_PK

forge create src/LogAlertReceiver.sol:LogAlertReceiver   --rpc-url https://ethereum-holesky-rpc.publicnode.com   --private-key $DEPLOYER_PK
```

После деплоя укажите адреса в `drosera.toml` и выполните:
```bash
DROSERA_PRIVATE_KEY=$DEPLOYER_PK drosera apply
```

---

## Полезные команды

```bash
drosera dryrun   # собрать блоки и проверить shouldRespond локально
drosera apply    # применить конфигурацию трапа
forge test       # запустить тесты (добавьте свои)
```

---

## Безопасность

- Никогда не коммитьте приватные ключи и токены. Используйте секреты CI/CD.
- Для тестов применяйте тестовые RPC и ключи.
- Ограничивайте права PAT «минимально необходимыми».

---

## Лицензия

MIT
