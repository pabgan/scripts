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
