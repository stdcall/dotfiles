export MPD_HOST=localhost
export MPD_PORT=6600
xmodmap $HOME/.Xmodmap
#setxkbmap -option grp:alt_shift_toggle -option lv3:ralt_switch -option misc:typo -layout us,ru
xset m 1 1
urxvtd -q -o -f& 
#xloadimage -onroot /home/scriper/Pics/wallpapers/nice.jpg
udiskie &
~/.scripts/tray.sh&
~/.scripts/date.sh&
~/.scripts/topstatusbar.sh&
#xcompmgr -cCfF -o .35 -r 3.2 -t-2 -l-1 -D 3 -O-.03 -I-.015&
hsetroot -full $HOME/Pics/wallpapers/88a9bb3de320adf34f2318cd68e81602.jpg 
wmname LG3D
exec ssh-agent ck-launch-session dbus-launch --exit-with-session xmonad 
