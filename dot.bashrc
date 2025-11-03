# -*- mode: sh; -*-

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if command -v pyenv > /dev/null 2>&1; then eval "$(pyenv init --path)"; fi
if command -v pyenv > /dev/null 2>&1; then eval "$(pyenv virtualenv-init -)"; fi

if [[ "$OSTYPE" == "cygwin" ]]; then
  GIT_PROMPT=/usr/share/git/completion/git-prompt.sh
  [ -f $GIT_PROMPT ] && source $GIT_PROMPT
fi

if [ -f ~/.yarc ]; then
  . ~/.yarc
  export PS1=" λ \[\e[01;34m\]\W\[\e[00m\] \$(__git_ps1 '[%s]')\$(__arc_ps1) \[\e[01;32m\]→ \[\e[00m\] "
else
  export PS1=" λ \[\e[01;34m\]\W\[\e[00m\] \$(__git_ps1 '[%s]') \[\e[01;32m\]→ \[\e[00m\] "
fi

stty -ixon # enable C-s for search

HISTCONTROL=erasedups:ignorespace
HISTSIZE=20000
HISTFILESIZE=20000
shopt -s histappend
shopt -s direxpand
shopt -s checkwinsize

# Use arrows for incremental searching
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# not working under OS X
# shopt -s globstar

function kill! {
  pgrep $@ | xargs kill -9
}

alias cleantex='rm *.aux *.dvi *.pdfsync *.log'
alias grep='grep --color=auto'
alias ec="emacsclient -n -a vim"
alias vi="vim"
alias sudo='sudo -E'
alias ls="ls -hFG --color"
alias ll="ls -l"
alias la="ls -A"
alias df="df -h"
alias du="du -h"
alias g="git"
alias vf='vim $(rg . | fzf | cut -d ":" -f 1)'

GPG_TTY=$(tty)
export GPG_TTY
#unset SSH_AGENT_PID
#if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
#    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
#fi

if command -v brew >/dev/null 2>&1; then
  HOMEBREW_PREFIX=$(brew --prefix)
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if command -v fzf >/dev/null 2>&1; then eval "$(fzf --bash)"; fi
