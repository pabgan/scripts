for DSLAM in Randburg_MSAN_PON Cotswold_ISAM_PON
	        grep 'PORT_INFO' simulators_provisioning_info.sql | grep $DSLAM | cut -d',' -f16 | sort | uniq | sed "s/'//g" > $DSLAM-current_sps.txt
