# Completions for pgrep
# Author: SanskritFritz (gmail)

complete -c pgrep -s d --description 'DELIMITER for each process ID in the output'
complete -c pgrep -s f --description 'Match against full command line'
complete -c pgrep -s g --description 'Only match processes in the process GROUP IDs listed'
complete -c pgrep -s G --description 'Only match processes whose real GROUP ID is listed'
complete -c pgrep -s l --description 'List the process name as well as the process ID'
complete -c pgrep -s n --description 'Select only the newest of the matching processes'
complete -c pgrep -s o --description 'Select only the oldest of the matching processes'
complete -c pgrep -s P --description 'Only match processes whose parent PROCESS ID is listed'
complete -c pgrep -s s --description 'Only match processes whose process SESSION ID is listed'
complete -c pgrep -s t --description 'Only match processes whose controlling TERMINAL is listed'
complete -c pgrep -s u --description 'Only match processes whose effective USER ID is listed'
complete -c pgrep -s U --description 'Only match processes whose real USER ID is listed'
complete -c pgrep -s v --description 'Negates the matching'
complete -c pgrep -s x --description 'Only match processes with exact match'
