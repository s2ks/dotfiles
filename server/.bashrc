#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=always'
alias la='ls -la'
alias grep='grep --color=always'
alias diff='diff --color=always'

alias mv='mv -i'
alias rm='rm -I'
alias cp='cp -i'

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
export EDITOR=vim

# Custom bash prompt
# TODO only source this promt if running a graphical terminal:
# st, xterm, etc.
source $HOME/.config/bash/prompt.sh
