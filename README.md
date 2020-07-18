# NEWS
All configurations this repository provided are now deprecated, except gitconfig and XCompose. I've switched from manual configutation to defaults as I find maintaining so many configs too hard.
# Dotfiles
Various configuration files for my main system. Take what you like.
## Installation
Clone into some direcotry

`git clone git://github.com/stdcall/dotfiles.git $HOME/dotfiles`

Edit config.yml for special options(usernames, passwords, etc...)

```bash
cd $HOME/dotfiles
cp config.yml.new config.yml
vi config.yml
```

use rake task to automatically create symlinks in your $HOME directory

`rake install`

or link individual dotfiles to their actual location

`ln -s $HOME/dotiles/.XCompose $HOME/`

optionally, add it for root too

```bash
cd $HOME/dotfiles
su -
Password:
rake install
exit
```

updating later is simple 

`cd $HOME/dotfiles && git pull`

##Notes
###Loading .Xsession with LightDM(Ubuntu)
I run a custom X session started by ~/.xsession.  On gdm, one can select
"run Xclient script" or "Custom Xsession" as the session to launch, which 
results in that script being run. If you aren't running a graphical login 
manager, or if you start X directly from an init script, you can create symbolic
link between .xsession and .xinitrc to start X by running startx script.

```bash
ln -s ~/.xsession ~/.xinitrc
startx
```

According to [launchpad bug report][1], lightdm still doesn't support ~/.xsession scripts in Ubuntu
upstream. To deal with it, you may create /usr/share/xsessions/default.desktop
and fill it with something similar to this

```
[Desktop Entry]
Version=1.0
Name=Default Xsession
Exec=default
Type=Xsession
```

[1]: https://bugs.launchpad.net/debian/+source/lightdm/+bug/818864 "launchpad bug report"
