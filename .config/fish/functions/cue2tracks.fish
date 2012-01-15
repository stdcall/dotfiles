function cue2tracks --description 'cue2tracks wrapper'
    set SHELL /bin/bash
    command cue2tracks -C $argv
    set SHELL (which fish)
end

# vim:ts=4:sw=4:et:ft=fish:
