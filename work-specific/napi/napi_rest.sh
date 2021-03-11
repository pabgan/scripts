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
optstring="hS:P:E:C:V:KA:U:O:vc"

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
		v) VERBOSE=true ;;
		c) rm -f .token .sessionid; exit ;;
	esac
done
shift $((OPTIND -1))

ADDRESS="${PROTOCOL}://${SERVER}.assia-inc.com:${PORT}"


##########################
# AUXILIARY FUNCTIONS

get_token(){
	if [[ $VERBOSE ]]; then echo "# renewing token..." ; fi
	if [[ $VERBOSE ]]; then echo "$ curl --silent -u \"rest-client-trusted:gnQB_jC-XU8RB*3#\"  -k -X POST -d \"username=$USERNAME&password=$PASSWORD&grant_type=password\" $ADDRESS/$ENDPOINT/oauth/token" ; fi
	curl --silent -u "rest-client-trusted:gnQB_jC-XU8RB*3#"  -k -X POST -d "username=$USERNAME&password=$PASSWORD&grant_type=password" $ADDRESS/$ENDPOINT/oauth/token | cut -d'"' -f4 > .token
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
## 1.1 Remove cached credentials if they are too old
# Variable below expressed in minutes
max_old=10
find .token -mmin +$max_old -exec rm {} \; 2> /dev/null
TOKEN=$(cat .token 2> /dev/null )

## 1.2 Get new credentials if now there are none cached
if [[ -z $TOKEN ]]; then
	get_token
	TOKEN=$(cat .token 2> /dev/null )
else
	if [[ $VERBOSE ]]; then echo "# reusing token" ; fi
fi

## 1.3 Exit with error if credentials could not be procured
if [[ -z $TOKEN ]]; then
	echo "--- CRITICAL: could not get token. Can not proceed further. ---" >&2
	exit 1
fi

# 2. Execute request
ADDITIONAL_PARAMETERS=$1
if [[ ! -z $ADDITIONAL_PARAMETERS ]]; then
	if [[ $VERBOSE ]]; then echo "$ curl --silent -k --request $ACTION --url $ADDRESS/$ENDPOINT/$URI --header 'accept: application/json' --header \"Authorization: bearer $TOKEN\" --header 'cache-control: no-cache' --header 'content-type: application/json' $OPTIONS" ; fi
	if [[ $VERBOSE ]]; then echo "----------------- response -----------------" ; fi
	curl --silent -k --request $ACTION --url $ADDRESS/$ENDPOINT/$URI --header 'accept: application/json' --header "Authorization: bearer $TOKEN" --header 'cache-control: no-cache' --header 'content-type: application/json' -d $ADDITIONAL_PARAMETERS $OPTIONS
	if [[ $VERBOSE ]]; then echo "----------------- response -----------------" ; fi
else
	if [[ $VERBOSE ]]; then echo "$ curl --silent -k --request $ACTION --url $ADDRESS/$ENDPOINT/$URI --header 'accept: application/json' --header \"Authorization: bearer $TOKEN\" --header 'cache-control: no-cache' --header 'content-type: application/json' $OPTIONS" ; fi
	if [[ $VERBOSE ]]; then echo "----------------- response -----------------" ; fi
	curl --silent -k --request $ACTION --url $ADDRESS/$ENDPOINT/$URI --header 'accept: application/json' --header "Authorization: bearer $TOKEN" --header 'cache-control: no-cache' --header 'content-type: application/json' $OPTIONS
	if [[ $VERBOSE ]]; then echo "\n----------------- response -----------------" ; fi
fi
