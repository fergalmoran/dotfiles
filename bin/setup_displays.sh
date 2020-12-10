#!/usr/bin/env bash

xrandr --output LVDS1 --off --output HDMI-1  --mode "1920x1080"  --rate 60 --output DP2 --off
sleep 1s
xrandr --output LVDS1 --off --output DVI-D-1 --mode "1920x1080" --rate 60  --output DP2 --mode "3840x2160" --pos "3840x0"
