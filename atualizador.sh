#!/bin/bash
# =========================================================
# Atualizador & Instalador de Configurações do Cyberdeck
# Motion Plus Q464B — MIL-SPEC Tactical Amber Edition
# =========================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
AMBER='\033[38;5;214m'
NC='\033[0m'

echo -e "${AMBER}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${AMBER}║     CYBERDECK Q464B // MIL-SPEC TACTICAL HUD SETUP       ║${NC}"
echo -e "${AMBER}╚══════════════════════════════════════════════════════════╝${NC}"

# Se passar o parâmetro --deps, instala pacotes de vídeo, ferramentas e xdotool
if [ "$1" == "--deps" ]; then
    echo -e "\n${YELLOW}Instalando dependências de vídeo, utilitários e xdotool...${NC}"
    sudo pacman -S --needed --noconfirm \
        libva-intel-driver libva-utils mesa \
        mpv yt-dlp xclip xdotool macchanger \
        picocom nmap btop
    echo -e "${GREEN}✔ Dependências instaladas com sucesso!${NC}\n"
fi

echo -e "${CYAN}[1/5] Criando estrutura de diretórios em ~/.config...${NC}"
mkdir -p ~/.config/{i3,alacritty,polybar,rofi,dunst,cmus,zathura,qutebrowser,geany,starship,fastfetch,mpv,networkmanager-dmenu,betterlockscreen,aichat}
mkdir -p ~/.config/i3/scripts
mkdir -p ~/.config/geany/colorschemes

echo -e "${CYAN}[2/5] Copiando arquivos de configuração táticos...${NC}"
# Core UI
cp -v i3/config ~/.config/i3/config
cp -v i3/scripts/*.sh ~/.config/i3/scripts/
cp -v alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp -v polybar/config.ini ~/.config/polybar/config.ini
cp -v polybar/launch.sh ~/.config/polybar/launch.sh
cp -v rofi/config.rasi ~/.config/rofi/config.rasi
cp -v wallpaper.png ~/.config/wallpaper.png

# Vídeo & Navegação
cp -v mpv/mpv.conf ~/.config/mpv/mpv.conf
cp -v qutebrowser/config.py ~/.config/qutebrowser/config.py

# Utilitários & Notificações
cp -v dunst/dunstrc ~/.config/dunst/dunstrc
cp -v cmus/rc ~/.config/cmus/rc
cp -v zathura/zathurarc ~/.config/zathura/zathurarc
cp -v fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
cp -v fastfetch/logo.txt ~/.config/fastfetch/logo.txt
cp -v starship/starship.toml ~/.config/starship.toml
cp -v networkmanager-dmenu/config.ini ~/.config/networkmanager-dmenu/config.ini
cp -v betterlockscreen/betterlockscreenrc ~/.config/betterlockscreen/betterlockscreenrc
[ -f xprofile/.xprofile ] && cp -v xprofile/.xprofile ~/.xprofile
[ -f geany/colorschemes/matrix_q464b.conf ] && cp -v geany/colorschemes/matrix_q464b.conf ~/.config/geany/colorschemes/

# Preserva chave de API do aichat
if [ ! -f ~/.config/aichat/config.yaml ] && [ -f aichat/config.yaml ]; then
    cp -v aichat/config.yaml ~/.config/aichat/config.yaml
fi

echo -e "${CYAN}[3/5] Aplicando permissões de execução aos scripts...${NC}"
chmod +x ~/.config/i3/scripts/*.sh
chmod +x ~/.config/polybar/launch.sh
chmod +x atualizador.sh

echo -e "${CYAN}[4/5] Atualizando tela de login (LightDM) e bloqueio (Betterlockscreen)...${NC}"
# Atualiza LightDM no sistema
if [ -d /etc/lightdm ]; then
    sudo mkdir -p /usr/share/lightdm-gtk-greeter/matrix-q464b 2>/dev/null || true
    sudo cp -f lightdm/background.png /usr/share/lightdm-gtk-greeter/matrix-q464b/background.png 2>/dev/null || true
    sudo mkdir -p /usr/share/themes/matrix-q464b-lightdm/gtk-3.0 2>/dev/null || true
    sudo cp -f lightdm/matrix-q464b-lightdm/gtk-3.0/gtk.css /usr/share/themes/matrix-q464b-lightdm/gtk-3.0/gtk.css 2>/dev/null || true
fi

# Regenera cache do Betterlockscreen com o novo wallpaper tático
if command -v betterlockscreen &>/dev/null; then
    echo -e "  Regenerando cache do lockscreen militar..."
    betterlockscreen -u ~/.config/wallpaper.png 2>/dev/null || true
fi

echo -e "${CYAN}[5/5] Recarregando interface...${NC}"
if pgrep -x "i3" > /dev/null; then
    i3-msg reload
    ~/.config/polybar/launch.sh &
    feh --bg-fill ~/.config/wallpaper.png
    echo -e "${GREEN}✔ i3, Polybar e Wallpaper recarregados com sucesso!${NC}"
fi

echo -e "\n${AMBER}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${AMBER}║     ✔ SETUP MILITAR TÁTICO ATUALIZADO COM SUCESSO!       ║${NC}"
echo -e "${AMBER}╚══════════════════════════════════════════════════════════╝${NC}"
echo -e "Comandos principais:"
echo -e "  • ${AMBER}Super + U${NC}         → Scratchpad Tático (Abre / Esconde com 1 tecla)"
echo -e "  • ${AMBER}Super + X${NC}         → Menu de Campo Tático (Rede, Nmap, Térmico, Serial)"
echo -e "  • ${AMBER}Super + Y${NC}         → Tocar vídeo com aceleração de hardware (MPV)"
echo -e "  • ${AMBER}Super + Shift + X${NC} → Testar Lockscreen Militar Tático\n"