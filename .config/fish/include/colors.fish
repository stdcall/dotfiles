set -x GREP_OPTIONS --color=auto
set -x GREP_COLOR 1\;32


#set -x LESS_TERMCAP_mb (printf "\e[01;31m")       # begin blinking
#set -x LESS_TERMCAP_md (printf "\e[01;38;5;74m")  # begin bold
#set -x LESS_TERMCAP_me (printf "\e[0m")           # end mode
#set -x LESS_TERMCAP_se (printf "\e[0m")           # end standout-mode
#set -x LESS_TERMCAP_so (printf "\e[38;5;246m")    # begin standout-mode - info box
#set -x LESS_TERMCAP_ue (printf "\e[0m")           # end underline
#set -x LESS_TERMCAP_us (printf "\e[04;38;5;146m") # begin underline

#eval (dircolors -c)
#echo begin\; (dircolors -c) \;end eval2_inner \<\&3 3\<\&- | . 3<&0
set -x LS_COLORS $LS_COLORS\*.lha=01\;31 \*.sfx=01\;31 \*.lzop=01\;31 \*.iff=01\;35

# vim:ts=4:sw=4:et:ft=fish:
