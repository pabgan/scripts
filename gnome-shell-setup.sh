#!/bin/sh
# Alt+Tab to Switch Windows Only on Current Workspace in GNOME Shell [1]
gsettings set org.gnome.shell.window-switcher current-workspace-only true
gsettings set org.gnome.shell.app-switcher current-workspace-only true

# Sources:
# [1] https://linuxiac.com/alt-tab-to-switch-only-on-current-workspace-in-gnome-shell/
