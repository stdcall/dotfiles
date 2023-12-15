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

export LC_ALL=ru_RU.UTF-8
export LANG=C
export LC_MESSAGES=C
export LANGUAGE=C

export CFLAGS="-O3 -pipe"
export CXXFLAGS=${CFLAGS}

#if [[ "$OSTYPE" == "darwin"* ]]; then
  #export LDFLAGS="-L/usr/local/opt/llvm/lib"
  #export CXXFLAGS="-march=native -mtune=native -O3 -pipe -I/usr/local/opt/llvm/include"
#fi

export PGHOST=localhost
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

PATH="$HOME/.cargo/bin:$PATH"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  br_script="~/bin/br"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  br_script='${HOME}/Library/Preferences/org.dystroy.broot/launcher/bash/br'
fi

[ -f $br_script ] && . $br_script

[ -f ~/.fzf.bash ] && . ~/.fzf.bash
[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"

if [[ "$OSTYPE" == "darwin"* ]];then
  [ -f ~/.bashrc ] && . ~/.bashrc
fi

export PATH
. "$HOME/.cargo/env"
