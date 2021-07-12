#!/bin/zsh
source ~/.zshrc

#######################
# 0. SET UP
get_deliverables() {
	echo "##################################################"
	echo "    get_deliverables() "
	mkdir -p deliverables
	pushd deliverables
	wget_sqls
	popd
	echo "################# DONE ###########################\n"
}

get_sltp() {
	echo "##################################################"
	echo "    get_sltp() "
	mkdir -p sltp/results
	pushd sltp
	rclone copy generic:"QA/02. Templates/System Test Plan.docm" results/
	ln -s results/"System Test Plan.docm" "System Test Plan - ${CUSTOMER_NAME} ${CUSTOMER_VER}.docm"
	popd
	echo "################# DONE ###########################\n"
}

change_percentiles() {
	echo "##################################################"
	echo "    change_percentiles() "
	ssh user@$CUSTOMER_ENV.assia-inc.com "
		sed -i 's/pon.pe.estimator.throughput.stats.min.num.percentiles.*=.*/pon.pe.estimator.throughput.stats.min.num.percentiles = 2/' ~/install/server/config/pon.pe.estimator.properties
		sed -i 's/pon.sr.throughput.stats.min.num.percentiles.*=.*/pon.sr.throughput.stats.min.num.percentiles = 2/' ~/install/server/config/pon.sr.properties
		ant -f ~/install/server/build.xml pe restart
		"
	echo "################# DONE ###########################\n"
}

update_topology() {
	echo "##################################################"
	echo "    update_topology() "
	#TODO
	echo "# WARN: NOT IMPLEMENTED YET!!"
	update_topology_$CUSTOMER
	echo "################# DONE ###########################\n"
}

update_topology_telefonica_colombia() {
	echo " --> For telefonica_colombia you have to mannually execute the following:"
	echo "INSERT INTO DSLAM_TOPOLOGY (DSLAM_IP,TOPOLOGY) VALUES ('127.0.0.1','OUTDOOR');"
	echo "INSERT INTO DSLAM_TOPOLOGY (DSLAM_IP,TOPOLOGY) VALUES ('127.0.0.2','INDOOR');"
}

deploy_simulators() {
	echo "##################################################"
	echo "    deploy_simulators() "
	#TODO
	echo "# WARN: NOT IMPLEMENTED YET!!"
	echo "################# DONE ###########################\n"
}

deploy_ansible() {
	echo "##################################################"
	echo "    deploy_ansible() "
	#TODO
	echo "# WARN: NOT IMPLEMENTED YET!!"
	echo "################# DONE ###########################\n"
}

refresh_rclone_token() {
	echo "##################################################"
	echo "    refresh_rclone_token() "
	#TODO
	echo "# WARN: NOT IMPLEMENTED YET!!"
	echo "################# DONE ###########################\n"
}

prepare_mismatch() {
	echo "##################################################"
	echo "    prepare_mismatch() "
	ssh user@$CUSTOMER_ENV.assia-inc.com 'ls ~/install/server/config/migration > /dev/null 2>&1'
	if [[ $( echo "$?" ) == 0 ]]; then
		# Remind to run whitelist
		echo '# WARN: Customer has mismatch configured. Whitelist must be run!!'

		# Remind to truncate mismatch history
		echo '# WARN: Customer has mismatch configured. `truncate table MGR_MMT_DETECTION_AGGREGATE;`!!'
	fi
	echo "################# DONE ###########################\n"
}

schedule_all_lines_to_po() {
	echo "##################################################"
	echo "    schedule_all_lines_to_po() "
	t add pri a "meter todas las líneas de +$CUSTOMER en PO t:$(tdate 'friday') due:$(tdate 'friday')"
	echo "################# DONE ###########################\n"
}

setup() {
	refresh_rclone_token
	get_deliverables
	get_sltp
	change_percentiles
	update_topology
	prepare_mismatch
	deploy_simulators #? It might be that this is already done when deploying release
	deploy_ansible
	schedule_all_lines_to_po
}

#######################
# 1. TEST
#
test() {
	prepare_diff
	prepare_tickets
	prepare_sltp
}

# 1.1 diff
#TODO:
prepare_diff() {
	mkdir -p diff
	# Prepare config.properties
	## checkout tag
	## get generic version that it is based on
	# create directory in qa-dev
}

# 1.2 tickets
# nothing to do?
prepare_tickets() {
	mkdir -p tickets
}

# 1.3 SLTP
all_lines_to_po() {
	echo "##################################################"
	echo "    all_lines_to_po() "
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
	echo "################# DONE ###########################\n"
}

force_line_reset() {
	echo "##################################################"
	echo "    force_line_reset() "
	# TODO
	echo '# WARN: NOT IMPLEMENTED YET!!'
	echo "################# DONE ###########################\n"
}

prepare_sltp() {
	t add pri a "ejecutar 'test-release.sh all_lines_to_po' para meter todas las líneas en PO para +SLTP de +$CUSTOMER $(tdate 'friday')"
	force_line_reset
}

download_ncd_old (){
	echo "##################################################"
	echo "    download_ncd_old() "
	version=$1
	cp $CUSTOMER_DIR/../onedrive/04.*Projects/Releases/*$version*/02.*Delivered/*${version}*onventions* .
	echo "################# DONE ###########################\n"
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

execute ncd_auto_tests() {
	echo "##################################################"
	echo "    ncd_auto_tests() "
	# TODO
	echo "# WARN: NOT IMPLEMENTED YET!!"
	echo "################# DONE ###########################\n"
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
