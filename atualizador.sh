echo "Copiando arquivos..."

cp i3/config ~/.config/i3/config
cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp polybar/config.ini ~/.config/polybar/config.ini
cp polybar/launch.sh ~/.config/polybar/launch.sh
cp rofi/config.rasi ~/.config/rofi/config.rasi
cp wallpaper.png ~/.config/wallpaper.png

echo "Definindo permissões..."

chmod +x ~/.config/polybar/launch.sh

echo "✔ Instalação concluída!"