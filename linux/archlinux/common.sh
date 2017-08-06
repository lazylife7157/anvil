#!/bin/bash

if [ `whoami` != "root" ]
then
  log "This script must run with root privileges"
  exit 1
fi

log "Update the system clock"
timedatectl set-ntp true

log "Time zone"
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
hwclock --systohc

log "Install common packages"
pacman -Sy
pacman -S --needed --noconfirm \
  net-tools \
  libglvnd \
  patch fakeroot binutils pkg-config

if [ -n `lspci -k | grep VGA | grep -o NVIDIA` ]
then
  log "Install NVIDIA driver"
  pacman -S --needed --noconfirm libglvnd nvidia
fi
