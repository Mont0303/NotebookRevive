#!/bin/bash
# =========================================================
# Cyberdeck Quick Toolkit (Menu de Campo)
# =========================================================

options="▶ Tocar Video da Area de Transferencia (MPV)\n🌡 Monitor Termico e Cooler\n📡 Escanear Redes Wi-Fi\n🔌 Conectar Console Serial USB\n🔍 Varredura de Rede Local (Nmap)\n⚡ Monitor de Sistema (btop/htop)"

chosen=$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/config.rasi -p "cyberdeck" -i)

case "$chosen" in
    *"Tocar Video"*)
        URL=$(xclip -o -selection clipboard 2>/dev/null)
        if [ -n "$URL" ]; then
            notify-send "Cyberdeck Video" "Abrindo vídeo via MPV com aceleração VA-API..."
            mpv "$URL"
        else
            notify-send "Cyberdeck Video" "Nenhuma URL copiada na área de transferência!"
        fi
        ;;
    *"Monitor Termico"*)
        alacritty -e ~/.config/i3/scripts/thermal-status.sh
        ;;
    *"Escanear Redes"*)
        alacritty --hold -e nmcli device wifi list
        ;;
    *"Console Serial"*)
        PORT=$(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null | head -n 1)
        if [ -n "$PORT" ]; then
            notify-send "Cyberdeck Serial" "Conectando em $PORT (115200 baud)..."
            alacritty -e picocom -b 115200 "$PORT"
        else
            notify-send "Cyberdeck Serial" "Nenhuma porta serial detectada (/dev/ttyUSB* ou /dev/ttyACM*)"
        fi
        ;;
    *"Varredura de Rede"*)
        GATEWAY=$(ip route 2>/dev/null | grep default | awk '{print $3}' | head -n 1)
        if [ -n "$GATEWAY" ]; then
            SUBNET="${GATEWAY%.*}.0/24"
            alacritty --hold -e bash -c "echo 'Escaneando sub-rede: $SUBNET com nmap...'; nmap -sn $SUBNET; echo -e '\nPressione Enter para fechar...'; read"
        else
            notify-send "Cyberdeck Nmap" "Sem conexão de rede ativa no momento."
        fi
        ;;
    *"Monitor de Sistema"*)
        if command -v btop &>/dev/null; then
            alacritty -e btop
        else
            alacritty -e htop
        fi
        ;;
esac
