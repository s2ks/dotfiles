#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export XDG_CONFIG_HOME=$HOME/.config

# tmux on shell login
#[[ -z "$TMUX" ]] && exec tmux

# transparency
#[ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" > /dev/null

#powerline-daemon -q
#POWERLINE_BASH_CONTINUATION=1
#POWERLINE_BASH_SELECT=1

#. /usr/share/powerline/bindings/bash/powerline.sh

alias ls='ls --color=always'
alias la='ls -la'
alias grep='grep --color=always'
alias pacman='pacman --color=always'
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
source $HOME/.config/bash/prompt.sh

# Bash autocompletion extension
source /usr/share/bash-completion/bash_completion

# command not found, file lookup
source /usr/share/doc/pkgfile/command-not-found.bash

# perl stuff
PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;
