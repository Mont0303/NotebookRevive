#!/bin/bash
# =========================================================
# Atualizador & Instalador de Configurações do Cyberdeck
# Motion Plus Q464B (Intel Atom x5-Z8350)
# =========================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         CYBERDECK Q464B — ATUALIZADOR DE SETUP           ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"

# Se passar o parâmetro --deps, instala pacotes de vídeo e utilitários
if [ "$1" == "--deps" ]; then
    echo -e "\n${YELLOW}Instalando drivers de aceleração gráfica, MPV e utilitários do Cyberdeck...${NC}"
    sudo pacman -S --needed --noconfirm \
        libva-intel-driver libva-utils mesa \
        mpv yt-dlp xclip \
        picocom nmap btop
    echo -e "${GREEN}✔ Dependências instaladas com sucesso!${NC}\n"
fi

echo -e "${CYAN}[1/4] Criando estrutura de diretórios em ~/.config...${NC}"
mkdir -p ~/.config/{i3,alacritty,polybar,rofi,dunst,cmus,zathura,qutebrowser,geany,starship,fastfetch,mpv,networkmanager-dmenu,betterlockscreen,aichat}
mkdir -p ~/.config/i3/scripts
mkdir -p ~/.config/geany/colorschemes

echo -e "${CYAN}[2/4] Copiando arquivos de configuração...${NC}"
# Core UI
cp -v i3/config ~/.config/i3/config
cp -v i3/scripts/*.sh ~/.config/i3/scripts/
cp -v alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp -v polybar/config.ini ~/.config/polybar/config.ini
cp -v polybar/launch.sh ~/.config/polybar/launch.sh
cp -v rofi/config.rasi ~/.config/rofi/config.rasi
cp -v wallpaper.png ~/.config/wallpaper.png

# Vídeo & Navegação Hacker
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

# AI Chat: preserva API key caso já exista
if [ ! -f ~/.config/aichat/config.yaml ] && [ -f aichat/config.yaml ]; then
    cp -v aichat/config.yaml ~/.config/aichat/config.yaml
else
    echo -e "  ${YELLOW}~/.config/aichat/config.yaml já existe (preservando chave de API)${NC}"
fi

echo -e "${CYAN}[3/4] Aplicando permissões de execução aos scripts...${NC}"
chmod +x ~/.config/i3/scripts/*.sh
chmod +x ~/.config/polybar/launch.sh
chmod +x atualizador.sh

echo -e "${CYAN}[4/4] Recarregando interface...${NC}"
if pgrep -x "i3" > /dev/null; then
    i3-msg reload
    ~/.config/polybar/launch.sh &
    echo -e "${GREEN}✔ i3 e Polybar recarregados com sucesso!${NC}"
else
    echo -e "  i3 não está em execução no momento (as configs serão aplicadas no próximo login)."
fi

echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           ✔ ATUALIZAÇÃO CONCLUÍDA COM SUCESSO!           ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo -e "Novos atalhos adicionados:"
echo -e "  • ${CYAN}Super + X${NC}       → Menu de Ferramentas do Cyberdeck (Serial, Nmap, Térmico)"
echo -e "  • ${CYAN}Super + Y${NC}       → Tocar vídeo da área de transferência (MPV + Aceleração GPU)"
echo -e "  • ${CYAN},m${NC} no qutebrowser → Tocar vídeo da página direto no MPV"
echo -e "\nPara instalar os drivers de vídeo e pacotes do Cyberdeck se ainda não instalou:"
echo -e "  ${YELLOW}./atualizador.sh --deps${NC}\n"