#!/bin/bash

##########################
# HELP

usage(){
	echo "./$(basename $0) -h --> shows usage"
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

optstring="hRS:P:E:C:V:Kc"

# Set defaults
SERVER=$CUSTOMER_ENV
ENDPOINT='expresse'
PORT='8080'
USERNAME='administrator'
PASSWORD='assia'
PROTOCOL='http'

while getopts ${optstring} arg; do
	case ${arg} in
		h) usage ;;
		R) REST=1 ;;
		S) SERVER=$OPTARG ;;
		P) PORT=$OPTARG ;;
		E) ENDPOINT=$OPTARG ;;
		C) CREDENTIALS=$OPTARG ;;
		V) SERVICE=$OPTARG ;;
		K) NO_CACHE=1 ;;
		c) rm .token .sessionid ;;
	esac
done
shift $((OPTIND -1))

subcommand=$1; shift  # Remove subcommand from the argument list

ADDRESS="${PROTOCOL}://${SERVER}.assia-inc.com:${PORT}"


##########################
# AUXILIARY FUNCTIONS

LOGIN_ENV="<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:impl='http://impl.api.authentication.dslo.assia.com'>
   <soapenv:Header/>
   <soapenv:Body>
      <impl:login>
         <impl:userId>$USERNAME</impl:userId>
         <impl:password>$PASSWORD</impl:password>
      </impl:login>
   </soapenv:Body>
</soapenv:Envelope>"

get_sessionid(){
	#echo "getting session ID for $USERNAME:$PASSWORD..."

	ACTION='urn:login'

	xmllint --format <(curl --silent --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --data @<(echo "$LOGIN_ENV") $ADDRESS/$ENDPOINT/services/authentication.authenticationHttpSoap11Endpoint/ ) | sed -n -e  's/.\+sessionId>\(.\+\)<\/.\+/\1/p' > .sessionid
}

get_token(){
	#echo "renewing token..."
	curl --silent -u "rest-client-trusted:gnQB_jC-XU8RB*3#"  -k -X POST -d 'username=administrator&password=assia&grant_type=password' $ADDRESS/$ENDPOINT/oauth/token | cut -d'"' -f4 > .token
	#echo "got: '$TOKEN'"
}

######################

submitRequest(){
	echo "submitting request $envelope" 1>&2
	echo "... to $ADDRESS" 1>&2
	ACTION='urn:submitRequest'

	H_CONTENT_TYPE="Content-Type: text/xml;charset=UTF-8"
	H_ACTION="SOAPAction:$ACTION"
	H_AUTH="cookie:JSESSIONID=$SESSIONID"

	#xmllint --format <( curl -V -H $H_CONTENT_TYPE -H $H_ACTION -H $H_AUTH --data @"$EXEC_PATH/$ENVELOPE" $ADDRESS/$ENDPOINT/services/realtime.realtimeHttpSoap11Endpoint/ )
	#curl -H $H_CONTENT_TYPE -H $H_ACTION -H $H_AUTH --data @"$EXEC_PATH/$envelope" $ADDRESS/$ENDPOINT/services/realtime.realtimeHttpSoap11Endpoint/
	curl --silent -H "$H_CONTENT_TYPE" -H "$H_ACTION" -H "$H_AUTH" --data @"$EXEC_PATH/$envelope" $ADDRESS/$ENDPOINT/services/realtime.realtimeHttpSoap11Endpoint/
}

submitRequest_rest(){
	ACTION='urn:submitRequest'
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
	rm -f .token .sessionid
	#echo "parsing credentials..."
	USERNAME=$(echo "$CREDENTIALS" | cut -d':' -f1)
	PASSWORD=$(echo "$CREDENTIALS" | cut -d':' -f2)
fi
# Remove cached credentials if they are too old
# in minutes
max_old=10
find .sessionid -mmin +$max_old -exec rm {} \; 2> /dev/null
find .token -mmin +$max_old -exec rm {} \; 2> /dev/null
if [[ -n $REST ]]; then
	TOKEN=$(cat .token 2> /dev/null )

	if [[ -z $TOKEN ]]; then
		get_token
		TOKEN=$(cat .token 2> /dev/null )
	else
		echo 'reusing token' 1>&2
	fi
else
	SESSIONID=$(cat .sessionid)

	if [ -z $SESSIONID ]; then
		get_sessionid
		SESSIONID=$(cat .sessionid)
	else
		echo 'reusing sessionid' 1>&2
	fi
fi

# 2. Execute request
case "$subcommand" in
	submitRequest)
		envelope=$1
		shift
		# Parse options to the submitRequest sub command
		optstring="a:"
		while getopts ${optstring} arg; do
			case ${arg} in
				a) ADDITIONAL_PARAMETERS=$OPTARG ;;
			esac
		done
		shift $((OPTIND -1))

		if [[ -n $REST ]]; then
			submitRequest_rest $envelope
		else
			submitRequest $envelope
		fi
esac

#curl -s -k -H $H_CONTENT_TYPE -H $H_ACCEPT -H $H_AUTHORIZATION "$ADDRESS/$ENDPOINT/rest/realtime/v1/reports/single/PON_DATA_COLLECTION/DSLE%2022232%2F0" -d $ADDITIONAL_PARAMETERS

