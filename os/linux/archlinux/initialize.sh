#!bin/bash

# This script must run with sudo

# Update the system clock
timedatectl set-ntp true

# Time zone
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
hwclock --systohc

# Install packages
pacman -Sy
pacman -S --noconfirm \
  net-tools \
  cmake make \
  rust \
  libglvnd

if [ -n `lspci -k | grep VGA | grep NVIDIA` ]
then
  pacman -S --noconfirm libglvnd nvidia
fi

if [ -z `echo $PATH | grep '~/.cargo/bin'` ]
then
  echo 'export $PATH=$PATH:~/.cargo/bin' >> /etc/profile
fi

# Install way-cooler
pacman -S --noconfirm wayland wlc cargo cairo
cargo install way-cooler
cargo install way-cooler-bg

# Install gdm
pacman -S --noconfirm libglvnd gdm

# Install alacritty
pacman -S --noconfirm cmake freetype2 fontconfig pkg-config make xclip
mkdir ~/git
cd ~/git
git clone https://github.com/jwilm/alacritty alacritty
cd alacritty
cargo build --release && cargo install
