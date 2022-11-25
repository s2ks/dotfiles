#!/bin/bash

# NOTE '\[' and '\]' are used so bash can correctly calculate the number of printed
# characters, otherwise the prompt might jump around and/or disappear when
# editing/entering a command

# TODO rewrite in perl (or python or common lisp or awk?!?!)

ARROW_RIGHT=""
ARROW_RIGHT_SEP=""
GIT_BRANCH_ICON=""
RANGER_ICON=""
THREE_DOTS="…"

ESC="\e"
BOLD="1"

WHITE="5;255"
RED="5;124"

USER_BG="5;140"
USER_FG="5;232"
CWD_BG="5;240"
CWD_FG="5;255"
CWD_PATH_SEP=" $ARROW_RIGHT_SEP "

LAST_EXITCODE=

PROMPT_DEBUG=0

debug() {
         [[ $PROMPT_DEBUG -ne 0 ]] && echo "$*" 1>&2
}

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
	#local branch="$(git describe --contains --all HEAD 2>/dev/null)"


	local branch="$(git branch --show-current 2>/dev/null)"
	if [[ -z $branch ]]; then
		echo ""
		return
	fi

	local prompt="\[$ESC[0;$(FG $fg);$(BG $bg);${BOLD}m\] $GIT_BRANCH_ICON $branch"

	local untracked="$(git ls-files --others --exclude-standard 2>/dev/null)"
	local uncomitted="$(git diff --no-ext-diff --quiet; echo $?)"

	if [[ -n $untracked || $uncomitted -ne 0 ]]; then
		prompt+="*"
	fi

	echo "$prompt"
}

PROMPT_CWD_MAX_START=2
PROMPT_CWD_MAX_END=2

prompt_cwd() {
	local fg=$1
	local bg=$2
	local cwd="$PWD"

        # regex literal slash for readability hopefully
        # NOTE sometimes the forward slash '/' has to be escaped
        # and sometimes it doesn't, so the $SLASH variable and the literal
        # '/' are used intermittently. Sorry!
        local SLASH='\/'
        # empty character for regex readability hopefully
        local EMPTY=''


        # substitute '~' for $HOME
        # NOTE: could also be done with sed
        # >>> sed -E "s/^($HOME)/~/g" <<< $cwd
	if [[ ${cwd:0:${#HOME}} == "$HOME" ]]; then
		cwd="~${cwd:${#HOME}}"
	fi

        # Escape backslashes.
        # Alternatively use `printf %q "$cwd"`.
        # This would output a string that is safe to use as shell input by
        # escaping backslashes, as well as a few other characters (like
        # spaces) which may not be desirable.
        cwd=$(sed -E 's/\\/\\\\/g' <<< "$cwd")
        #cwd=`printf %q "$cwd"`

	local m1=$PROMPT_CWD_MAX_START
	local m2=$PROMPT_CWD_MAX_END
        # At start of line (^) match 0 or 1 (?) forward slash, 0 or more (*) non forward
        # slashes [^/] and 0 or 1 (?) forward slash -> at least once and at most $m1 times
        # {1,$m1}
        # FIXME this always results in a match, even if empty
        # a better regex would be something like ^(/?[^/]+/?){1,$m1}|^\/
        local regex_part1="^($SLASH?[^/]*$SLASH?){1,$m1}"

        # At end of line ($) match 0 or 1 (?) forward slash at least one (+)
        # non-forward slash [^/] and 0 or 1 (?) forward slash ->
        # at least once and at most $m2 times {1, $m2}
        local regex_part2="($SLASH?[^/]+$SLASH?){1,$m2}$"

	# group all repeating forward slashes and replace them with a single
        # forward slash
	cwd=$(sed -E "s/$SLASH+/$SLASH/g" <<< $cwd)

        local part1=`grep --color=never -P -o "$regex_part1" <<< $cwd`
        cwd=`sed -E "s/$regex_part1/$EMPTY/g" <<< $cwd`

        local part2=`grep --color=never -P -o "$regex_part2" <<< $cwd`
        cwd=`sed -E "s/$regex_part2/$EMPTY/g" <<< $cwd`

        # If cwd is not empty then we need to shorten it, to display
        # that it has been shortened we place a character showing three
        # dots between part1 and part2 of the path
        if [[ -n $cwd ]]; then
                cwd=$part1$THREE_DOTS$part2
        else
                cwd=$part1$part2
        fi

        # Get last element, this element will be made bold to give
        # a highlighting effect.
        # We do it in this order because there may only be one element
        # so we need to prevent duplicate elements.

        # SYNTAX NOTE FOR FUTURE ME: the '^' character inside the '[' and ']'
        # characters means NOT, so [^/] means match any character that's not a '/'.
        # But outside '[]' it means start of line so ^/ means match a '/'
        # character at the start of a line.
        # '*' means match 0 or more, '$' means end of line, '+' means 1 or more
        # and '|' means OR/alternatively.

        # Match at least one non '/' character and 0 or more '/' characters
        # at end of line
        local last_elem_regex="[^/]+$SLASH*$"
        # Match 0 or more '/' characters and at least one non '/' character
        # at start of line alternatively match 1 or more '/' characters at start of line
        # (for when we navigate to / (root) display '/')
        local first_elem_regex="^$SLASH*[^/]+|^$SLASH+"
        local last_elem=`grep --color=never -o -P "$last_elem_regex" <<< $cwd`
        # remove last element
        cwd=`sed -E "s/$last_elem_regex/$EMPTY/g" <<< $cwd`

        # get first element
        local first_elem=`grep --color=never -o -P "$first_elem_regex" <<< $cwd`
        # and remove
        cwd=`sed -E "s/$first_elem_regex/$EMPTY/g" <<< $cwd`

        # Replace the remaining slashes with our own fancy path separator
        cwd=`sed -E "s/$SLASH+/$CWD_PATH_SEP/g" <<< $cwd`

	# make the last element bold
	local bold_elem=$last_elem

        local cwd_remain=$cwd
	cwd="\[$ESC[0;$(FG $fg);$(BG $bg)m\] "
        cwd+="$first_elem"
        cwd+="$cwd_remain"

	cwd+="\[$ESC[${BOLD}m\]$bold_elem"

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
