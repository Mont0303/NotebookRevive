# =========================================================
# qutebrowser — Tactical Amber HUD (Motion Plus Q464B)
# =========================================================

config.load_autoconfig(False)

# ---- performance: hardware fraco, corta gordura ----
c.content.javascript.enabled = True
c.content.autoplay = False
c.content.images = True
c.content.pdfjs = False
c.content.notifications.enabled = False
c.tabs.show = "multiple"
c.statusbar.show = "in-mode"
c.scrolling.smooth = False

# ---- fonte ----
c.fonts.default_family = "JetBrains Mono"
c.fonts.default_size = "10pt"

# ---- tema: Tactical Amber (#0d0e11 / #ff9e3b) ----
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"

c.colors.completion.fg = "#e6dfd3"
c.colors.completion.odd.bg = "#0d0e11"
c.colors.completion.even.bg = "#0d0e11"
c.colors.completion.category.fg = "#ff9e3b"
c.colors.completion.category.bg = "#16171d"
c.colors.completion.item.selected.fg = "#0d0e11"
c.colors.completion.item.selected.bg = "#ff9e3b"
c.colors.completion.scrollbar.fg = "#ff9e3b"
c.colors.completion.scrollbar.bg = "#0d0e11"

c.colors.statusbar.normal.fg = "#e6dfd3"
c.colors.statusbar.normal.bg = "#0d0e11"
c.colors.statusbar.insert.fg = "#0d0e11"
c.colors.statusbar.insert.bg = "#ff9e3b"
c.colors.statusbar.command.fg = "#ff9e3b"
c.colors.statusbar.command.bg = "#0d0e11"
c.colors.statusbar.url.fg = "#e6dfd3"
c.colors.statusbar.url.success.https.fg = "#ff9e3b"

c.colors.tabs.bar.bg = "#0d0e11"
c.colors.tabs.odd.fg = "#70624e"
c.colors.tabs.odd.bg = "#0d0e11"
c.colors.tabs.even.fg = "#70624e"
c.colors.tabs.even.bg = "#0d0e11"
c.colors.tabs.selected.odd.fg = "#0d0e11"
c.colors.tabs.selected.odd.bg = "#ff9e3b"
c.colors.tabs.selected.even.fg = "#0d0e11"
c.colors.tabs.selected.even.bg = "#ff9e3b"

# ---- página inicial e busca ----
c.url.default_page = "https://start.duckduckgo.com"
c.url.start_pages = ["https://start.duckduckgo.com"]
c.url.searchengines = {"DEFAULT": "https://duckduckgo.com/?q={}"}

# ---- integração com MPV (tocar vídeos com aceleração de hardware) ----
config.bind(',m', 'spawn mpv {url}')
config.bind(',M', 'hint links spawn mpv {hint-url}')
