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
#TODO: Descargar NCD
#TODO: aplicarle docx2txt
change_percentiles() {
	ssh user@$CUSTOMER_ENV.assia-inc.com "
		sed -i 's/pon.pe.estimator.throughput.stats.min.num.percentiles.*=.*/pon.pe.estimator.throughput.stats.min.num.percentiles = 2/' ~/install/server/config/pon.pe.estimator.properties ;;
		sed -i 's/pon.sr.throughput.stats.min.num.percentiles.*=.*/pon.sr.throughput.stats.min.num.percentiles = 2/' ~/install/server/config/pon.sr.properties ;;
		ant -f ~/install/server/build.xml pe restart
		"
}

#######################
# 1. TEST
#
#TODO: diff?
#TODO: Descargar nuevo documento SLTP
#TODO: whitelist para OI/Colombia
#TODO: diff NCD
#TODO: diff SLTP

#######################
# 2. Tear down
#TODO: Cerrar release
