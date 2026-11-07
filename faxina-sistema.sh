#!/bin/bash
# =========================================================
# Faxina Profunda do Sistema — Cyberdeck Q464B
# Remove resíduos do KDE/Plasma, caches antigos, órfãos e logs
# Recupera espaço no eMMC de 64GB e memória RAM.
# =========================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
AMBER='\033[38;5;214m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${AMBER}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${AMBER}║       CYBERDECK Q464B // FAXINA PROFUNDA DO SISTEMA      ║${NC}"
echo -e "${AMBER}╚══════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}Espaço em disco ANTES da limpeza:${NC}"
df -h / | awk 'NR==1 || NR==2'

# 1. Desativar e eliminar serviços do indexador Baloo
echo -e "\n${CYAN}[1/6] Desativando e removendo indexador Baloo...${NC}"
if command -v balooctl &>/dev/null; then
    balooctl suspend 2>/dev/null || true
    balooctl disable 2>/dev/null || true
fi
rm -rf ~/.local/share/baloo 2>/dev/null || true
echo -e "${GREEN}✔ Baloo eliminado.${NC}"

# 2. Desinstalar pacotes do KDE Plasma, SDDM e apps pesados do KDE
echo -e "\n${CYAN}[2/6] Removendo pacotes do KDE Plasma, SDDM e apps residuais...${NC}"
KDE_PKGS=(
    plasma-desktop plasma-workspace sddm discover kinfocenter
    dolphin kate kwrite gwenview okular ark konsole
    kwallet kwallet-pam plasma-nm plasma-pa kio-extras
    baloo baloo-widgets systemsettings
)

TO_REMOVE=()
for pkg in "${KDE_PKGS[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
        TO_REMOVE+=("$pkg")
    fi
done

if [ ${#TO_REMOVE[@]} -gt 0 ]; then
    echo -e "  Removendo pacotes: ${TO_REMOVE[*]}"
    sudo pacman -Rns --noconfirm "${TO_REMOVE[@]}" 2>/dev/null || sudo pacman -Rdd --noconfirm "${TO_REMOVE[@]}" 2>/dev/null || true
    echo -e "${GREEN}✔ Pacotes do KDE Plasma removidos.${NC}"
else
    echo -e "  Nenhum pacote do KDE Plasma encontrado."
fi

# 3. Remover pacotes órfãos (dependências esquecidas que não servem para nada)
echo -e "\n${CYAN}[3/6] Removendo pacotes órfãos do sistema...${NC}"
ORPHANS=$(pacman -Qtdq 2>/dev/null || true)
if [ -n "$ORPHANS" ]; then
    echo -e "  Pacotes órfãos encontrados. Removendo..."
    sudo pacman -Rns --noconfirm $ORPHANS 2>/dev/null || true
    echo -e "${GREEN}✔ Órfãos eliminados.${NC}"
else
    echo -e "  Nenhum pacote órfão encontrado."
fi

# 4. Limpar cache do gerenciador de pacotes Pacman
echo -e "\n${CYAN}[4/6] Limpando cache do pacman (/var/cache/pacman/pkg)...${NC}"
sudo pacman -Sc --noconfirm 2>/dev/null || true
echo -e "${GREEN}✔ Cache de pacotes limpo.${NC}"

# 5. Limpar logs acumulados do systemd (journalctl)
echo -e "\n${CYAN}[5/6] Reduzindo logs do sistema para no máximo 50MB...${NC}"
sudo journalctl --vacuum-size=50M 2>/dev/null || true
sudo journalctl --vacuum-time=3d 2>/dev/null || true
echo -e "${GREEN}✔ Logs antigos do systemd descartados.${NC}"

# 6. Limpar caches temporários de usuário (~/.cache)
echo -e "\n${CYAN}[6/6] Limpando thumbnails e arquivos temporários de ~/.cache...${NC}"
rm -rf ~/.cache/thumbnails/* 2>/dev/null || true
rm -rf ~/.cache/google-chrome/* 2>/dev/null || true
rm -rf ~/.cache/chromium/* 2>/dev/null || true
echo -e "${GREEN}✔ Cache de usuário limpo.${NC}"

# Garantir LightDM ativo
sudo systemctl disable sddm 2>/dev/null || true
sudo systemctl enable lightdm 2>/dev/null || true

echo -e "\n${AMBER}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${AMBER}║             ✔ FAXINA CONCLUÍDA COM SUCESSO!              ║${NC}"
echo -e "${AMBER}╚══════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}Espaço em disco DEPOIS da limpeza:${NC}"
df -h / | awk 'NR==1 || NR==2'

echo -e "\n${GREEN}Dica:${NC} Para um reboot limpo após a faxina, rode: ${CYAN}sudo reboot${NC}\n"
