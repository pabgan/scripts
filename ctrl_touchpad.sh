#!/bin/sh
stick='AlpsPS/2 ALPS DualPoint Stick'
touchpad='AlpsPS/2 ALPS DualPoint TouchPad'
xinput set-prop $stick "Device Enabled" $1
xinput set-prop $touchpad "Device Enabled" $1
