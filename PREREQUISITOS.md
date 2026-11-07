# Pré-requisitos — Arch Linux do zero até aqui

Esse guia cobre tudo que precisa existir no sistema **antes** de seguir
o `README.md` principal (que só copia os arquivos de configuração).
Pensado pro Positivo Motion Plus Q464B (Atom x5-Z8350, 4GB RAM, 64GB
eMMC), mas serve de referência geral.

## 0. Instalação base do Arch

Se você ainda não tem o Arch instalado, o jeito mais tranquilo hoje em
dia é o instalador guiado oficial:

```bash
archinstall
```

Ele já cuida de partição, sistema de arquivos, usuário, timezone,
bootloader (GRUB) e rede básica. Durante o instalador:
- **Não** precisa escolher nenhum ambiente gráfico (Desktop
  Environment) — vamos montar tudo manualmente com i3, mais leve
- Marque a opção de instalar o `NetworkManager` se ela aparecer
- Crie um usuário normal com privilégio de `sudo` (não use só o root
  no dia a dia)

Se preferir instalação manual (mais controle, mais trabalho), siga o
guia oficial: https://wiki.archlinux.org/title/Installation_guide

Depois de instalar e reiniciar, logue com o usuário criado e confirme
que a internet funciona:
```bash
ping -c 3 archlinux.org
```
Se não funcionar (rede via Wi-Fi que ainda não foi configurada nessa
primeira vez), veja a seção "Conectando ao Wi-Fi pela primeira vez"
mais abaixo.

## 1. Base pra compilar pacotes da AUR (yay)

```bash
sudo pacman -Syu
sudo pacman -S --needed base-devel git
```

Instala o `yay` (gerenciador de pacotes da AUR — vários itens desse
setup, tipo `aichat` e `betterlockscreen`, só existem lá):
```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## 2. Servidor gráfico (Xorg)

O i3 roda sobre X11, não Wayland:
```bash
sudo pacman -S xorg-server xorg-xinit xorg-xrandr
```

## 3. Todos os pacotes oficiais (repositórios do Arch)

Essa lista junta tudo que o `README.md` pede ao longo dos passos —
rodando de uma vez só, já cobre o setup inteiro:

```bash
sudo pacman -S --needed \
    i3 alacritty polybar rofi feh picom brightnessctl i3lock \
    ttf-jetbrains-mono \
    lightdm lightdm-gtk-greeter \
    networkmanager \
    fastfetch \
    zathura zathura-pdf-mupdf \
    cmus ffmpeg \
    qutebrowser \
    libva-intel-driver libva-utils mesa mpv yt-dlp xclip \
    picocom nmap btop macchanger xdotool \
    geany \
    starship \
    dunst \
    batsignal \
    tlp \
    bluez bluez-utils \
    gsettings-desktop-schemas dconf gnome-themes-extra qgnomeplatform-qt6
```

## 4. Pacotes da AUR

```bash
yay -S --needed \
    betterlockscreen \
    aichat \
    networkmanager-dmenu \
    bluetuith
```

## 5. Habilitar os serviços que rodam em segundo plano

```bash
sudo systemctl enable --now NetworkManager
sudo systemctl enable lightdm
sudo systemctl enable --now bluetooth
sudo systemctl enable --now tlp
```

(o `lightdm` só ativa de verdade no próximo boot — não precisa dar
`--now` nele, e nem deve, pra não brigar com uma sessão gráfica já
rodando se você estiver instalando isso a partir de dentro de uma)

## 6. Conectando ao Wi-Fi pela primeira vez

Se o instalador não configurou o Wi-Fi ainda e você está sem cabo de
rede:
```bash
nmtui
```
"Activate a connection" → escolhe a rede → senha. Depois disso a
internet fica disponível pros passos anteriores (clonar o yay, instalar
pacotes, etc. — nessa ordem, se necessário, resolva o Wi-Fi antes do
resto).

## 7. Fonte com suporte a caracteres japoneses (opcional)

O wallpaper com a "chuva de código" foi gerado usando uma fonte com
katakana (`Noto Sans CJK`). Isso **não é necessário** pra usar o
wallpaper (ele já vem pronto como imagem `.png`, gerado uma vez só) —
só instale se um dia quiser gerar uma variação nova do wallpaper você
mesmo:
```bash
sudo pacman -S noto-fonts-cjk
```

## 8. Depois disso

Com tudo isso instalado e os serviços habilitados, segue o
`README.md` normalmente a partir do passo 2 (copiar os arquivos de
config) — o passo 1 dele (instalar pacotes) já foi coberto aqui de
forma mais completa.
