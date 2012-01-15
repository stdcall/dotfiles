# Completions for pkill
# Author: SanskritFritz (gmail)

complete -c pkill -s f --description 'Match against full command line'
complete -c pkill -s g --description 'Only match processes in the process GROUP IDs listed'
complete -c pkill -s G --description 'Only match processes whose real GROUP ID is listed'
complete -c pkill -s n --description 'Select only the newest of the matching processes'
complete -c pkill -s o --description 'Select only the oldest of the matching processes'
complete -c pkill -s P --description 'Only match processes whose parent PROCESS ID is listed'
complete -c pkill -s s --description 'Only match processes whose process SESSION ID is listed'
complete -c pkill -s t --description 'Only match processes whose controlling TERMINAL is listed'
complete -c pkill -s u --description 'Only match processes whose effective USER ID is listed'
complete -c pkill -s U --description 'Only match processes whose real USER ID is listed'
complete -c pkill -s v --description 'Negates the matching'
complete -c pkill -s x --description 'Only match processes with exact match'
complete -c pkill -o KILL --description 'KILL signal to send to each matched process'
complete -c pkill -o TERM --description 'TERM signal to send to each matched process'

