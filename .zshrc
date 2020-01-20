# TODO: Migrate this to .config/oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
export EDITOR=vim

ZSH_THEME="agnoster"

plugins=(git)

source $HOME/.config/shell/functions
source $HOME/.config/shell/aliases
source $ZSH/oh-my-zsh.sh
