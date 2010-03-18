# 
# This file is based on the configuration written by
# Bruno Bonfils, <asyd@debian-fr.org> 
# Written since summer 2001

#
# My functions (don't forget to modify fpath before call compinit !!)
fpath=($HOME/.zsh/functions $fpath)

# colors
eval `dircolors $HOME/.zsh/colors`

autoload -U zutil
autoload -U compinit
autoload -U complist

bindkey "\e[3~" delete-char # Delete
bindkey "\e[2~" overwrite-mode # Insert
bindkey "\e[4~" end-of-line # End
bindkey "\e[1~" beginning-of-line # Home

# Activation
compinit

# Resource files
for file in $HOME/.zsh/rc/*.rc; do
	source $file
done
