sqlturbo.py -u $DB -n -f csv -s ',' "
	select 'RECON', dslam, DSLAM_IP, DSLAM_TYPE, INTERFACE_TYPE, NMS_NAME, SNMP_COMMUNITY_RO, SNMP_COMMUNITY_RW, SNMP_PORT 
		from v_dslams 
		where status=0;"
