function mc --description 'mc wrapper'
    set SHELL /bin/bash
    if test $TERM = rxvt-unicode-256color
        echo -ne '\033]12;#df8700\007'
        command mc $argv
        echo -ne '\033]12;#0087ff\007'
    else
        command mc $argv
    end
    set SHELL (which fish)
end

# vim:ts=4:sw=4:et:ft=fish:
