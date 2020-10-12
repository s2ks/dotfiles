#!/bin/bash

if [[ $# -eq 0 ]]; then
	echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
	echo -en "Suspend\0icon\x1fsystem-suspend\n"
	echo -en "Hibernate\0icon\x1fsystem-hibernate\n"
	echo -en "Reboot\0icon\x1fsystem-reboot\n"
	echo -en "Lock\0icon\x1fsystem-lock-screen\n"
	echo -en "Logout\0icon\x1fsystem-log-out\n"
else
	case "$1" in
		Lock)
			loginctl lock-session
			;;
		Logout)
			i3-msg exit
			;;
		Shutdown)
			systemctl poweroff
			;;
		Reboot)
			systemctl reboot
			;;
		Suspend)
			systemctl suspend
			;;
		Hibernate)
			systemctl hibernate
			;;
	esac
fi
