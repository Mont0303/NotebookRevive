#!/bin/bash
# =========================================================
# Cyberdeck Tactical Toolkit — Ferramentas Funcionais de Campo
# =========================================================

options="🔇 Silencio de Radio (Alternar Wi-Fi e Bluetooth)\n🎭 Randomizar MAC Address (Anonimato Wi-Fi)\n🌡 Monitor Termico e Clock da CPU\n🛡 Informacoes de Rede e VPN (IPs)\n📡 Escanear Redes Wi-Fi (nmcli)\n🔌 Conectar Console Serial USB (115200)\n🔍 Varredura de Rede Local (Nmap)\n▶ Tocar Video do Clipboard (MPV VA-API)\n⚡ Monitor de Sistema (btop/htop)"

chosen=$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/config.rasi -p "cyberdeck" -i)

case "$chosen" in
    *"Silencio de Radio"*)
        # Alterna entre bloquear e desbloquear todos os sinais de rádio (Wi-Fi e Bluetooth)
        WIFI_STATUS=$(nmcli radio wifi)
        if [ "$WIFI_STATUS" = "enabled" ]; then
            nmcli radio all off
            notify-send -u critical "Silêncio de Rádio" "Wi-Fi e Bluetooth DESLIGADOS (Modo Furtivo Ativo)"
        else
            nmcli radio all on
            notify-send -u normal "Silêncio de Rádio" "Wi-Fi e Bluetooth LIGADOS"
        fi
        ;;
    *"Randomizar MAC"*)
        # Troca o endereço físico da placa de rede Wi-Fi para anonimato
        WLAN=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^wl' | head -n 1)
        if [ -z "$WLAN" ]; then
            WLAN="wlan0"
        fi
        
        notify-send "Anonimato MAC" "Desconectando e gerando novo MAC aleatório para $WLAN..."
        nmcli device disconnect "$WLAN" 2>/dev/null
        
        if command -v macchanger &>/dev/null; then
            sudo macchanger -r "$WLAN" >/dev/null 2>&1
        else
            # Fallback nativo usando ip link se macchanger não estiver instalado
            GEN_MAC=$(printf '02:%02X:%02X:%02X:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
            sudo ip link set dev "$WLAN" down
            sudo ip link set dev "$WLAN" address "$GEN_MAC"
            sudo ip link set dev "$WLAN" up
        fi
        
        NEW_MAC=$(cat /sys/class/net/"$WLAN"/address 2>/dev/null)
        nmcli device connect "$WLAN" 2>/dev/null
        notify-send -u normal "Anonimato MAC" "Novo endereço MAC ativo:\n$NEW_MAC"
        ;;
    *"Monitor Termico"*)
        alacritty -e ~/.config/i3/scripts/thermal-status.sh
        ;;
    *"Informacoes de Rede"*)
        LOCAL_IP=$(ip -4 addr show 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | paste -sd ", " -)
        VPN_IP=$(ip -4 addr show dev tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "Nenhuma")
        GATEWAY=$(ip route 2>/dev/null | grep default | awk '{print $3}' | head -n 1)
        notify-send -u normal "Rede Cyberdeck" "IP Local: $LOCAL_IP\nGateway: $GATEWAY\nVPN (tun0): $VPN_IP"
        ;;
    *"Escanear Redes"*)
        alacritty --hold -e nmcli device wifi list
        ;;
    *"Console Serial"*)
        PORT=$(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null | head -n 1)
        if [ -n "$PORT" ]; then
            notify-send "Console Serial" "Conectando em $PORT a 115200 baud..."
            alacritty -e picocom -b 115200 "$PORT"
        else
            notify-send "Console Serial" "Nenhum dispositivo serial detectado em /dev/ttyUSB* ou /dev/ttyACM*"
        fi
        ;;
    *"Varredura de Rede"*)
        GATEWAY=$(ip route 2>/dev/null | grep default | awk '{print $3}' | head -n 1)
        if [ -n "$GATEWAY" ]; then
            SUBNET="${GATEWAY%.*}.0/24"
            alacritty --hold -e bash -c "echo 'Escaneando sub-rede: $SUBNET com nmap...'; nmap -sn $SUBNET; echo -e '\nPressione Enter para fechar...'; read"
        else
            notify-send "Nmap" "Sem conexão de rede ativa no momento."
        fi
        ;;
    *"Tocar Video"*)
        URL=$(xclip -o -selection clipboard 2>/dev/null)
        if [ -n "$URL" ]; then
            notify-send "Video MPV" "Abrindo link acelerado pela GPU..."
            mpv "$URL"
        else
            notify-send "Video MPV" "Nenhuma URL encontrada na área de transferência!"
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
