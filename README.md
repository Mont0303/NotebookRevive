# Setup — Motion Plus Q464B "terminal-hacker" (Arch + i3)

Tema minimalista, foco em ficar leve e funcional no hardware fraco
(Atom x5-Z8350, 4GB RAM). Accent color: verde estilo Matrix (`#39ff5c`), fundo quase
preto (`#0d1117`), fonte `JetBrains Mono`.

**Instalando do zero?** Veja primeiro o `PREREQUISITOS.md` — cobre a
instalação base do Arch e todos os pacotes necessários antes destes
passos aqui funcionarem. Se seu sistema já está com o setup rodando
(esse é o caso normal, atualizando algo pontual), pode ir direto pros
passos abaixo.

## 1. Sair do Plasma e instalar os pacotes

```bash
sudo pacman -S i3 alacritty polybar rofi feh picom brightnessctl \
               ttf-jetbrains-mono i3lock

# opcional: manager de sessão leve pra escolher i3 no login
sudo pacman -S lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm
```

Se quiser desinstalar o Plasma depois de confirmar que o i3 tá redondo:
```bash
sudo pacman -Rns plasma-desktop plasma-workspace sddm
```
(recomendo só fazer isso depois de usar o i3 por uns dias — mantém o KDE
como plano B enquanto você ajusta o resto)

## 2. Copiar os arquivos de config

```bash
mkdir -p ~/.config/{i3,alacritty,polybar,rofi}
cp i3/config          ~/.config/i3/config
cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp polybar/config.ini ~/.config/polybar/config.ini
cp polybar/launch.sh  ~/.config/polybar/launch.sh
cp rofi/config.rasi   ~/.config/rofi/config.rasi
cp wallpaper.png      ~/.config/wallpaper.png

chmod +x ~/.config/polybar/launch.sh
```

## 3. Ajustar o nome da interface de bateria (se precisar)

O `polybar/config.ini` assume `BAT0`. Confirme com:
```bash
ls /sys/class/power_supply/
```
Se for diferente (ex: `BAT1`), troca a linha `battery = BAT0` no config.

## 4. Compositor leve (sombra/transparência do Alacritty)

O Alacritty usa `opacity = 0.97` no config — pra isso funcionar direito
precisa de um compositor leve rodando. `picom` já foi instalado acima;
adicione ao final do `~/.config/i3/config` se quiser:
```
exec_always --no-startup-id picom --backend xrender -b
```
`--backend xrender` é importante aqui — o backend padrão (glx) pode pesar
demais nesse iGPU. Se sentir qualquer lag, é só remover essa linha e
rodar sem compositor (o resto do tema funciona igual, só sem a leve
transparência do terminal).

## 5. Testar

Faça logout, escolha "i3" na tela de login, e no primeiro boot o i3
pergunta se quer gerar um config padrão — escolha "não" (você já tem
o seu) e confirme a tecla de mod (sugiro deixar a tecla Super/Windows,
que já é o padrão desse config: `$mod = Mod4`).

Atalhos principais:
- `Super+Enter` → abre o Alacritty
- `Super+D` → abre o rofi (launcher de apps)
- `Super+Shift+Q` → fecha janela
- `Super+1..5` → troca de workspace (nomeados: term/code/web/docs/misc)
- `Super+H/J/K/L` → navega entre janelas (estilo vim)
- `Super+Shift+X` → tranca a tela

## 6. fastfetch (tela de boas-vindas do terminal)

```bash
sudo pacman -S fastfetch
mkdir -p ~/.config/fastfetch
cp fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
cp fastfetch/logo.txt     ~/.config/fastfetch/logo.txt
```

Pra rodar automaticamente toda vez que abrir um terminal novo, adicione ao
final do seu `~/.zshrc` (ou `~/.bashrc`, se usar bash):
```bash
fastfetch
```

Usei `fastfetch` em vez do `neofetch` de propósito — o neofetch está
arquivado (sem manutenção) e o fastfetch é o sucessor recomendado,
além de ser mais rápido, o que importa nesse hardware.

## 7. Layout de teclado BR

Já deixei no `i3/config` a linha:
```
exec_always --no-startup-id setxkbmap br
```
Isso aplica o layout ABNT2/BR toda vez que o i3 inicia ou recarrega — já
resolve pra sessão gráfica.

Se quiser deixar fixo em nível de sistema (vale também pro
console/TTY, antes de qualquer sessão gráfica abrir), crie:

```bash
sudo nano /etc/X11/xorg.conf.d/00-keyboard.conf
```

Com o conteúdo:
```
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "br"
    Option "XkbModel" "abnt2"
EndSection
```

E pro console (TTY, fora do X11):
```bash
sudo localectl set-keymap br-abnt2
```

## 8. Zathura (leitor de PDF)

```bash
sudo pacman -S zathura zathura-pdf-mupdf
mkdir -p ~/.config/zathura
cp zathura/zathurarc ~/.config/zathura/zathurarc
```

Uso: `zathura arquivo.pdf`. Como é totalmente controlado por teclado
(estilo vim), fica ótimo pra ler artigo/slide na aula sem precisar de
mouse:
- `j`/`k` → rolar
- `d`/`u` → meia página
- `/palavra` → buscar no texto
- `Ctrl+r` → liga/desliga o "modo escuro" do PDF em si (inverte as cores
  do documento, não só da interface — útil pra PDF branco brilhante)

Se quiser, associe o zathura como abridor padrão de PDF no seu
gerenciador de arquivos ou navegador.

## 9. cmus (player de música em terminal)

```bash
sudo pacman -S cmus ffmpeg
mkdir -p ~/.config/cmus ~/Music
cp cmus/rc ~/.config/cmus/rc
```

O `ffmpeg` aqui é o que dá suporte a mp3/outros formatos dentro do cmus
— sem ele o cmus toca só os formatos nativos (wav/flac). Ajuste a linha
`set library_dir = ~/Music` no `cmus/rc` se guardar seus arquivos em
outro lugar.

Já deixei um atalho no `i3/config`: `Super+M` abre o cmus direto num
terminal novo. Comandos básicos dentro do cmus:
- `5` → abre a biblioteca
- `x` → toca a faixa selecionada
- `c` → pausa/retoma
- `v` → para
- `+`/`-` → volume

## 10. qutebrowser (navegador leve, por teclado)

```bash
sudo pacman -S qutebrowser
mkdir -p ~/.config/qutebrowser
cp qutebrowser/config.py ~/.config/qutebrowser/config.py
```

Já deixei `Super+O` no `i3/config` pra abrir ele direto (usei O em vez
de B porque `Super+B` já era usado pra `split h`, dividir janela).
Principais
diferenças pra um Firefox comum, pensando no hardware:
- Sem autoplay de vídeo/áudio (evita CPU sendo gasta à toa em anúncio)
- Scroll suave desligado (custa processamento sem necessidade nesse iGPU)
- Modo escuro forçado em qualquer site, mesmo sites sem dark mode nativo
- PDF abre automaticamente no zathura em vez de um viewer interno

Atalhos (já vem assim, não precisei remapear nada — é tudo vim-style):
- `hjkl` → navegar na página / entre abas dependendo do contexto
- `o` → abrir URL na aba atual / `O` → em aba nova
- `d` → fechar aba / `u` → reabrir aba fechada
- `/palavra` → buscar na página
- `gg` / `G` → topo / fim da página

## 11. Geany (IDE leve)

```bash
sudo pacman -S geany
mkdir -p ~/.config/geany/colorschemes
cp geany/colorschemes/matrix_q464b.conf ~/.config/geany/colorschemes/matrix_q464b.conf
```

Depois, dentro do Geany: **View → Editor → Color Schemes** (ou
**Tools → Configuration Files**, dependendo da versão) e escolha
"Matrix Q464B" na lista. Pra fonte, vá em **Edit → Preferences → Editor
→ Display** e coloque `JetBrains Mono`.

Geany já vem com autocomplete, build/run integrado (F9/F8) e suporte a
várias linguagens (C, Python, Java, JS, etc.) — bem mais leve que o
VSCode porque não é Electron.

## 12. Lockscreen com o wallpaper (betterlockscreen)

```bash
yay -S betterlockscreen
mkdir -p ~/.config/betterlockscreen
cp betterlockscreen/betterlockscreenrc ~/.config/betterlockscreen/betterlockscreenrc

# gera o cache da imagem de lockscreen a partir do seu wallpaper atual
betterlockscreen -u ~/.config/wallpaper.png
```

Já troquei o atalho `Super+Shift+X` no `i3/config` pra usar o
`betterlockscreen -l dim` em vez do `i3lock` simples — mesma tela que
você já gostou, só que agora com o wallpaper por trás (com um dim leve
pra destacar o relógio) em vez de cor sólida.

## 13. IA no terminal (aichat)

```bash
# aichat está na AUR
yay -S aichat
mkdir -p ~/.config/aichat
cp aichat/config.yaml ~/.config/aichat/config.yaml
```

Você precisa de uma chave de API — a parte boa é que dá pra conseguir
**grátis**, sem cartão de crédito:

- **Google Gemini** (recomendo começar por aqui — free tier generoso):
  https://aistudio.google.com/apikey — faz login com conta Google, gera
  a chave, cola no lugar de `SUA_CHAVE_AQUI` na linha do `gemini` no
  `aichat/config.yaml`
- **Groq** (alternativa, também grátis, respostas bem rápidas):
  https://console.groq.com/keys

Só precisa configurar UM dos dois — apague ou ignore a seção do outro.
Depois é só rodar `Super+A` (já deixei o atalho no i3) pra abrir o
aichat num terminal novo, ou digitar `aichat` manualmente. Ele mantém
o contexto da conversa dentro da sessão, tem highlight de código, e
funciona bem mais leve que abrir um app de IA no navegador.

**Nota sobre nomes de modelo**: provedores de IA descontinuam modelos
com frequência (o `gemini-1.5-flash` que eu tinha colocado antes já
não existe mais, por exemplo). Se em algum momento o aichat der erro
de "model not found", geralmente é só isso — o nome mudou. Pra
conferir os modelos atuais do Gemini: https://ai.google.dev/gemini-api/docs/models

## 14. Prompt do terminal (starship) + ajustes no Alacritty

```bash
sudo pacman -S starship
mkdir -p ~/.config
cp starship/starship.toml ~/.config/starship.toml
```

Adicione ao final do `~/.zshrc` (ou equivalente do bash):
```bash
eval "$(starship init zsh)"
```

O prompt ecoa o mesmo estilo `usuario@host:pasta` que já aparece no
wallpaper — se quiser bater 100% com o "q464b" que aparece lá, dá pra
trocar o hostname do sistema:
```bash
sudo hostnamectl set-hostname q464b
```
(opcional — o prompt funciona normal com qualquer hostname, é só um
capricho estético)

O prompt mostra: usuário, host, pasta atual, branch do git (só dentro
de repositório), quanto tempo um comando demorou (útil pra perceber
quando algo tá pesando no hardware) e a bateria quando estiver abaixo
de 25%.

**No Alacritty**, já atualizei o `alacritty.toml` (é só copiar de novo
por cima do antigo) com:
- Cursor vira "contorno" quando a janela perde foco — ajuda a saber
  qual terminal está ativo quando tem mais de um aberto
- Flash rápido na cor do tema quando o terminal tocar o "bell" (ex: fim
  de autocomplete, comando terminou em outra aba) — é só um flash de
  150ms, não uma animação contínua, então não pesa
- Scrollback aumentado pra 10000 linhas — útil pra rolar pra trás depois
  de compilar/rodar algo grande

Propositalmente **não** adicionei blur ou transparência mais forte —
esses efeitos dependem do compositor rodando em GPU, e nesse iGPU
(Atom Z8350) isso é sentido rápido como lag digitando. Se um dia trocar
de hardware, aí sim vale a pena revisitar.

## 15. dunst (notificações)

```bash
sudo pacman -S dunst
mkdir -p ~/.config/dunst
cp dunst/dunstrc ~/.config/dunst/dunstrc
```

Já deixei o `exec --no-startup-id dunst` no `i3/config` pra ele subir
sozinho com a sessão. Notificações aparecem no canto superior direito,
mesmo esquema verde/preto, com destaque vermelho pra avisos críticos
(bateria baixa, por exemplo).

**Importante: dunst sozinho só EXIBE notificações, não gera nenhuma.**
Pra ele ter o que mostrar, já conectei duas fontes reais (ver abaixo:
volume/brilho nos próprios atalhos, e bateria via `batsignal`). Sem
isso, ele ficaria instalado e nunca apareceria nada.

Teste rápido depois de instalar (dispara uma notificação manual):
```bash
notify-send "Teste" "Se isso apareceu no tema certo, funcionou"
```

### Volume e brilho com aviso visual
O i3 tem um parser próprio que processa a linha do `bindsym exec` antes
de chegar no shell — comandos com `&&`, `$()` e aspas aninhadas todos
juntos confundem esse parser (foi o erro que você teve). A solução é
tirar a lógica da linha do config e colocar em scripts separados:

```bash
mkdir -p ~/.config/i3/scripts
cp i3/scripts/*.sh ~/.config/i3/scripts/
chmod +x ~/.config/i3/scripts/*.sh
```

O `i3/config` já foi atualizado pra só chamar os scripts (linha simples,
sem nada que o parser possa confundir). Depois de copiar, `Super+Shift+C`
pra recarregar e testar as teclas de brilho/volume.

### Bateria baixa (batsignal)
```bash
sudo pacman -S batsignal
```
Já deixei rodando via `exec` no `i3/config`:
```
batsignal -w 20 -c 10 -d 5 -f -i battery -I battery-full
```
Isso avisa em 20% (aviso normal), 10% (crítico) e 5% (urgente,
notificação não some sozinha). `-f` também avisa quando a bateria
enche 100% na tomada — útil já que você usa TLP e não deve deixar
carregando desnecessariamente depois de cheia.

## 16. TLP (gerenciamento de energia)

```bash
sudo pacman -S tlp
sudo mkdir -p /etc/tlp.d
sudo cp tlp/01-q464b.conf /etc/tlp.d/01-q464b.conf
sudo systemctl enable --now tlp
```

Esse arquivo só ajusta o que faz diferença real nesse hardware
específico (CPU sempre em modo economia — esse Atom não tem margem de
performance sobrando de qualquer jeito — Wi-Fi, USB e áudio em modo
econômico). O `/etc/tlp.conf` padrão que vem com o pacote já cobre o
resto de forma razoável, não precisa mexer nele.

Pra conferir se está rodando:
```bash
sudo tlp-stat -s
```

Se seu notebook tiver suporte a limite de carga da bateria (comum em
alguns modelos pra prolongar a vida útil), `tlp-stat -b` mostra isso —
me avisa se aparecer que a gente adiciona esse ajuste também.

## 17. Tema no login — lightdm-gtk-greeter

**Nota**: tentamos primeiro um tema pro SDDM (a pasta `sddm/` ainda
está no pacote, caso um dia você troque de display manager), mas seu
notebook na verdade usa **lightdm** — foi isso que causou a trava no
boot quando forçamos o SDDM a assumir. Ficamos com o lightdm mesmo,
que é mais simples de temear (GTK puro, não QML) e é o que já
funciona de verdade nesse notebook.

```bash
sudo mkdir -p /usr/share/lightdm-gtk-greeter/matrix-q464b
sudo cp lightdm/background.png /usr/share/lightdm-gtk-greeter/matrix-q464b/background.png

sudo mkdir -p /usr/share/themes/matrix-q464b-lightdm/gtk-3.0
sudo cp lightdm/matrix-q464b-lightdm/gtk-3.0/gtk.css /usr/share/themes/matrix-q464b-lightdm/gtk-3.0/gtk.css

sudo cp lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
```

**Atenção**: o último comando **sobrescreve** o
`lightdm-gtk-greeter.conf` inteiro. Se você já tinha personalizado
algo nele antes, faça um backup primeiro:
```bash
sudo cp /etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf.bak
```

Reinicia o lightdm pra aplicar — esse é seguro, diferente do sddm, já
sabemos que ele funciona nesse notebook:
```bash
sudo systemctl restart lightdm
```

Isso vai te desconectar da sessão gráfica atual (comportamento
esperado ao reiniciar o display manager) — salve qualquer coisa
aberta antes de rodar.

Como é CSS puro (não QML), o pior caso de um erro de sintaxe é o tema
simplesmente não aplicar e cair no visual padrão — não trava o boot
como aconteceu com o SDDM. Se quiser mexer nas cores, é só editar
`lightdm/matrix-q464b-lightdm/gtk-3.0/gtk.css` com qualquer editor de
texto antes de copiar.

## 18. Menu de energia / trocar de sessão

Já deixei o script em `i3/scripts/powermenu.sh` (junto com os outros,
copiado no mesmo passo do item 15 — `cp i3/scripts/*.sh
~/.config/i3/scripts/` já pega esse também, só confirme o `chmod +x`).

Atalho: `Super+Escape`. Abre um menu (rofi, mesmo tema) com:
- **Bloquear** — mesma coisa do `Super+Shift+X`
- **Encerrar sessão** — fecha o i3 e volta pra tela de login (lightdm).
  É esse que você quer pra trocar pro KDE Plasma **sem reiniciar o PC**:
  encerra, na tela de login escolhe "Plasma" no seletor de sessão do
  lightdm, loga de novo
- **Suspender** — economiza bateria sem desligar de vez
- **Reiniciar** / **Desligar**

Troquei o antigo atalho `Super+Shift+E` (que só confirmava sair do i3)
por esse menu completo — o `Super+Shift+E` não faz mais nada sozinho
agora, tudo passou pro `Super+Escape`.

## 19. Wifi e Bluetooth (menus rápidos)

```bash
yay -S networkmanager-dmenu bluetuith
mkdir -p ~/.config/networkmanager-dmenu
cp networkmanager-dmenu/config.ini ~/.config/networkmanager-dmenu/config.ini
```

`bluetuith` precisa do serviço do bluetooth ativo:
```bash
sudo systemctl enable --now bluetooth
```

Atalhos já no `i3/config`:
- `Super+N` → abre o menu de wifi (rofi, mesmo tema) — lista redes,
  clica pra conectar, pede senha se precisar. Mais rápido que abrir o
  `nmtui` toda vez
- `Super+Shift+B` → abre o `bluetuith` num terminal novo — navega com
  as setas, `p` pra parear, `c` pra conectar, `q` pra sair. Já herda
  as cores do tema automaticamente (não precisei configurar nada nele,
  ele só usa a paleta do terminal)

O `nmtui` continua funcionando normal também, caso prefira ele em
algum momento (útil por exemplo se estiver configurando algo mais
específico como uma rede eduroam com 802.1x).

**Indicador na polybar**: também adicionei um módulo mostrando o SSID
conectado (ou "wifi off") direto na barra, pra não precisar abrir o
menu só pra conferir se está conectado. **Precisa ajustar o nome da
interface** — o `polybar/config.ini` está com `interface = wlan0`, que
pode não ser o nome real da sua placa. Confirme com:
```bash
ip link
```
Procure por algo como `wlan0`, `wlp2s0`, `wlo1` — troque no
`polybar/config.ini` se for diferente, depois recarregue a polybar
(`~/.config/polybar/launch.sh`).

## 20. Backup no GitHub

**Antes de tudo, um ponto de segurança**: o `aichat/config.yaml` desse
pacote tem só o placeholder `SUA_CHAVE_AQUI` — sua chave de API real
fica apenas no `~/.config/aichat/config.yaml` do seu notebook, que é
uma cópia separada. Contanto que você suba **esta pasta** (a que
baixou de mim) pro GitHub, e não o `~/.config` inteiro, nenhuma chave
sua vai junto. Antes do primeiro `git push`, dá uma olhada rápida com
`grep -r "api_key" .` só pra confirmar que continua tudo como
placeholder.

```bash
cd dotfiles   # a pasta com tudo que já temos

git init
git add .
git commit -m "setup inicial - Motion Plus Q464B cyberpunk"
```

Cria um repositório novo no GitHub (vazio, sem README/gitignore
automático — você já tem os seus) e conecta:
```bash
git remote add origin git@github.com:Mont0303/dotfiles-q464b.git
git branch -M main
git push -u origin main
```

(troque `dotfiles-q464b` pelo nome que preferir dar ao repositório)

Se você usa HTTPS em vez de SSH pro GitHub, o `remote add` fica:
```bash
git remote add origin https://github.com/Mont0303/dotfiles-q464b.git
```

Daqui pra frente, sempre que mudar algo (novo atalho, cor diferente,
etc.), é só:
```bash
git add .
git commit -m "descrição da mudança"
git push
```

E se um dia formatar ou trocar de notebook, reinstalar tudo vira só:
```bash
git clone git@github.com:Mont0303/dotfiles-q464b.git
cd dotfiles-q464b
# segue o PREREQUISITOS.md e depois este README normalmente
```

## 21. Modo escuro em todo o sistema

Sem um ambiente de desktop completo (GNOME/KDE) rodando, o "modo
escuro automático" que apps e sites puxam não existe sozinho — dá pra
montar as duas peças que faltam manualmente:

```bash
sudo pacman -S gsettings-desktop-schemas dconf gnome-themes-extra qgnomeplatform-qt6
```

`gnome-themes-extra` garante que o `Adwaita-dark` (tema escuro) exista
no sistema. `qgnomeplatform-qt6` faz apps Qt (como o qutebrowser)
seguirem o tema do GTK em vez do padrão claro do Qt.

Define a preferência de modo escuro (fica salva, não precisa repetir):
```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
```

Copia o `.xprofile` (variáveis de ambiente lidas pelo lightdm antes de
abrir a sessão gráfica):
```bash
cp xprofile/.xprofile ~/.xprofile
```

Faça logout/login pra aplicar (variável de ambiente de sessão, não dá
pra recarregar só com `Super+Shift+C`).

**Sobre sites especificamente**: isso já está resolvido desde o passo
10 — o `qutebrowser/config.py` tem `c.colors.webpage.darkmode.enabled
= True`, que força modo escuro em qualquer site, mesmo sites sem dark
mode nativo, independente da configuração do sistema. Ou seja, no seu
navegador os sites já deveriam estar escuros — se ainda não estavam,
pode ser que esse arquivo não tenha sido copiado ainda ou precise
reabrir o qutebrowser.

**Se algum app específico continuar claro** mesmo depois disso, é
porque ele usa um mecanismo de tema próprio (nem todo app respeita
GTK/Qt) — nesse caso me fala qual app que a gente vê a configuração
específica dele.

## Próximos passos possíveis
- ~~Zathura (leitor de PDF) com tema combinando~~ ✅ feito
- ~~neofetch/fastfetch customizado no terminal ao abrir~~ ✅ feito
- ~~player de música (cmus) no tema~~ ✅ feito
- ~~navegador leve (qutebrowser) no tema~~ ✅ feito
- ~~IDE leve (Geany) no tema~~ ✅ feito
- ~~lockscreen com wallpaper (betterlockscreen)~~ ✅ feito
- ~~IA no terminal (aichat)~~ ✅ feito
- ~~prompt customizado (starship) + ajustes no Alacritty~~ ✅ feito
- ~~notificações (dunst)~~ ✅ feito
- ~~gerenciamento de energia (TLP)~~ ✅ feito
- ~~tema no login (lightdm-gtk-greeter)~~ ✅ feito
- ~~menu de energia / trocar de sessão~~ ✅ feito
- ~~wifi e bluetooth (menus rápidos)~~ ✅ feito
- ~~Git/backup dos dotfiles~~ ✅ feito
- ~~modo escuro em todo o sistema (GTK + Qt)~~ ✅ feito
- Skins/adesivos físicos
