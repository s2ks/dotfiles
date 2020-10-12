#!/bin/bash

if [[ $# -eq 0 ]]; then
	exit
fi

UUID=$1
TASK=$(task uuid:$UUID export | jq '.[] | .description,.urgency,.priority?,.project?,.due?,.entry,.start?')
shift

if [[ $# -eq 0 ]]; then
	msg=
	read desc
	read urgency
	read priority
	read project
	read due
	read entry
	read start

	desc=${desc:1:-1}

	msg+="$desc"

	if [[ $priority != "null" ]]; then
		if [[ $priority == "\"H\"" ]]; then
			msg+=" // High"
		elif [[ $priority == "\"M\"" ]]; then
			msg+=" // Medium"
		elif [[ $priority == "\"L\"" ]]; then
			msg+=" // Low"
		fi
	fi

	if [[ $project != "null" ]]; then
		msg+=" // project: ${project:1:-1}"
	fi

	if [[ $due != "null" ]]; then
		time=${due##*T}
		date="${due:1:4}-${due:5:2}-${due:7:2} ${time:0:2}:${time:2:2}:${time:4:2}"
		date=$(date --date="$date" +%s)
		now=$(date +%s)
		echo "$(date --date="$date seconds - $now seconds" +%d)"
		msg+=" // $date"
	fi

	echo -en "\0message\x1f$msg\n"
	echo -en "start\n"
	echo -en "stop\n"
	echo -en "complete\n"
	echo -en "delete\n"
	echo -en "back\n"
fi <<< $TASK
