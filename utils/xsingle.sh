#!/bin/bash

if [[ "$(echo $XDG_SESSION_TYPE)" == 'x11' ]]; then
    xrandr --output DP-4 --mode 2560x1440 --rotate normal --rate 165 --primary \
        --output HDMI-0 --off
else
    kscreen-doctor output.DP-4.enable output.DP-4.mode.3 output.DP-4.position.0,0 \
        output.HDMI-A-3.disable
fi
