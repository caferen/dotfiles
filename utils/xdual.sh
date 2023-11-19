#!/bin/bash


if [[ "$(echo $XDG_SESSION_TYPE)" == 'x11' ]]; then
    nvidia-settings --load-config-only &

    xrandr --output DP-4 --mode 2560x1440 --rotate normal --rate 165 --primary \
        --output HDMI-0 --mode 1920x1080 --right-of DP-4 --rate 75 --rotate left
else
    kscreen-doctor output.DP-4.enable output.DP-4.mode.3 output.DP-4.position.0,0 \
        output.HDMI-A-3.enable output.HDMI-A-3.mode.1 output.HDMI-A-3.position.2560,0
fi
