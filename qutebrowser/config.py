# =========================================================
# qutebrowser — navegador leve, por teclado (Motion Plus Q464B)
# =========================================================

config.load_autoconfig(False)

# ---- performance: hardware fraco, então corta gordura ----
c.content.javascript.enabled = True          # necessário pra maioria dos sites da faculdade (AVA, Google, etc)
c.content.autoplay = False                   # nada de video/audio tocando sozinho comendo CPU
c.content.images = True
c.content.pdfjs = False                      # abre PDF no zathura em vez do viewer interno
c.content.notifications.enabled = False
c.tabs.show = "multiple"                     # some a barra de abas quando só tem 1 aberta
c.statusbar.show = "in-mode"                 # status bar só aparece quando precisa (modo comando etc)
c.scrolling.smooth = False                   # scroll suave custa CPU à toa nesse hardware

# ---- fonte ----
c.fonts.default_family = "JetBrains Mono"
c.fonts.default_size = "10pt"

# ---- tema (mesma paleta do resto: fundo #0d1117, accent #39ff5c) ----
c.colors.webpage.darkmode.enabled = True     # força modo escuro em sites que não tem um nativo
c.colors.webpage.darkmode.algorithm = "lightness-cielab"

c.colors.completion.fg = "#c9d1d9"
c.colors.completion.odd.bg = "#0d1117"
c.colors.completion.even.bg = "#0d1117"
c.colors.completion.category.fg = "#39ff5c"
c.colors.completion.category.bg = "#161b22"
c.colors.completion.item.selected.fg = "#0d1117"
c.colors.completion.item.selected.bg = "#39ff5c"
c.colors.completion.scrollbar.fg = "#39ff5c"
c.colors.completion.scrollbar.bg = "#0d1117"

c.colors.statusbar.normal.fg = "#c9d1d9"
c.colors.statusbar.normal.bg = "#0d1117"
c.colors.statusbar.insert.fg = "#0d1117"
c.colors.statusbar.insert.bg = "#39ff5c"
c.colors.statusbar.command.fg = "#39ff5c"
c.colors.statusbar.command.bg = "#0d1117"
c.colors.statusbar.url.fg = "#c9d1d9"
c.colors.statusbar.url.success.https.fg = "#39ff5c"

c.colors.tabs.bar.bg = "#0d1117"
c.colors.tabs.odd.fg = "#6e7681"
c.colors.tabs.odd.bg = "#0d1117"
c.colors.tabs.even.fg = "#6e7681"
c.colors.tabs.even.bg = "#0d1117"
c.colors.tabs.selected.odd.fg = "#0d1117"
c.colors.tabs.selected.odd.bg = "#39ff5c"
c.colors.tabs.selected.even.fg = "#0d1117"
c.colors.tabs.selected.even.bg = "#39ff5c"

# ---- página inicial e busca ----
c.url.default_page = "https://start.duckduckgo.com"
c.url.start_pages = ["https://start.duckduckgo.com"]
c.url.searchengines = {"DEFAULT": "https://duckduckgo.com/?q={}"}

# O resto dos atalhos já vem por padrão, estilo vim: hjkl pra navegar,
# o/O pra abrir URL, d pra fechar aba, u pra reabrir, gg/G pro topo/fim
# da página, / pra buscar no texto. Não precisa remapear nada disso.
