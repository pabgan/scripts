#!/bin/zsh
source ~/.zshrc

get_deliverables(){
	mkdir -p deliverables
	pushd deliverables
	wget_sqls
	popd
	#TODO: Descargar NCD
	#TODO: aplicarle docx2txt
}

get_deliverables
#TODO: Descargar nuevo documento SLTP
