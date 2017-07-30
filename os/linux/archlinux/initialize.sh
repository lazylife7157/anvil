#!/bin/bash

function log() {
  echo "[ Anvil ] $1"
}

if [ `whoami` != "root" ]
then
  log "This script must run with root privilege"
  exit 1
fi

CURRENT_USER=`logname`
log "Run by $CURRENT_USER"

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

log "Install way-cooler"
pacman -S --needed --noconfirm wayland wlc cargo cairo
cudo "cargo install way-cooler"

log "Install way-cooler-bg"
cudo "cargo install way-cooler-bg"

# log "Install gdm"
# pacman -S --needed --noconfirm libglvnd gdm

log "Install alacritty"
pacman -S --needed --noconfirm cmake freetype2 fontconfig pkg-config make xclip
DIR_GIT=/home/$CURRENT_USER/git
if [ ! -d $DIR_GIT ]
then
  mkdir $DIR_GIT
fi
cudo "git clone https://github.com/jwilm/alacritty ~/git/alacritty"
cudo "cd ~/git/alacritty && cargo build --release && cargo install"
