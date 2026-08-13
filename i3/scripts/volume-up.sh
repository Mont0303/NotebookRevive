#!/bin/bash
pactl set-sink-volume @DEFAULT_SINK@ +5%
level=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')
notify-send -h int:value:"$level" -h string:x-dunst-stack-tag:volume "Volume"
