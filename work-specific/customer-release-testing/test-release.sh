#!/bin/zsh
source ~/.zshrc

#######################
# 0. SET UP
get_deliverables() {
	mkdir -p deliverables
	pushd deliverables
	wget_sqls
	popd
}

get_sltp() {
	mkdir -p sltp
	pushd sltp
	rclone copy expresse_sharepoint:"QA/02. Templates/System Test Plan.docm" .
	mv "System Test Plan.docm" "System Test Plan - ${CUSTOMER_NAME} ${CUSTOMER_VER}.docm"
	popd
}

change_percentiles() {
	ssh user@$CUSTOMER_ENV.assia-inc.com "
		sed -i 's/pon.pe.estimator.throughput.stats.min.num.percentiles.*=.*/pon.pe.estimator.throughput.stats.min.num.percentiles = 2/' ~/install/server/config/pon.pe.estimator.properties
		sed -i 's/pon.sr.throughput.stats.min.num.percentiles.*=.*/pon.sr.throughput.stats.min.num.percentiles = 2/' ~/install/server/config/pon.sr.properties
		ant -f ~/install/server/build.xml pe restart
		"
}

deploy_simulators() {
	#TODO
}

deploy_ansible() {
	#TODO
}

setup() {
	get_deliverables
	get_sltp
	change_percentiles
	deploy_simulators #? It might be that this is already done when deploying release
	deploy_ansible
}

#######################
# 1. TEST
#

# 1.1 diff
#TODO:

# 1.2 tickets
# nothing to do?

# 1.3 SLTP
all_lines_to_po() {
	echo "# all_lines_to_po"
	work_path='sltp/po'
	mkdir -p $work_path

	echo "## Generating all_lines_to_po.sql"
	sql_file='all_lines_to_po.sql'
	all_lines_to_po.sh > $work_path/$sql_file

	echo "## Sending it all to db-ref"
	db_server='db-ref'
	remote_dir='pganuza'
	rsync -rvzh $work_path $db_server:pganuza/

	echo "## Executing remotely"
	log_file='all_lines_to_po.log'
	#TODO: send altpo.sh also and include it in GIT
	ssh $db_server pganuza/po/altpo.sh ${CUSTOMER_DB} | tee "$work_path/$log_file"
	echo "----"
}

prepare_sltp() {
	#TODO: whitelist para OI/Colombia
	#TODO: all lines to PO
}
#TODO: diff NCD
#TODO: diff SLTP
#TODO: execute ncd_auto_tests
#TODO: execute napi_auto_tests
#TODO: execute selenium_auto_tests

#######################
# 2. Tear down
#TODO: Destroy ansible
#TODO: Cerrar release

"$@"
