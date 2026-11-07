#!/bin/bash
# =========================================================
# Scratchpad Tático Inteligente (Toggle Unificado com 1 Tecla)
# =========================================================

# Verifica se a janela do scratchpad já está em execução no X11
if xdotool search --class "tactical_scratchpad" >/dev/null 2>&1; then
    # Se já existe, apenas alterna entre mostrar / esconder
    i3-msg '[class="tactical_scratchpad"] scratchpad show'
else
    # Se ainda não existe, cria a janela e envia para o scratchpad
    alacritty --class "tactical_scratchpad" &
fi
