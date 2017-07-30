#!/bin/bash

if [ `whoami` != "root" ]
then
  log "This script must run with root privileges"
  exit 1
fi

pacman -S --needed --noconfirm \
  libx264 \
  gdm gnome-session gnome-shell gnome-shell-extensions \
  gnome-system-monitor gnome-control-center gnome-disk-utility \
  gnome-backgrounds gnome-font-viewer gnome-screenshot\
  nautilus networkmanager \
  chromium atom

aur https://aur.archlinux.org/gnome-terminal-transparency.git gnome-terminal-transparency
