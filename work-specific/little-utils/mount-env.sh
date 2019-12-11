#!/bin/bash
if [ $# != 1 ]; then
	echo "*** Usage: $0 [host]"
fi

host=$1
mount_point="/mnt/$1"

sudo mkdir -p $mount_point
sudo chown pganuza:pganuza $mount_point
sshfs user@$host:. $mount_point
