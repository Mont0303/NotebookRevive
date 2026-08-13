#!/bin/bash
pactl set-sink-mute @DEFAULT_SINK@ toggle
notify-send -h string:x-dunst-stack-tag:volume "Volume" "Mudo alternado"
