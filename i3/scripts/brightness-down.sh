#!/bin/bash
brightnessctl set 5%- > /dev/null
level=$(brightnessctl -m | cut -d',' -f4 | tr -d '%')
notify-send -h int:value:"$level" -h string:x-dunst-stack-tag:brightness "Brilho"
