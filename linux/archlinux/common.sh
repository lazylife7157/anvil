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
  net-tools wget openssh \
  ntfs-3g \
  libglvnd \
  patch fakeroot binutils pkg-config \
  gcc cmake make python

if [ -n `lspci -k | grep VGA | grep -o NVIDIA` ]
then
  log "Install NVIDIA driver"
  pacman -S --needed --noconfirm libglvnd nvidia
fi

log "Install fonts"
TMP_FONTS="/tmp/fonts"
wget -P $TMP_FONTS https://github.com/naver/d2codingfont/releases/download/VER1.21/D2Coding-1.2.zip
wget -P $TMP_FONTS http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip
unzip $TMP_FONTS/D2Coding-1.2.zip -d $TMP_FONTS
unzip $TMP_FONTS/NanumFont_TTF_ALL.zip -d $TMP_FONTS
chmod -x $TMP_FONTS/*.ttf
cp $TMP_FONTS/*.ttf /usr/share/fonts/TTF/
rm -rf $TMP_FONTS
