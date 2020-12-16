#!/bin/bash
if [ $# != 1 ]; then
	echo 1>&2 "*** Usage: $0 [host]"
	exit 2
fi

host=$1
ssh user@$host '
password=$(grep -E "^monitorRole" /home/user/install/server/config/assia.jmxremote.password | cut -d" " -f 2)
echo "Using \"$password\" as password." 1>&2
cd /home/user/install/server
export JAVA_HOME=/usr/local/java/jdk
ant -f ant/scheduler_build.xml dumpSchedulerInfo -Dparameters="localhost:10365 $password"
'
