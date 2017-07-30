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

log "Install way-cooler"
pacman -S --needed --noconfirm wayland wlc cargo cairo
cudo "cargo install way-cooler"

log "Install way-cooler-bg"
cudo "cargo install way-cooler-bg"

log "Install alacritty"
pacman -S --needed --noconfirm cmake freetype2 fontconfig pkg-config make xclip
DIR_GIT=/home/$CURRENT_USER/git
if [ ! -d $DIR_GIT ]
then
  mkdir $DIR_GIT
fi
cudo "git clone https://github.com/jwilm/alacritty ~/git/alacritty"
cudo "cd ~/git/alacritty && cargo build --release && cargo install"

./install-way-cooler.sh $CURRENT_USER
