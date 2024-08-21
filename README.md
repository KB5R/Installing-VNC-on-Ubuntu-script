# Установка VNC Serever для Linux

## Быстрый старт 
```bash
sudo apt update
sudo apt install git
git clone https://github.com/KB5R/VNC-Install-Script.sh
cd VNC-Install-Script.sh
sudo bash installvnc.sh
```
## После выполнения скрипта вам в терминал выведется следующие 
```
export DISPLAY=:0
gsettings set org.gnome.desktop.remote-desktop.vnc auth-method 'password'
gsettings set org.gnome.desktop.remote-desktop.vnc enable true
gsettings set org.gnome.desktop.remote-desktop.rdp enable true
gsettings set org.gnome.desktop.remote-desktop.vnc view-only false
systemctl --user enable gnome-remote-desktop.service
systemctl --user start gnome-remote-desktop.service
```
## Необходимо скопировать и вставить в терминал от домашнего пользователя, далее
```
sudo reboot
```
