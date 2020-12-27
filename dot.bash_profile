# -*- mode: sh; -*-

[ -f ~/.bashrc ] && . ~/.bashrc
[ -f ~/.yarc ] && . ~/.yarc

export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

# User specific environment and startup programs

PATH=$HOME/.local/bin:$HOME/bin:${PATH}
export JUPYTER_GAP_EXECUTABLE=${HOME}/opt/gap/bin/x86_64-pc-linux-gnu-default64/gap
export EC2_HOME=${HOME}/opt/ec2/
PATH=$EC2_HOME/bin:${PATH}
PATH=${HOME}/opt/node/bin:${PATH}
PATH=${HOME}/.cabal/bin:${PATH}
PATH=${HOME}/bin:${PATH}
PATH=/Applications/Emacs.app/Contents/MacOS/bin/:${PATH}
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools


[[ -d "/usr/local/opt/coreutils/libexec/gnubin" ]] && PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

export PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"

PATH="$HOME/.cargo/bin:$PATH"

export PATH

export EDITOR=emacsclient
export MANPATH=${HOME}/share/man:${MANPATH}
export MANWIDTH=80
export LESS="-R -i"
export CFLAGS="-march=native -mtune=native -O3 -pipe"
export CXXFLAGS=${CFLAGS}
export MAKEFLAGS="-j5"

export LC_ALL=ru_RU.UTF-8
export LANG=C
export LC_MESSAGES=C
export LANGUAGE=C

export PGHOST=localhost
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

export PATH="$HOME/.cargo/bin:$PATH"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  br_script="~/bin/br"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  br_script='${HOME}/Library/Preferences/org.dystroy.broot/launcher/bash/br'
fi

[ -f $br_script ] && . $br_script

[ -f ~/.fzf.bash ] && . ~/.fzf.bash
[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"
