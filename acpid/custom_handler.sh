#!/bin/bash

case "$1" in
	video/brightnessdown)
		case "$2" in
			BRTDN)
				xbacklight -steps 2 -dec 5
				;;
		esac
		;;
	video/brightnessup)
		case "$2" in
			BRTUP)
				xbacklight -steps 2 -inc 5
				;;
		esac
		;;
	button/mute)
		case "$2" in
			MUTE)
				pamixer --toggle-mute
				;;
		esac
		;;
	button/volumedown)
		case "$2" in
			VOLDN)
				pamixer --decrease 5
				;;
		esac
		;;
	button/volumeup)
		case "$2" in
			VOLUP)
				pamixer --increase 5
				;;
		esac
		;;
esac
