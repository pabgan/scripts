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
sqlturbo.py -u $DB -f csv -s ',' -n "
	select 'RECON', line_id, dslam, port, service_product, circuit_id, PO_ENABLED, PE_ENABLED, NETWORK, TECHNOLOGY 
		from v_ports where status=0 and IS_BONDED=0 
		Union all 
		select 'RECON', line_id, dslam, port, service_product, circuit_id, PO_ENABLED, PE_ENABLED, NETWORK, TECHNOLOGY 
		from ( 
			select line_id, dslam, listagg(port, '|') within group (order by port) over (partition by BONDED_GROUP_ID) as port, service_product, circuit_id, PO_ENABLED, PE_ENABLED, NETWORK, TECHNOLOGY 
			from v_ports where status=0 and IS_BONDED=1 
		     ) 
		where line_id not like '%\__' escape '\';"
