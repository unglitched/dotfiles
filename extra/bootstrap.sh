#!/bin/bash
#
# This is a setup script for my systems.
#
# TODO: OSX install tasks
# TODO: Custom git repos
# TODO: Better "custom app" management. Right now just dumping them into functions.


###  Variables  ###
dotfile_repo="https://www.github.com/qrbounty/dotfiles.git"
text_bar="~~~-----------------------------------------------------------~~~"

### Dependency Installation Variables ###
declare -a debian_packages=("git" "python3" "python3-pip" "vim" "i3" "xorg" "suckless-tools" "lightdm")
declare -a pip3_packages=("yara")

###  Functions  ###
# Usage: "if os darwin; then ..." or "if linux gnu; then ..."
# Purpose: Quick check for os-specific functionality.
# Source: Modified fromhttps://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script 
os () { [[ $OSTYPE == *$1* ]]; }
distro () { [[ $(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"') == *$1* ]]; }
linux () { 
  case "$OSTYPE" in
    *linux*|*hurd*|*msys*|*cygwin*|*sua*|*interix*) sys="gnu";;
    *bsd*|*darwin*) sys="bsd";;
  esac
  [[ "${sys}" == "$1" ]];
}

# Usage: "if exists <app>; then ..." or "if ! exists..."
# Purpose: A quick check to see if a program is installed. Not 100% reliable because it relies on $PATH
# Source: https://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
exists() { command -v "$1" >/dev/null 2>&1; }

# Usage: "try command 'Worked!'"
# Purpose: A more customizable variant of the claw "yell, die, try"
# Source: https://stackoverflow.com/questions/1378274/in-a-bash-script-how-can-i-exit-the-entire-script-if-a-certain-condition-occurs
fmt() { printf "\n$text_bar\n$(date +'%H:%M:%S'):"; }
err() { printf "$(fmt) $@\n" >&2; exit 1; }
yay() { printf "$@\n"; }
log() { printf "$(fmt) $@\n$text_bar\n"; }
try() { "$1" && yay "$2" || err "Failure at $1"; }

debian_install() { 
  echo "Updating system..."
  sudo apt-get update > /dev/null
  for package in "${debian_packages[@]}"; do
    echo "Installing $package ..."
    sudo apt-get install -y $package > /dev/null; 
  done
  echo "Setting i3 as default WM"
  echo "exec i3" > $HOME/.xsession
  update-alternatives --config x-session-manager
}

pip3_packages() { 
  for package in "${pip3_packages[@]}"; do
    echo "Installing $package"
    pip3 install $package; > /dev/null
  done 
}

config(){ /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@; }
dotfile_copy(){
  [ ! -d "$HOME/.cfg" ] && mkdir $HOME/.cfg
  git clone --bare $dotfile_repo $HOME/.cfg
  [ ! -d "$HOME/.config-backup"] && mkdir -p .config-backup
  config checkout
  if [ $? = 0 ]; then
    echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv $HOME/{} $HOME/.config-backup/{}
  fi;
  config checkout
  config config status.showUntrackedFiles no
}


###  Main  ###
log "Bootstrap Script Version Zero"

if os darwin; then
  log "Detected OS: Darwin"
  if ! exists brew; then
    log "Brew installed... This is where I'd install other programs, IF I HAD ANY!"
  else
    log "Installing Brew..."
  fi 
elif linux gnu; then
  if distro "Debian"; then
    log "Running Debian Install Scripts"
    try debian_install "Debian apps installed"
    log "Installing pip3 packages..."
    try pip3_packages "Custom python packages installed"
  fi
  if distro "Kali"; then
    log "Running Kali Install Scripts"
  fi
  if exists git; then
    log "Grabbing dotfiles. Conflicts will be saved to .config-backup"
    try dotfile_copy "Dotfile repo cloned."
  else
    err "git not detected, cannot gather dotfiles."
  fi
fi
