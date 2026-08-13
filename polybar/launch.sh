#!/usr/bin/env bash
# Mata instâncias antigas antes de subir uma nova (evita barra duplicada)
killall -q polybar
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.5; done
polybar main -c "$HOME/.config/polybar/config.ini" &
