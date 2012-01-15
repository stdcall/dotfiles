#!/usr/bin/env bash
source $HOME/.scripts/theme
#Layout
BAR_H=8
BIGBAR_W=30
SMABAR_W=15

X_POS=$TOPSTATUSBAR_X_POS
WIDTH=$TOPSTATUSBAR_WIDTH

#Options
IFS='|' #internal field separator (conky)
CONKYFILE="/home/scriper/.config/conky/conkyrc"
ICONPATH="/home/scriper/.icons/subtlexbm"
INTERVAL=1
CPUTemp=0
GPUTemp=0
CPULoad0=0
CPULoad1=0
NetUp=0
NetDown=0

printVolInfo() {
        Perc=$(amixer get Master | grep "Front Right:" | awk '{print $5}' | tr -d '[]%')
        if [[ $Perc == "0" ]]; then
                echo -n "^fg($COLOR_ICON)^i($ICONPATH/volume_off.xbm) "
                echo -n "^fg()off "
                echo -n "$(echo $Perc | gdbar -fg $CRIT -bg $BAR_BG -h $BAR_H -w $BIGBAR_W  -nonl)"
        else
                echo -n "^fg($COLOR_ICON)^i($ICONPATH/volume_on.xbm)^fg()"
                echo -n "$(echo $Perc | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -nonl)"
        fi
        return
}

printCPUInfo() {
        echo -n "^fg($COLOR_ICON)^i($ICONPATH/cpu.xbm)^fg() "
        echo -n "$(echo $CPULoad0 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W  -nonl) "
        echo -n "$(echo $CPULoad1 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W  -nonl) "
        echo -n "${CPUFreq}GHz"
        return
}

printTempInfo() {
        CPUTemp=$(acpi --thermal | awk '{print substr($4,0,2)}')
        GPUTemp=$(nvidia-settings -q gpucoretemp | grep 'Attribute' | awk '{print $4}' | tr -d '.')
        if [[ $CPUTemp -gt 70 ]]; then
                CPUTemp="^fg($CRIT)$CPUTemp^fg()"
        fi
        if [[ $GPUTemp -gt 70 ]]; then
                GPUTemp="^fg($CRIT)$GPUTemp^fg()"
        fi
        echo -n "^fg($COLOR_ICON)^i($ICONPATH/temp.xbm) "
        echo -n "^fg($DZEN_FG2)cpu ^fg()${CPUTemp}c "
        echo -n "^fg($DZEN_FG2)gpu ^fg()${GPUTemp}c"
        return
}

printMemInfo() {
        echo -n "^fg($COLOR_ICON)^i($ICONPATH/memory.xbm) "
        echo -n "^fg()${MemUsed} "
        echo -n "$(echo $MemPerc | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $SMABAR_W -nonl)"
        return
}

printBattery() {
        BatPresent=$(acpi -b | wc -l)
        ACPresent=$(acpi -a | grep -c on-line)
        if [[ $ACPresent == "1" ]]; then
                echo -n "^fg($COLOR_ICON)^i($ICONPATH/ac1.xbm) "
        else
                echo -n "^fg($COLOR_ICON)^i($ICONPATH/battery_vert3.xbm) "
        fi
        if [[ $BatPresent == "0" ]]; then
                echo -n "^fg($DZEN_FG2)AC ^fg()on ^fg($DZEN_FG2)Bat ^fg()off"
                return
        else
                RPERC=$(acpi -b | awk '{print $4}' | tr -d "%,")
                echo -n "^fg()$RPERC% "
                if [[ $ACPresent == "1" ]]; then
                        echo -n "$(echo $RPERC | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -ss 1 -sw 4 -nonl)"
                else
                        echo -n "$(echo $RPERC | gdbar -fg $CRIT -bg $BAR_BG -h $BAR_H -w $BIGBAR_W -ss 1 -sw 4 -nonl)"
                fi
        fi
        return
}

printMPDinfo() {
        if [ $MPDStatus == "Playing" ]; then
                echo -n "^fg(${COLOR_ICON})^i(/home/scriper/Pics/icons/music.xpm)"
                echo -n "^fg() ${MPDArtist} - ${MPDTitle}"
        fi
        return
}

printMail() {
        echo -n "^fg($COLOR_ICON)^i($ICONPATH/mail.xbm) ^fg()${GMAIL}"
        return
}

printDiskInfo() {
        RFSP=$(df -h /home | tail -1 | awk -F' ' '{ print $5 }' | tr -d '%')
        BFSP=$(df -h /data | tail -1 | awk -F' ' '{ print $5 }' | tr -d '%')
        if [[ $RFSP -gt 70 ]]; then
                RFSP="^fg($CRIT)"$RFSP"^fg()"
        fi
        if [[ $BFSP -gt 70 ]]; then
                BFSP="^fg($CRIT)"$BFSP"^fg()"
        fi
        echo -n "^fg($COLOR_ICON)^i($ICONPATH/file1.xbm) "
        echo -n "^fg($DZEN_FG2)home ^fg()${RFSP}% "
        echo -n "^fg($DZEN_FG2)data ^fg()${BFSP}%"
        return
}

printKerInfo() {
        echo -n " ^fg()$(uname -r)^fg(#007b8c)/^fg(#5f656b)$(uname -m) ^fg(#a488d9)| ^fg()$Uptime"
        return
}

printSpace() {
        echo -n " ^fg($COLOR_SEP)|^fg() "
        return
}

printArrow() {
        echo -n " ^fg(#a488d9)>^fg(#007b8c)>^fg(#444444)> "
        return
}

printBar() {
        while true; do
                read CPULoad0 CPULoad1 CPUFreq MemUsed MemPerc Uptime MPDStatus MPDArtist MPDTitle GMAIL
                #printKerInfo
                #printSpace
                printCPUInfo
                printSpace
                printMemInfo
                printArrow
                echo -n "^p(+10)"
                printDiskInfo
                printSpace
                printTempInfo
                printSpace
                printVolInfo
                printArrow
                printMPDinfo
                printSpace
                printMail

                echo
        done
        return
}

#Print all and pipe into dzen

conky -c $CONKYFILE -u $INTERVAL | printBar | dzen2 -x $X_POS -y $Y_POS -w $WIDTH -h $HEIGHT -fn $FONT -ta 'l' -bg $DZEN_BG -fg $DZEN_FG -p -e ''

