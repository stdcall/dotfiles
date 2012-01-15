function xman --description 'xman wrapper'
    set MANPATH (manpath)
    command xman $argv
    set -u MANPATH
end

# vim:ts=4:sw=4:et:ft=fish:
