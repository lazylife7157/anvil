#!/bin/bash

if [ `whoami` != "root" ]
then
  log "This script must run with root privileges"
  exit 1
fi

log "Install util packages"
pacman -Sy
pacman -S --needed --noconfirm \
  docker \
  mcomix smplayer \
  libmad cmus
