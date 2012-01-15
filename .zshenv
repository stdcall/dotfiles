#THEME for dzen, dmenu
. $HOME/.scripts/theme
RUBYOPT=""
GREP_OPTIONS="--color=auto"
GREP_COLOR="1\;32"
# System
XDG_DATA_DIRS="/usr/share /usr/local/share"
XDG_CONFIG_DIRS="/etc/xdg"

# User
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DESKTOP_DIR=$HOME/Desktop
export XDG_DOWNLOAD_DIR=$HOME/Downloads
export XDG_DOCUMENTS_DIR=$HOME/Documents
export XDG_MUSIC_DIR=/data/Music
export XDG_PICTURES_DIR=$HOME/Pics
export XDG_VIDEOS_DIR=/data/video



#SET LOCALE
export LANG="ru_RU.UTF-8"
export LC_TIME="C"
export LC_COLLATE="C"
export LC_MESSAGES="C"
export GTK_IM_MODULE="xim"
export QT_IM_MODULE="xim"
export EDITOR=vim
export LESS="-r"
export PAGER="/usr/bin/less"
export RI="-f ansi"
JAVA_HOME="/opt/oracle-jdk-bin-1.7.0.1"
#_JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel' 
_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
RUBYMINE_JDK=/opt/sun-jdk-1.6.0.29
PYCHARM_JDK=/opt/sun-jdk-1.6.0.29
if [ -n "$DISPLAY" ]; then
  export BROWSER=firefox
  export COLORTERM=rxvt-unicode-256color
fi
