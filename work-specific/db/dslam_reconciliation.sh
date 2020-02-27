#!/bin/zsh
if [[ "$1" == "-h" ]]; then
	echo "Usage: `basename $0` [db_schema]"
	echo "       If no schema name is provided, the value of \$CUSTOMER_DB will be used."
	exit 0
fi
if [ -z $1];
then
	DB=$CUSTOMER_DB
else
	DB=$1
fi
sqlturbo.py -u $DB -n -f csv -s ',' "
	select 'RECON', dslam, DSLAM_IP, DSLAM_TYPE, INTERFACE_TYPE, NMS_NAME, SNMP_COMMUNITY_RO, SNMP_COMMUNITY_RW, null, SNMP_PORT 
		from v_dslams 
		where status=0;"
