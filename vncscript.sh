#!/bin/bash

# Запрашиваем у пользователя значения
read -p "Введите VNC пароль: " vnc_password
read -p "Введите имя пользователя для ПК: " vnc_username



bash -c "cat <<EOF >/etc/gdm3/custom.conf
# GDM configuration storage
#
# See /usr/share/gdm/gdm.schemas for a list of available options.

[daemon]
# Uncomment the line below to force the login screen to use Xorg
#WaylandEnable=false

# Enabling automatic login
AutomaticLoginEnable = true
AutomaticLogin = $vnc_username

# Enabling timed login
TimedLoginEnable = true
TimedLogin = $vnc_username
TimedLoginDelay = 10

[security]

[xdmcp]

[chooser]

[debug]
# Uncomment the line below to turn on debugging
# More verbose logs
# Additionally lets the X server dump core if it crashes
#Enable=true
EOF"

# Создаем ключевую связку
bash -c "cat <<EOF >/home/$vnc_username/.local/share/keyrings/Связка_ключей_по_умолчанию.keyring
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
secret={'username': <'$vnc_username'>, 'password': <'$vnc_password'>}
mtime=1680778935
ctime=1676379245

[3:attribute0]
name=xdg:schema
type=string
value=org.gnome.RemoteDesktop.RdpCredentials
EOF"

# Создаем файл ключевой связки по умолчанию
bash -c "cat <<EOF >/home/$vnc_username/.local/share/keyrings/default
Связка_ключей_по_умолчанию
EOF"

export DISPLAY=:0 && gsettings set org.gnome.desktop.remote-desktop.vnc auth-method 'password' && gsettings set org.gnome.desktop.remote-desktop.vnc enable true && gsettings set org.gnome.desktop.remote-desktop.rdp enable true && gsettings set org.gnome.desktop.remote-desktop.vnc view-only false && systemctl --user enable gnome-remote-desktop.service && systemctl --user start gnome-remote-desktop.service && sudo apt-get install gnome-connections -y
