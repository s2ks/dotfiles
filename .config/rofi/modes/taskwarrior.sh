#!/bin/bash

FIELDS=$(task status:pending export | jq 'sort_by(-.urgency) | .[] | .uuid,.description')

UUID=()
ENTRIES=
ROFI_CMD="rofi -dmenu -format i:s"

declare -A desc

while read uuid; do
	desc[$uuid]=$(read;echo ${REPLY:1:-1})

	ENTRIES+="${desc[$uuid]}\n"
	UUID+=($uuid)
done <<< $FIELDS

SELECT=$(echo -en "$ENTRIES" | $ROFI_CMD)

if [[ -z $SELECT ]]; then
	exit
fi

SELECT=${SELECT%:*}

rofi -modi taskwarrior-edit:"./taskwarrior-edit.sh ${UUID[$SELECT]}" -show taskwarrior-edit

exec $0
