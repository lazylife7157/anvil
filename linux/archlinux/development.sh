#!/bin/bash

if [ `whoami` != "root" ]
then
  log "This script must run with root privileges"
  exit 1
fi

log "Install dev packages"
pacman -Sy
pacman -S --needed --noconfirm \
  gcc cmake make \
  jdk8-openjdk scala sbt \
  rust cargo \
  ghc \
  python \
  julia

if [ -z `echo $PATH | grep '.cargo/bin'` ]
then
  log "Add cargo binary directory to PATH environment variable"
  echo 'export PATH=$PATH:~/.cargo/bin' >> /etc/profile
  cudo "source /etc/profile"
fi

if [ ! -d "`cuhome`/.bash-git-prompt" ]
then
  log "Install bash-git-prompt"
  cudo "git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1"
  cudo "echo 'GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bashrc"
  cudo "echo 'source ~/.bash-git-prompt/gitprompt.sh' >> ~/.bashrc"
fi

aur https://aur.archlinux.org/git-cola.git git-cola
