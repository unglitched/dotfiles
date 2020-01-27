b=$(tput bold)
nm=$(tput sgr0)
echo "
Don't forget:
  ${b}conf-*${nm}    commands are shortcuts to edit your dotfiles.
  ${b}config${nm}    is a git alias for the dotfiles repo

Useful Apps:
  ${b}Terminal${nm}
    ${b}tldr${nm}    shorter manpages, with examples
    ${b}ripgrep${nm} grep, but way faster
    ${b}ranger${nm}  file browser

  ${b}Reverse Engineering${nm}
    ${b}radare2${nm}  A nice and modern debugger
    ${b}gdb${nm}      the GNU debugger
    ${b}binwalk${nm}  binary analysis and extraction tool
"
