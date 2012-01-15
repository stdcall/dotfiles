if status --is-login
    set fish_greeting ""
    #SET LOCALE
    set -x LANG "ru_RU.UTF-8"
    set -x LC_TIME "C"
    set -x LC_COLLATE "C"
    set -x LC_MESSAGES "C"
    set -x GTK_IM_MODULE "xim"
    set -x QT_IM_MODULE "xim"
    #SET PATH
    for p in $HOME/bin $HOME/.cabal/bin /opt/bin /usr/games/bin
      if not [ -d $p ] continue; end
      if not contains $p $PATH
        set -x PATH $p $PATH
      end
    end
    set -x EDITOR vim
    set -x LESS "-r"
    set -x PAGER "/usr/bin/less"
    set -x RI "-f ansi"
    set -x FISH "$HOME/.config/fish"
    set -x JAVA_HOME "/opt/oracle-jdk-bin-1.7.0.1"
    #set -x _JAVA_OPTIONS '-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel' 
    set -x _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on'
    set -x RUBYMINE_JDK /opt/sun-jdk-1.6.0.29
    set -x PYCHARM_JDK  /opt/sun-jdk-1.6.0.29
    set -x fish_color_error red
end
if test -n "$DISPLAY"
    set BROWSER firefox
    set COLORTERM rxvt-unicode-256color
end
for s in $FISH/include/*.fish
    . $s
end
# vim: ft=fish
