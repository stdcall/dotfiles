# dotfiles

Персональные конфиги. Живут в Syncthing'е между машинами + git для истории.

## macOS bootstrap

На свежем Mac (или чтобы перепроверить состояние существующего):

```sh
bash ~/Sync/dotfiles/darwin-nix-bootstrap.sh
```

Скрипт идемпотентный. Что делает:

1. Проверяет / ставит Rosetta 2 (нужна для `nix-rosetta-builder`).
2. Ставит Nix через Determinate-инсталлер.
3. Создаёт симлинки `~/.config/nix` → `dot.config/nix`, `~/.config/nix-darwin` → `dot.config/nix-darwin`.
4. Стейджит `dot.config/{nix,nix-darwin}` в git — без этого Nix-flake в git-репо не видит файлы.
5. Перемещает стоковые `/etc/bashrc`, `/etc/zshrc` в `*.before-nix-darwin` (nix-darwin кладёт свои).
6. Делает первую активацию: `sudo nix run nix-darwin -- switch --flake ~/.config/nix-darwin`.
7. Симлинкует `/etc/nix-darwin` на `dot.config/nix-darwin` (чтобы работало короткое `sudo darwin-rebuild switch` без `--flake`).

После — открой новый терминал, проверь:
```sh
darwin-rebuild --help
nix --version
```

## Что управляется через Nix

- `dot.config/nix/nix.conf` — пользовательские Nix-настройки (flakes enabled).
- `dot.config/nix-darwin/flake.nix` + `configuration.nix` — системный macOS-конфиг + Linux-builder VM через `cpick/nix-rosetta-builder` (Apple Virt + Rosetta).

## Обычные операции

```sh
# Обновить inputs (nixpkgs, nix-darwin, nix-rosetta-builder)
nix flake update --flake ~/.config/nix-darwin
sudo darwin-rebuild switch

# Применить локальные правки configuration.nix
sudo darwin-rebuild switch

# Перезапустить linux-builder VM (после изменения её конфига)
sudo launchctl kill SIGTERM system/org.nixos.rosetta-builderd
```

## Структура

```
~/Sync/dotfiles/
├── darwin-nix-bootstrap.sh        # этот bootstrap
├── dot.config/
│   ├── nix/nix.conf
│   └── nix-darwin/{flake.nix, configuration.nix, flake.lock}
├── dot.bashrc, dot.bash_profile   # оболочка
├── dot.gitconfig                  # git identity
├── config.ghostty                 # терминал
└── (разное историческое — см. git log)
```

---

## Legacy

Старое содержимое этого README (до перехода на Nix) было про Xmonad / LightDM / Ubuntu — deprecated. Нужное смотри в `git log README.md`.
