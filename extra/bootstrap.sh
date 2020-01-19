#!/bin/bash
#
# This is a setup script for my systems.
#
# TODO: OSX install tasks
# TODO: Custom git repos
# TODO: Convert for sudo usage instead of having sudo commands within. See $SUDO_USER
# TODO: Add dry run functionality
# TODO: Force Debian front-end to be reset to xdm
# TODO: Better "custom app" management. Right now just dumping them into functions.

set -e
dotfile_repo="https://www.github.com/qrbounty/dotfiles.git"


### Helpers / Formatters ###
# Print a horizontal rule
# Source: https://brettterpstra.com/2015/02/20/shell-trick-printf-rules/
rule () { printf -v _hr "%*s" $(tput cols) && echo ${_hr// /${1--}}; }
# Print a rule with a message in it
rulem ()  {
  if [ $# -eq 0 ]; then
    echo "Usage: rulem MESSAGE [RULE_CHARACTER]"
  return 1
  fi
  # Fill line with ruler character ($2, default "-"), reset cursor, move 2 cols right, print message
  printf -v _hr "%*s" $(tput cols) && echo -en ${_hr// /${2--}} && echo -e "\r\033[2C$1"
}

# Source: Modified from https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script 
os () { [[ $OSTYPE == *$1* ]]; }
distro () { [[ $(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"') == *$1* ]]; }
linux () { 
  case "$OSTYPE" in
    *linux*|*hurd*|*msys*|*cygwin*|*sua*|*interix*) sys="gnu";;
    *bsd*|*darwin*) sys="bsd";;
  esac
  [[ "${sys}" == "$1" ]];
}

# Source: https://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
exists() { command -v "$1" >/dev/null 2>&1; }

# Source: https://stackoverflow.com/questions/1378274/in-a-bash-script-how-can-i-exit-the-entire-script-if-a-certain-condition-occurs
error() { printf "$@\n" >&2; exit 1; }
success() { printf "$@\n\n"; }
log() { rulem "$@\n" " "; }
try() { log "$1" && "$2" && success "$3" || error "Failure at $1"; }

# Usage: "apt_install vim"
apt_install() {
  printf "Installing package $1 ----- " 
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq $1 < /dev/null > /dev/null && echo "Installed!"
}

### Installer Functions ###

debian_install() { 
  sudo apt-get update < /dev/null > /dev/null && echo "Packages updated"
  declare -a debian_packages=("curl" "git" "python3" "python3-pip" "vim" "suckless-tools" "i3" "xorg" "xdm")
  for package in "${debian_packages[@]}"; do
    apt_install $package
  done
  sudo dpkg-reconfigure xdm
  echo 'exec i3' > ~/.xsession
  
  # VS Code install
  rulem "Installing VS Code"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  apt_install apt-transport-https
  sudo apt-get update < /dev/null > /dev/null && echo "Packages updated"
  apt_install code
}

pip3_packages() { 
  declare -a pip3_packages=("yara")
  for package in "${pip3_packages[@]}"; do
    echo "Installing $package -----"
    pip3 -q install $package; < /dev/null > /dev/null && echo "Installed!"
  done 
}

### Dotfile Stuff ###
config(){ /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@; }
dotfile_copy(){
  [ ! -d "$HOME/.cfg" ] && mkdir $HOME/.cfg
  git clone --bare $dotfile_repo $HOME/.cfg
  [ ! -d "$HOME/.config-backup" ] && mkdir -p .config-backup
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
rule "-"
printf "Bootstrap Script Version Zero\n"
rule "-"
printf "\n"

if os darwin; then
  if ! exists brew; then
    log "Brew installed... This is where I would install other programs, IF I HAD ANY!"
  else
    log "Installing Brew..."
  fi 
elif linux gnu; then
  if distro "Debian"; then
    rulem "Debian Customization" "~"
    try "Installing Debian environment..." debian_install "Debian environment set up!"
    try "Installing pip3 packages..." pip3_packages "Custom python packages installed!"
  fi
  if distro "Kali"; then
    rulem "Kali Customization" "~"
  fi
  if exists git; then
    rulem "Dotfile Installation" "~"
    try "Grabbing dotfiles. Conflicts will be saved to .config-backup..." dotfile_copy "Dotfile repo cloned"
  else
    err "git not detected, cannot gather dotfiles."
  fi
fi
