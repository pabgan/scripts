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
echo 'Set serverout on;' 
echo 'VARIABLE resultSet REFCURSOR;'
echo 'VARIABLE statusCode NUMBER;'
sqlturbo.py -u $DB -f plain -n "select 'exec profile_optimization_requests.PO_START('''||line_id||''', :resultSet, :statusCode);' from port_info left join po_state using(line_id) where status=0 and IS_PO_ENABLED=1 and DATE_REQUEST is null and BONDED_GROUP_ID=LINE_ID;"
echo 'Update PO_STATE set source = 0;'
echo 'Commit;'
echo 'exec NETWORK_STATISTICS_MANAGER.POPULATE_LINE_INFO_SNAPSHOT;'
echo "exec DBMS_MVIEW.REFRESH('V_LINE_CARD_INFO_LATEST_PM');"
