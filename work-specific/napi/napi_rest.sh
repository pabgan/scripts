#!/bin/bash

##########################
# HELP

usage(){
	echo "$(basename $0) [OPTION]..."
	echo "	-h --> shows usage"
	echo "	-S SERVER"
	echo "	-P PORT"
	echo "	-E ENDPOINT"
	echo "	-C CREDENTIALS"
	echo "	-V SERVICE"
	echo "	-K NO_CACHE"
	echo "	-A ACTION"
	echo "	-U URI"
	echo "	-c --> cleans token"
	exit 1
}

if [ ${#} -eq 0 ]; then
	usage
fi


##########################
# UTIL
EXEC_PATH=$(pwd)

##########################
# PARSE INPUT
# https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/
optstring="hS:P:E:C:V:KA:U:O:c"

# Set defaults
SERVER=$CUSTOMER_ENV
ENDPOINT='expresse'
PORT='8443'
USERNAME='administrator'
PASSWORD='assia'
PROTOCOL='https'

while getopts ${optstring} arg; do
	case ${arg} in
		h) usage ;;
		S) SERVER=$OPTARG ;;
		P) PORT=$OPTARG ;;
		E) ENDPOINT=$OPTARG ;;
		C) CREDENTIALS=$OPTARG ;;
		V) SERVICE=$OPTARG ;;
		K) NO_CACHE=1 ;;
		A) ACTION=$OPTARG ;;
		U) URI=$OPTARG ;;
		O) OPTIONS=$OPTARG ;;
		c) rm -f .token .sessionid; exit ;;
	esac
done
shift $((OPTIND -1))

ADDRESS="${PROTOCOL}://${SERVER}.assia-inc.com:${PORT}"


##########################
# AUXILIARY FUNCTIONS

get_token(){
	#echo "renewing token..."
	curl --silent -u "rest-client-trusted:gnQB_jC-XU8RB*3#"  -k -X POST -d "username=$USERNAME&password=$PASSWORD&grant_type=password" $ADDRESS/$ENDPOINT/oauth/token | cut -d'"' -f4 > .token
	#echo "got: '$TOKEN'"
}

##########################
# MAIN
# 
# 1. Get authorization if needed
if [ -n "$CREDENTIALS" ]; then
	# Tentatively remove credentials to avoid reusing 
	# credentials from another user
	# TODO: Store username to reuse them only if matching
	# current username
	rm -f .token
	#echo "parsing credentials..."
	USERNAME=$(echo "$CREDENTIALS" | cut -d':' -f1)
	PASSWORD=$(echo "$CREDENTIALS" | cut -d':' -f2)
fi
# Remove cached credentials if they are too old
# in minutes
max_old=10
find .token -mmin +$max_old -exec rm {} \; 2> /dev/null
TOKEN=$(cat .token 2> /dev/null )

if [[ -z $TOKEN ]]; then
	get_token
	TOKEN=$(cat .token 2> /dev/null )
else
	echo 'reusing token' 1>&2
fi

# 2. Execute request
ADDITIONAL_PARAMETERS=$1
if [[ ! -z $ADDITIONAL_PARAMETERS ]]; then
	curl -k --request $ACTION --url $ADDRESS/$ENDPOINT/$URI --header 'accept: application/json' --header "Authorization: bearer $TOKEN" --header 'cache-control: no-cache' --header 'content-type: application/json' -d $ADDITIONAL_PARAMETERS $OPTIONS | python -m json.tool
else
	echo "curl -k --request $ACTION --url $ADDRESS/$ENDPOINT/$URI --header 'accept: application/json' --header \"Authorization: bearer $TOKEN\" --header 'cache-control: no-cache' --header 'content-type: application/json' $OPTIONS"
	curl -k --request $ACTION --url $ADDRESS/$ENDPOINT/$URI --header 'accept: application/json' --header "Authorization: bearer $TOKEN" --header 'cache-control: no-cache' --header 'content-type: application/json' $OPTIONS
fi
