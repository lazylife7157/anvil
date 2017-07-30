#!/bin/bash

if [ `whoami` != "root" ]
then
  log "This script must run with root privileges"
  exit 1
fi

log "Install way-cooler"
pacman -S --needed --noconfirm wayland wlc cargo cairo
cudo "cargo install way-cooler"

log "Install way-cooler-bg"
cudo "cargo install way-cooler-bg"

log "Install alacritty"
pacman -S --needed --noconfirm cmake freetype2 fontconfig pkg-config make xclip
cudo "mkdir -p ~/git"
cudo "git clone https://github.com/jwilm/alacritty ~/git/alacritty"
cudo "cd ~/git/alacritty && \
      cargo build --release && \
      cargo install"
