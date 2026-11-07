#!/bin/bash
# Menu de energia/sessão (Motion Plus Q464B)
# "Encerrar sessão" fecha o i3 e volta pra tela de login (SDDM),
# onde dá pra escolher outra sessão (ex: KDE Plasma) sem reiniciar o PC.

options="Bloquear\nEncerrar sessao (trocar pra Plasma etc)\nSuspender\nReiniciar\nDesligar"

chosen=$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/config.rasi -p "power" -i)

case "$chosen" in
    "Bloquear")
        betterlockscreen -l dim
        ;;
    "Encerrar sessao (trocar pra Plasma etc)")
        i3-msg exit
        ;;
    "Suspender")
        systemctl suspend
        ;;
    "Reiniciar")
        systemctl reboot
        ;;
    "Desligar")
        systemctl poweroff
        ;;
esac
