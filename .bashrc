#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export XDG_CONFIG_HOME=$HOME/.config

alias ls='ls --color=always'
alias la='ls -la'
alias grep='grep --color=always'
alias pacman='pacman --color=always'
alias diff='diff --color=always'

alias mv='mv -i'
alias rm='rm -I'
alias cp='cp -i'

# Alias for neovim because I keep typing 'vim' out of habit
# Use 'realvim' to start the actual vim instead of neovim
alias vim='nvim'
alias realvim="`which vim`"

# allow minor spelling mistakes in arguments to 'cd'
shopt -s cdspell
shopt -s nocaseglob
shopt -s autocd

# prevent shell output from overwriting files
# use >| to force
set -o noclobber

# coloured output for 'less'
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'	# begin bold
export LESS_TERMCAP_md=$'\E[1;36m'	# begin blink
export LESS_TERMCAP_me=$'\E[0m'		# reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m'	# begin reverse video
export LESS_TERMCAP_se=$'\E[0m'		# reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'	# begin underline
export LESS_TERMCAP_ue=$'\E[0m'		# reset underline

# don't log duplicants
export HISTCONTROL=ignoredups

# for pager used by man
export PAGER=less

# default editor
export EDITOR=nvim

# Custom bash prompt
# TODO only source this promt if running a graphical terminal:
# st, xterm, etc.
source $HOME/.config/bash/prompt.sh

# Bash autocompletion extension
source /usr/share/bash-completion/bash_completion

# command not found, file lookup
source /usr/share/doc/pkgfile/command-not-found.bash
