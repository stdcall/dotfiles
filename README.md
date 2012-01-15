# Dotfiles

Various configuration files for my main system. Take what you like.

### Usage

Feel free to script this process to your specific needs; I usually do 
some variation on the following:

    # clone into some direcotry
    git clone git://github.com/stdcall/dotfiles.git some/directory

    # link individual dotfiles to their actual location
    ln -s some/directory/.some/dotfile .

    # optionally, add it for root too
    su -
    Password:
    ln -s /home/your-user/.some/dotfile .
    exit

    # updating later is simple
    cd some/directory && git pull
