#!/bin/bash

# NOTE '\[' and '\]' are used so bash can calculate the number of printed
# characters so that the prompt doesn't jump around or disappears when
# entering/editing a command.

ARROW_RIGHT=""
ARROW_RIGHT_SEP=""
GIT_BRANCH_ICON=""
RANGER_ICON=" "

ESC="\e"
BOLD="1"

WHITE="5;255"
RED="5;124"

USER_BG="5;140"
USER_FG="5;232"
CWD_BG="5;240"
CWD_FG="5;255"
CWD_MAX_LEN=3
#CWD_PATH_SEP="/"
CWD_PATH_SEP=" $ARROW_RIGHT_SEP "

LAST_EXITCODE=

FG() {
	echo "38;$1"
}

BG() {
	echo "48;$1"
}

prompt_exitstatus() {
	local fg=$1
	local bg=$2
	local res=""
	if [[ -n $LAST_EXITCODE ]]; then
		if [[ $LAST_EXITCODE -ne 0 ]]; then
			res="\[$ESC[0;$(FG $fg);$(BG $bg);${BOLD}m\] $LAST_EXITCODE"
		else
			res=""
		fi
	else
		res=""
	fi

	echo $res
}

# display a prompt if the shell was started by ranger
prompt_ranger() {
	local fg=$1
	local bg=$2

	if [[ -n $RANGER_LEVEL ]]; then
		echo "\[$ESC[0;$(FG $fg);$(BG $bg);${BOLD}m\] $RANGER_ICON"
	else
		echo ""
	fi
}

# Show the current branch, and if there are uncommitted/untracked files
prompt_git() {
	local fg=$1
	local bg=$2

	# For me while testing, the following command completes in about 4 ms
	# if there is no git repository and about 6 ms if there is a git repository.
	# The "official" git prompt uses `git rev-parse` to check for a git repository
	# and collect some additional information about it, which also completes in about
	# 4 ms, whether it's in a git repo or not. I am not interested in the additional
	# info rev-parse provides. Hence the usage of `git describe` to check for the
	# existance of a git repo while also finding out the current branch name.
	local branch="$(git describe --contains --all HEAD 2>/dev/null)"
	if [[ -z $branch ]]; then
		echo ""
		return
	fi

	local prompt="\[$ESC[0;$(FG $fg);$(BG $bg);${BOLD}m\] $GIT_BRANCH_ICON $branch"

	local untracked="$(git ls-files --others --exclude-standard 2>/dev/null)"
	local uncomitted"$(git diff --no-ext-diff --quiet; echo $?)"

	if [[ -n $untracked || $uncomitted -eq 1 ]]; then
		prompt+="*"
	fi

	echo "$prompt"
}

prompt_cwd() {
	local fg=$1
	local bg=$2
	local cwd=$PWD
	local hlen=${#HOME} # len of $HOME

	# substitute $HOME for ~
	if [[ ${PWD:0:hlen} == $HOME ]]; then
		cwd="~${cwd:hlen}"
	fi

	# split the path at the directory seperator
	local cwd=${cwd////' '}
	read -a elems <<< $cwd

	# exscuse the mess, this is supposed to shorten the path displayed
	# in the prompt similar to how powerline does.
	# CWD_MAX_LEN defines the maximum depth to display, the root directory
	# should always be displayed. $HOME should be substituted for '~' and
	# displayed as the 'root' directory.
	local len=${#elems[@]}
	local idx=$(($len - $CWD_MAX_LEN))

	cwd="\[$ESC[0;$(BG $bg);$(FG $fg)m\]"

	if [[ $len -gt 1 ]]; then
		cwd+=" ${elems[0]}$CWD_PATH_SEP"
		len=$(($len - 1)) # element 0 has been printed
	else
		cwd+="\[$ESC[${BOLD}m\] ${elems[0]}"
		echo "$cwd"
		return
	fi

	# Show the final n directories with n being CWD_MAX_LEN - 1
	if [[ $idx -gt 0 ]]; then
		cwd+="...$CWD_PATH_SEP"

		# remember, element 0 has already been printed, so don't print
		# full CWD_MAX_LEN
		len=$(($CWD_MAX_LEN - 1))
	else
		# normalise idx if it's less than 0
		idx=0
	fi

	# we don't want to print elems[0] so increment idx by 1
	idx=$(($idx + 1))

	# the final element to print should have a special arrow character
	# so we need to make sure it is not printed by the following loop
	count=$(($len - 1))

	for i in "${elems[@]:idx:count}"; do
		cwd+="${i}$CWD_PATH_SEP"
	done

	# finally, handle the last element in our CWD
	cwd+="\[$ESC[${BOLD}m\]${elems[-1]}"

	echo $cwd
}

prompt_user() {
	local fg=$1 # foreground colour
	local bg=$2 # background colour

	echo "\[$ESC[0;$(FG $fg);$(BG $bg);${BOLD}m\] $USER"
}

set_PS1() {
	# save the last exit code ASAP because it will be overwritten in this script
	LAST_EXITCODE=$?
	local prompt=""
	local prompt_calls=()
	prompt_calls+=("prompt_ranger 5;232 5;131")
	prompt_calls+=("prompt_user $USER_FG $USER_BG")
	prompt_calls+=("prompt_exitstatus $WHITE $RED")
	prompt_calls+=("prompt_cwd $CWD_FG $CWD_BG")
	prompt_calls+=("prompt_git 5;232 5;113")

	local last_bg

	for i in ${!prompt_calls[@]}; do
		read -a params <<< ${prompt_calls[$i]}
		local res=$(${prompt_calls[$i]})
		local next_bg=${params[2]}

		if [[ -n $last_bg && -n $res ]]; then
			prompt+="\[$ESC[0;$(FG $last_bg);$(BG $next_bg)m\]$ARROW_RIGHT"
		fi

		if [[ -n $res ]]; then
			prompt+="$res "
			last_bg=$next_bg
		fi
	done

	prompt+="\[$ESC[0;$(FG $last_bg)m\]$ARROW_RIGHT\[$ESC[0m\]"
	PS1="$prompt "
}

PROMPT_COMMAND=set_PS1
