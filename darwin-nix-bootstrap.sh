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

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
DOT_CONFIG="$DOTFILES/dot.config"

step() { echo; echo "==> $*"; }

[[ "$(uname)" == "Darwin" ]] || { echo "macOS only" >&2; exit 1; }

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

# 3. Symlink dotfiles into ~/.config.
step "Symlink ~/.config/{nix,nix-darwin}"
mkdir -p "$HOME/.config"
for name in nix nix-darwin; do
  src="$DOT_CONFIG/$name"
  dst="$HOME/.config/$name"
  [[ -d "$src" ]] || { echo "SKIP: $src missing"; continue; }
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "already linked: $dst"
  elif [[ -e "$dst" ]]; then
    echo "ERROR: $dst exists and is not our symlink; move or delete first" >&2
    exit 1
  else
    ln -s "$src" "$dst"
    echo "linked: $dst → $src"
  fi
done

# 4. Stage dotfiles in git — Nix flake-in-git only sees tracked files.
step "git add (flake visibility)"
if [[ -d "$DOTFILES/.git" ]]; then
  git -C "$DOTFILES" add dot.config/nix dot.config/nix-darwin 2>/dev/null || true
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

# 6. Symlink /etc/nix-darwin FIRST — once this exists, `nix run nix-darwin`
#    and later `darwin-rebuild switch` both find the flake by default.
#    Absolute path: sudo clears $HOME, so ~ wouldn't resolve.
step "Symlink /etc/nix-darwin"
if [[ -L /etc/nix-darwin ]]; then
  echo "already linked"
elif [[ -e /etc/nix-darwin ]]; then
  echo "ERROR: /etc/nix-darwin exists and is not our symlink" >&2
  exit 1
else
  sudo ln -s "$DOT_CONFIG/nix-darwin" /etc/nix-darwin
  echo "linked: /etc/nix-darwin → $DOT_CONFIG/nix-darwin"
fi

# 7. First activation of nix-darwin (once; subsequent updates via darwin-rebuild).
#    No --flake needed because step 6 points the default location at us.
step "nix-darwin activate"
if [[ -x /run/current-system/sw/bin/darwin-rebuild ]]; then
  echo "already activated — use: sudo darwin-rebuild switch"
else
  sudo -E "$(command -v nix)" run nix-darwin -- switch
fi

echo
echo "All done. Open a new terminal and verify:"
echo "  darwin-rebuild --help"
echo "  nix --version"
