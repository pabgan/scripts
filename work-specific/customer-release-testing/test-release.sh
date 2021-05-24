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

update_topology() {
	#TODO
	echo '# WARN: update_topology: NOT IMPLEMENTED YET!!'
}

deploy_simulators() {
	#TODO
	echo '# WARN: deploy_simulators: NOT IMPLEMENTED YET!!'
}

deploy_ansible() {
	#TODO
	echo '# WARN: deploy_ansible: NOT IMPLEMENTED YET!!'
}

refresh_rclone_token() {
	#TODO
	echo '# WARN: refresh_rclone_token: NOT IMPLEMENTED YET!!'
}

setup() {
	refresh_rclone_token
	get_deliverables
	get_sltp
	change_percentiles
	update_topology
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
	./sltp/all_lines_to_po.sh > $work_path/$sql_file

	echo "## Sending it all to db-ref"
	db_server='db-ref'
	remote_dir='pganuza'
	rsync -rvzh $work_path $db_server:$remote_dir/

	echo "## Executing remotely"
	log_file='all_lines_to_po.log'
	#TODO: send altpo.sh also and include it in GIT
	ssh $db_server $remote_dir/po/altpo.sh ${CUSTOMER_DB} | tee "$work_path/$log_file"
	echo "----"
}

force_line_reset() {
	echo '# WARN: force_line_reset: NOT IMPLEMENTED YET!!'
}

warn_whitelist_if_need_be() {
	ssh user@$CUSTOMER_ENV.assia-inc.com 'ls ~/install/server/config/migration > /dev/null 2>&1'
	if [[ $( echo "$?" ) == 0 ]]; then
		echo '# WARN: Customer has mismatch configured. Whitelist must be run!!'
	fi
}

prepare_sltp() {
	#TODO: whitelist para OI/Colombia
	warn_whitelist_if_need_be
	all_lines_to_po
	force_line_reset
}

download_ncd_old (){
	version=$1
	cp $CUSTOMER_DIR/../onedrive/04.*Projects/Releases/*$version*/02.*Delivered/*${version}*onventions* .
}

download_ncd_new (){
	cp $CUSTOMER_DIR/../onedrive/01.*Customer_documentation/01.*Data_Conventions/*onventions* .
}

diff_ncd() {
	# 1. Get documents
	#TODO: retrieve version numbers from where?
	version_old=$2
	(cd $CUSTOMER_DIR/..; mount-onedrive & )

	pushd sltp
	#download_ncd_old $version_old
	#download_ncd_new

	# 2. Convert them to txt
	pdftotext *$version_old*onventions*.pdf ncd_old.txt
	docx2txt *onventions*.docx
	mv *onventions*.txt ncd_new.txt
	diff ncd_old.txt ncd_new.txt > ncd.diff

	popd
}

jenkins_url='http://rc-build-01.assia-inc.com:8080'
user='pganuza'
pass='*******'
execute_jenkins_job() {
	job_name=$1

	crumbIssuer_url='crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\)'
	crumb=$(curl -u "$user:$pass" $jenkins_URL/$crumbIssuer_url)
	#curl -u "$user:$pass" -H "$crumb" -X POST $jenkins_url/job/$job_name/build
}

execute_sltp() {
	#TODO: execute ncd_auto_tests
	#TODO: execute napi_auto_tests
	#TODO: execute selenium_auto_tests
	#TODO: execute_sltp_tests()
}

diff_sltp() {

	#TODO: download_previous_sltp_results()
	#TODO: download_new_sltp_results()
}


#######################
# 2. Tear down
#TODO: Destroy ansible
#TODO: Cerrar release

"$@"
