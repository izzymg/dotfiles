#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -l --color=auto'
alias vim='nvim'
export PS1='\[\e[35m\]\u\[\e[37m\]@\[\e[91m\]\h\[\e[37m\] \W : '
export EDITOR=vim
export XDG_CONFIG_HOME="/$HOME/.config"
export PATH="$PATH:$HOME/projects/go/bin"
export GOPATH="$HOME/projects/go"
