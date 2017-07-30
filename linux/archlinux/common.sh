#!/bin/bash

function log() {
  echo "[ Anvil ] $1"
}

if [ `whoami` != "root" ]
then
  log "This script must run with root privilege"
  exit 1
fi

if [ -n $1 ]
then
  $CURRENT_USER=$1
else
  $CURRENT_USER=`logname`
  log "Current user: $CURRENT_USER"
fi

function cudo() {
  su -c "$1" $CURRENT_USER
}

log "Update the system clock"
timedatectl set-ntp true

log "Time zone"
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
hwclock --systohc

log "Install packages"
pacman -Sy
pacman -S --needed --noconfirm \
  net-tools \
  gcc cmake make \
  rust \
  libglvnd

if [ -n `lspci -k | grep VGA | grep NVIDIA` ]
then
  log "Install NVIDIA driver"
  pacman -S --needed --noconfirm libglvnd nvidia
fi

if [ -z `echo $PATH | grep '~/.cargo/bin'` ]
then
  log "Add cargo binary directory to PATH environment variable"
  echo 'export PATH=$PATH:~/.cargo/bin' >> /etc/profile
  cudo "source /etc/profile"
fi
