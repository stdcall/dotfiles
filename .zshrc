ZSH=$HOME/.oh-my-zsh
ZSH_THEME="suvash2"
plugins=(rails3 git github cap extract ruby)
source $ZSH/oh-my-zsh.sh
unsetopt correct_all
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
alias ls='ls -hF --color=always --group-directories-first --sort=version'
alias la='ls -A'
alias ss='python -m SimpleHTTPServer' # simple server (serves current dir on port 8000)
