#!/bin/bash

if [ `whoami` != "root" ]
then
  log "This script must run with root privileges"
  exit 1
fi

log "Install GUI packages"
pacman -Sy
pacman -S --needed --noconfirm \
  libx264 \
  gdm gnome-session gnome-shell gnome-shell-extensions \
  gnome-system-monitor gnome-control-center gnome-disk-utility \
  gnome-backgrounds gnome-font-viewer gnome-screenshot \
  gnome-terminal \
  nautilus \
  chromium

if [ `systemctl is-enabled gdm` == 'disabled' ]
then
  log "Enable GDM"
  systemctl enable gdm
fi

# log "Install gnome-terminal-transparancy"
# aur https://aur.archlinux.org/gnome-terminal-transparency.git gnome-terminal-transparency
