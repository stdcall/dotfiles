#!/usr/bin/env bash
# darwin-nix-bootstrap.sh — idempotent setup of Nix + nix-darwin from this
# dotfiles repo on a fresh macOS install. Safe to re-run on a fully set-up
# machine; each step detects its own prior state and skips if already done.
#
# Prerequisite: this file lives inside your dotfiles checkout
# (e.g., ~/Sync/dotfiles/), synced / cloned before running.
#
# Usage:
#   bash ~/Sync/dotfiles/darwin-nix-bootstrap.sh
#   TARGET_HOST=nagisa-osx bash ~/Sync/dotfiles/darwin-nix-bootstrap.sh
#
# Env vars:
#   TARGET_HOST  — имя darwinConfigurations.* в flake.nix, под которое
#                  активируем систему. Дефолт: текущий LocalHostName.
#                  Если отличается от текущего, скрипт переименует хост.

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
DOT_CONFIG="$DOTFILES/dot.config"
NIX_DARWIN_DIR="$DOT_CONFIG/nix-darwin"
TARGET_HOST="${TARGET_HOST:-$(scutil --get LocalHostName)}"

step() {
  echo
  echo "==> $*"
}
die() {
  echo "ERROR: $*" >&2
  exit 1
}

[[ "$(uname)" == "Darwin" ]] || die "macOS only"

# 0. Sanity: dotfiles repo has the nix-darwin config we'll be linking.
[[ -d "$NIX_DARWIN_DIR" ]] || die "$NIX_DARWIN_DIR not found — dotfiles incomplete"
[[ -f "$NIX_DARWIN_DIR/flake.nix" ]] || die "$NIX_DARWIN_DIR/flake.nix missing"

# 1. Rosetta 2 — required by nix-rosetta-builder.
step "Rosetta 2"
if arch -x86_64 /usr/bin/true >/dev/null 2>&1; then
  echo "already installed"
else
  sudo softwareupdate --install-rosetta --agree-to-license
fi

# 2. Nix (official nixos.org multi-user installer).
step "Nix"
if [[ -x /nix/var/nix/profiles/default/bin/nix ]]; then
  echo "already installed"
else
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
fi
export PATH="/nix/var/nix/profiles/default/bin:$PATH"
NIX_BIN="$(command -v nix)"

# 3. Symlink dotfiles into ~/.config. Сравнение через realpath, чтобы trailing
#    slash в существующей цели не ломал идемпотентность.
step "Symlink ~/.config/{nix,nix-darwin}"
mkdir -p "$HOME/.config"
for name in nix nix-darwin; do
  src="$DOT_CONFIG/$name"
  dst="$HOME/.config/$name"
  [[ -d "$src" ]] || {
    echo "SKIP: $src missing"
    continue
  }
  if [[ -L "$dst" ]] && [[ "$(realpath "$dst")" == "$(realpath "$src")" ]]; then
    echo "already linked: $dst"
  elif [[ -e "$dst" ]]; then
    die "$dst exists and is not our symlink; move or delete first"
  else
    ln -s "$src" "$dst"
    echo "linked: $dst → $src"
  fi
done

# 4. Stage dotfiles in git — Nix flake-in-git only sees tracked files.
#    Стейджим только если в каталоге есть содержимое, иначе пустой каталог
#    замаскировал бы случайное удаление файлов как staged deletion.
step "git add (flake visibility)"
if [[ -d "$DOTFILES/.git" ]]; then
  for name in nix nix-darwin; do
    p="$DOT_CONFIG/$name"
    if [[ -d "$p" ]] && [[ -n "$(ls -A "$p" 2>/dev/null || true)" ]]; then
      git -C "$DOTFILES" add "dot.config/$name" 2>/dev/null || true
    fi
  done
  echo "staged"
else
  echo "SKIP: $DOTFILES is not a git repo"
fi

# 5. Backup stock /etc/bashrc and /etc/zshrc so nix-darwin can install its own.
step "Backup /etc/{bashrc,zshrc}"
for f in bashrc zshrc; do
  p=/etc/$f
  if [[ -f "$p" && ! -L "$p" && ! -f "$p.before-nix-darwin" ]]; then
    sudo mv "$p" "$p.before-nix-darwin"
    echo "backed up: $p → $p.before-nix-darwin"
  else
    echo "already handled: $p"
  fi
done

# 6. Symlink /etc/nix-darwin — официальная точка, откуда darwin-rebuild берёт
#    flake по умолчанию. Абсолютный путь, т.к. sudo сбрасывает $HOME.
step "Symlink /etc/nix-darwin"
if [[ -L /etc/nix-darwin ]] && [[ "$(realpath /etc/nix-darwin)" == "$(realpath "$NIX_DARWIN_DIR")" ]]; then
  echo "already linked"
elif [[ -e /etc/nix-darwin ]]; then
  die "/etc/nix-darwin exists and is not our symlink"
else
  sudo ln -s "$NIX_DARWIN_DIR" /etc/nix-darwin
  echo "linked: /etc/nix-darwin → $NIX_DARWIN_DIR"
fi

# 7. Hostname — flake ищет конфиг по hostname, если не передать --flake .#name
#    явно. Мы явно передадим, но всё равно выравниваем имя машины с TARGET_HOST,
#    чтобы darwin-rebuild без аргументов в будущем тоже находил свой конфиг.
step "Hostname → $TARGET_HOST"
current_host="$(scutil --get LocalHostName)"
if [[ "$current_host" == "$TARGET_HOST" ]]; then
  echo "already set"
else
  sudo scutil --set HostName "$TARGET_HOST"
  sudo scutil --set LocalHostName "$TARGET_HOST"
  sudo scutil --set ComputerName "$TARGET_HOST"
  dscacheutil -flushcache
  echo "renamed: $current_host → $TARGET_HOST"
fi

# 8. Подтвердить, что TARGET_HOST реально объявлен в flake. `nix eval` ломается
#    раньше активации с понятным сообщением.
step "Flake sanity: darwinConfigurations.$TARGET_HOST"
configs="$("$NIX_BIN" --extra-experimental-features 'nix-command flakes' \
  eval --raw /etc/nix-darwin#darwinConfigurations \
  --apply 'cfgs: builtins.concatStringsSep " " (builtins.attrNames cfgs)')"
echo "available: $configs"
case " $configs " in
  *" $TARGET_HOST "*) echo "ok: $TARGET_HOST declared" ;;
  *) die "darwinConfigurations.\"$TARGET_HOST\" не найден в flake.nix. Добавь ключ или задай TARGET_HOST=<один из: $configs>" ;;
esac

# 9. Активация. На свежей macOS делаем два прохода:
#    (a) bootstrap-конфиг с nix.linux-builder.enable — у его VM-образа есть
#        substitutes в cache.nixos.org, поэтому aarch64-linux derivation'ы
#        конфига собираться не должны;
#    (b) основной конфиг ($TARGET_HOST) с nix-rosetta-builder — теперь у нас
#        уже есть Linux-билдер, и VM rosetta-builder'а собирается через него.
#    На повторных запусках (darwin-rebuild уже установлен) сразу делаем (b).
step "nix-darwin activate"
if [[ ! -x /run/current-system/sw/bin/darwin-rebuild ]]; then
  echo "-- pass 1/2: bootstrap (nix.linux-builder)"
  sudo -E "$NIX_BIN" run nix-darwin -- switch --flake "/etc/nix-darwin#bootstrap"
  echo "-- pass 2/2: $TARGET_HOST (nix-rosetta-builder)"
  sudo /run/current-system/sw/bin/darwin-rebuild switch --flake "/etc/nix-darwin#$TARGET_HOST"
else
  sudo /run/current-system/sw/bin/darwin-rebuild switch --flake "/etc/nix-darwin#$TARGET_HOST"
fi

echo
echo "All done. Open a new terminal and verify:"
echo "  darwin-rebuild --help"
echo "  nix --version"
