#!/bin/bash

USER="s1ks"
CLIENTID="Client-Id: kdsw4p8qqmlnwd7xi3ve1ri0ygi0ys"
ACCEPT="Accept: application/vnd.twitchtv.v5+json"
LIMIT=50
MAX_LIST=50
#AUTH="Authorization: Bearer 7q9g5sta2inoasha75azozx5lb0e4c"

# kraken api wrapper
# $1 -> command
# $2, $3, ... -> parameters
kraken_get() {
	[ -z $1 ] && return 1
	local req="https://api.twitch.tv/kraken/$1"

	shift
	if [[ $# -gt 0 ]]; then
		req+="?$1"
	fi
	shift

	while [[ $# -gt 0 ]]; do
		req+="&$1"
		shift
	done

	echo "$req" 1>&2
	local response=$(curl -X GET "$req" -H "$CLIENTID" -H "$ACCEPT")

	[ -z "$response" ] && return 1
	echo "$response"
}

open_rofi() {
	coproc rofi { rofi -dmenu -async-pre-read 0 -theme twitch -format i:f ; }
	trap "kill $rofi_PID" EXIT

	rofi_in="${rofi[1]}"
	rofi_out="${rofi[0]}"
}

close_rofi() {
	kill $rofi_PID
	rofi_in=
	rofi_out=
}

get_rofi_selection() {
	[ -z "$rofi_out" ] && return 1

	IFS=':' read -a select <& $rofi_out

	rofi_selection="${select[0]}"
	rofi_query="${select[1]}"
}

open_stream() {
	local url=$1
	local title=$2
	[ -z "$url" ] && return 1

	coproc streamlink \
		{ streamlink --twitch-low-latency --twitch-disable-ads --stdout \
			$url 'best' ; }
	trap "kill $streamlink_PID" EXIT

	vlc --meta-title "$title" --qt-minimal-view - <&"${streamlink[0]}"
}

open_chat() {
	local channel=$1
	[ -z "$channel" ] && return 1

	local tmpfile=$(mktemp)
	trap "rm $tmpfile" EXIT

	local url="https://www.twitch.tv/popout/$channel/chat"
	echo "<script type=\"text/javascript\">
	function chatPopout(url) {
		window.open(url, '', 'menubar=off,toolbar=off,status=off');
	}
	</script>
	<a href=$url onclick=\"chatPopout(this.href); window.close();\">Popout chat</a>" \
		> $tmpfile

	#coproc chat { chromium --app=$url ; }
	coproc chat { firefox --new-window $tmpfile ; }
	trap "kill $chat_PID" EXIT
}

get_userid() {
	[ -z "$1" ] && return 1
	local username=$1
	local userinfo=$(kraken_get "users" "login=$username")

	[ -z "$userinfo" ] && return 1

	local userid=$(jq --raw-output '.users[]._id' <<< $userinfo)

	[ -z "$userid" ] && return 1
	[ "$userid" == "null" ] && return 1

	echo "$userid"
}

get_user_follows() {
	local userid=$1
	local limit=$2
	local offset=$3

	[ -z "$userid" ] && return 1
	[ -z "$limit" ] && limit=25
	[ -z "$offset" ] && offset=0

	local followinfo=$(kraken_get "users/$userid/follows/channels" \
		"sortby=last_broadcast" "limit=$limit" "offset=$offset")


	local channelids=$(jq '.follows[].channel._id' <<< "$followinfo")

	channelids=$(tr '\n' ',' <<< $channelids)
	channelids=${channelids//\"/}
	channelids=${channelids:0:-1}

	echo "$channelids"
}

# $1 -> list of comma-seperated twitch user/channel ids
get_live_streams() {
	local channelids=$1
	local limit=$2
	local offset=$3
	[ -z "$channelids" ] && return 1
	[ -z "$limit" ] && limit=25
	[ -z "$offset" ] && offset=0

	local streams=$(kraken_get "streams" "channel=$channelids" "limit=$limit" \
		"offset=$offset")

	[ -z "$streams" ] && return 1

	echo "$streams"
}

get_live_streams_for_user() {
	local user=$1
	[ -z "$user" ] && return 1

	local userid=$(get_userid "$user")
	[ -z "$userid" ] && return 1

	for ((i=0; i < $MAX_LIST; i=i+$LIMIT)); do
		local channelids=$(get_user_follows "$userid" "$LIMIT" "$i")
		[ -z "$channelids" ] && return 1

		local live_streams=$(get_live_streams "$channelids" "$LIMIT" "$i")
		[ -z "$live_streams" ] && return 1

		 echo "$live_streams"
	done
}

search_for_live_streams() {
	local query=$1
	[ -z "$query" ] && return 1

	local live_streams=$(kraken_get "search/streams" "query=$query" "limit=$LIMIT")
	[ -z "$live_streams" ] && return 1

	echo "$live_streams"
}

get_from_rofi_selection() {
	local streamdata=$live_streams
	local selection=$rofi_selection
	local field=$1

	[ -z "$streamdata" ] && return 1
	[ -z "$selection" ] && return 1
	[ -z "$field" ] && return 1

	local res=$(jq --raw-output \
		".streams[$selection].$field" <<< $streamdata)

	echo "$res"
}

print_streams() {
	local streamdata=$1
	[ -z "$streamdata" ] && return 1

	local length=$(jq '.streams | length' <<< $streamdata)
	[ -z "$length" ] && return 1
	[ $length -lt 1 ] && return 1

	local i=0

	for i in $(seq 0 $length); do
		local stream=$(jq ".streams[$i]" <<< $streamdata)

		[ -z "$stream" ] && continue
		[ "$stream" == "null" ] && continue

		local data=$(jq --raw-output \
			'.channel.name, .game, .viewers, .channel.status' \
			<<< "$stream")

		local info=()

		while read line; do
			info+=("$line")
		done <<< $data

		echo -en "${info[0]} playing '${info[1]}' for ${info[2]} \"${info[3]}\"\n"

		i=$((i + 1))
	done
}

open_rofi

live_streams=$(get_live_streams_for_user "$USER")

coproc fmt { print_streams "$live_streams" >& $rofi_in ; }
trap "kill $fmt_PID" EXIT

get_rofi_selection

[ -z "$rofi_selection" ] && exit

close_rofi

if [[ $rofi_selection -gt -1 ]]; then
	url=$(get_from_rofi_selection "channel.url")
	channel=$(get_from_rofi_selection "channel.name")
	title=$(get_from_rofi_selection "channel.status")

	echo "$title"

	open_chat "$channel"
	open_stream "$url" "$title"
else
	[ -z "$rofi_query" ] && exit

	while [[ (-z "$rofi_selection" || $rofi_selection -lt 0) && -n "$rofi_query" ]]; do
		open_rofi
		live_streams=$(search_for_live_streams "$rofi_query")

		coproc search_fmt { print_streams "$live_streams" >& $rofi_in ; }
		trap "kill $search_fmt_PID" EXIT

		get_rofi_selection
		close_rofi
	done

	url=$(get_from_rofi_selection "channel.url")
	channel=$(get_from_rofi_selection "channel.name")
	title=$(get_from_rofi_selection "channel.status")

	open_chat "$channel"
	open_stream "$url" "$title"
fi
