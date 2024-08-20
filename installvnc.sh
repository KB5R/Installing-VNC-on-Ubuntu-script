#!/bin/bash

# Запрашиваем у пользователя значения
read -p "Введите VNC пароль: " vnc_password
read -p "Введите имя пользователя для ПК: " vnc_username

# Создаем необходимые директории и устанавливаем права доступа
mkdir -p /home/$vnc_username/.local/share/keyrings
chown -R $vnc_username:$vnc_username /home/$vnc_username/.local/share/keyrings

# Настраиваем GDM
bash -c "cat <<EOF >/etc/gdm3/custom.conf
[daemon]
AutomaticLoginEnable = true
AutomaticLogin = $vnc_username
TimedLoginEnable = true
TimedLogin = $vnc_username
TimedLoginDelay = 1
EOF"

# Создаем ключевую связку
bash -c "cat <<EOF >/home/$vnc_username/.local/share/keyrings/Связка_ключей_по_умолчанию.keyring
[keyring]
display-name=Связка ключей по умолчанию
ctime=$(date +%s)
mtime=0
lock-on-idle=false
lock-after=false

[2]
item-type=0
display-name=GNOME Remote Desktop VNC password
secret=$vnc_password
mtime=$(date +%s)
ctime=$(date +%s)

[2:attribute0]
name=xdg:schema
type=string
value=org.gnome.RemoteDesktop.VncPassword

[3]
item-type=0
display-name=GNOME Remote Desktop RDP credentials
secret={'username': '$vnc_username', 'password': '$vnc_password'}
mtime=$(date +%s)
ctime=$(date +%s)

[3:attribute0]
name=xdg:schema
type=string
value=org.gnome.RemoteDesktop.RdpCredentials
EOF"

# Создаем файл ключевой связки по умолчанию
bash -c "cat <<EOF >/home/$vnc_username/.local/share/keyrings/default
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
