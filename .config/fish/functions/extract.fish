function extract --description 'extract archieves'
    if [ -f $argv ]
        switch $argv
            case *.tar.bz2 
                tar xjf $argv
            case *.tar.gz 
                tar xzf $argv
            case *.tar.Z 
                tar xzf $argv
            case *.bz2 
                bunzip2 $argv
            case *.rar 
                unrar x $argv
            case *.gz 
                gunzip $argv
            case *.jar 
                unzip $argv
            case *.tar 
                tar xf $argv
            case *.tbz2 
                tar xjf $argv
            case *.tgz 
                tar xzf $argv
            case *.zip
                unzip $argv
            case *.Z 
                uncompress $argv
            case '*'
                echo "$argv cannot be extracted."
        end
    else
        echo "not file"
    end
end