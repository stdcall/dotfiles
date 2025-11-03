# -*- mode: sh; -*-

PATH=$HOME/.local/bin:$HOME/bin:${PATH}
export JUPYTER_GAP_EXECUTABLE=${HOME}/opt/gap/bin/x86_64-pc-linux-gnu-default64/gap
PATH=${HOME}/.cabal/bin:${PATH}
PATH=${HOME}/bin:${PATH}

if [[ "$OSTYPE" == "darwin"* ]]; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
  PATH=${PATH}:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools
  #export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"
  PATH=/Applications/Emacs.app/Contents/MacOS/bin/:${PATH}
  [[ -d "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" ]] && PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
  PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
  PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  export ANDROID_SDK_ROOT=$HOME/Android/Sdk
fi

export PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"

export EDITOR=emacsclient
export MANPATH=${HOME}/share/man:${MANPATH}
export MANWIDTH=80
export LESS="-R -i"
export MAKEFLAGS="-j5"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export CFLAGS="-O3 -pipe"
export CXXFLAGS=${CFLAGS}

#if [[ "$OSTYPE" == "darwin"* ]]; then
  #export LDFLAGS="-L/usr/local/opt/llvm/lib"
  #export CXXFLAGS="-march=native -mtune=native -O3 -pipe -I/usr/local/opt/llvm/include"
#fi

export PGHOST=localhost
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then source $HOME/.nix-profile/etc/profile.d/nix.sh; fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  br_script="~/bin/br"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  br_script='${HOME}/Library/Preferences/org.dystroy.broot/launcher/bash/br'
fi

[ -f "$br_script" ] && . $br_script

[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"

export PATH
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

[ -f ~/.bashrc ] && . ~/.bashrc
