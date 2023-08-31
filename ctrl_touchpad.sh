#!/bin/zsh

if [[ -n $1 ]]; then
	gsettings set org.gnome.desktop.peripherals.touchpad send-events $1
else
	current_value=$(gsettings get org.gnome.desktop.peripherals.touchpad send-events)

	echo "currently $current_value"
	
	if [[ $current_value == "'enabled'" ]]; then
		gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled
	else
		gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled
	fi
fi
