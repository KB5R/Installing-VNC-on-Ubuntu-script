#!/bin/bash

# Запрашиваем у пользователя значения
read -p "Введите VNC пароль: " vnc_password
read -p "Введите имя пользователя для RDP: " rdp_username
read -p "Введите пароль для RDP: " rdp_password

# Создаем ключевую связку
bash -c "cat <<EOF >/home/$USER/.local/share/keyrings/Связка_ключей_по_умолчанию.keyring
[keyring]
display-name=Связка ключей по умолчанию
ctime=1676379301
mtime=0
lock-on-idle=false
lock-after=false

[2]
item-type=0
display-name=GNOME Remote Desktop VNC password
secret=$vnc_password
mtime=1680778935
ctime=1676379244

[2:attribute0]
name=xdg:schema
type=string
value=org.gnome.RemoteDesktop.VncPassword

[3]
item-type=0
display-name=GNOME Remote Desktop RDP credentials
secret={'username': <'$rdp_username'>, 'password': <'$rdp_password'>}
mtime=1680778935
ctime=1676379245

[3:attribute0]
name=xdg:schema
type=string
value=org.gnome.RemoteDesktop.RdpCredentials
EOF"

# Создаем файл ключевой связки по умолчанию
bash -c "cat <<EOF >/home/$USER/.local/share/keyrings/default
Связка_ключей_по_умолчанию
EOF"

echo "Скопируйте и вставьте это в терминал"
echo "export DISPLAY=:0"
echo "gsettings set org.gnome.desktop.remote-desktop.vnc auth-method 'password'"
echo "gsettings set org.gnome.desktop.remote-desktop.vnc enable true"
echo "gsettings set org.gnome.desktop.remote-desktop.rdp enable true"
echo "gsettings set org.gnome.desktop.remote-desktop.vnc view-only false"
echo "systemctl --user enable gnome-remote-desktop.service"
echo "systemctl --user start gnome-remote-desktop.service"
