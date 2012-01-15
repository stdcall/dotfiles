#!/usr/bin/env bash
source $HOME/.scripts/theme
WIDTH=50
HEIGHT=8
MARGIN=$TRAY_MARGIN
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype pixel --width $WIDTH --heighttype pixel --height $HEIGHT --margin $MARGIN --transparent true --alpha 0 --tint 0x1a1a1a
