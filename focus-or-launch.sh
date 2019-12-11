#!/bin/sh
#wmctrl -a "Microsoft Teams" ; [ "$?" == "1" ] && gtk-launch epiphany-teams.microsoft.com-f647063cc3681ecdb8292ae8220dd938e4f2f8ec
app_name=$1
app_launcher=$2
mod=$3
current_desktop=$(wmctrl -d | grep -e '[0-9]\s\+\*' | cut -d' ' -f1)
wid=$(wmctrl -l | grep -e "$app_name" | cut -d' ' -f1)
wid_cd=$(wmctrl -l | grep -e "0x[0-9a-f]\+\s\+$current_desktop" | grep -E $app_name | cut -d' ' -f1)
case $mod in
	'focus-wherever' )
		echo 'focus-wherever' 
		wmctrl -ia $wid || $app_launcher
		;;
	'focus-in-cd' )
		echo 'focus-in-cd' 
		wmctrl -ia $wid_cd || $app_launcher
		;;
	'bring' )
		echo 'bring' 
		wmctrl -iR $wid || $app_launcher
		;;
	*)
esac
