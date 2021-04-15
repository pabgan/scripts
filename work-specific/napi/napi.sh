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
	echo "	-v VERBOSE"
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

optstring="hS:P:E:C:V:Kvc"

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
		S) SERVER=$OPTARG ;;
		P) PORT=$OPTARG ;;
		E) ENDPOINT=$OPTARG ;;
		C) CREDENTIALS=$OPTARG ;;
		V) SERVICE=$OPTARG ;;
		K) NO_CACHE=1 ;;
		v) VERBOSE=true ;;
		c) rm -f .token .sessionid; exit ;;
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
	if [[ $VERBOSE ]]; then echo "renewing sessionid..." ; fi

	ACTION='urn:login'
	if [[ $VERBOSE ]]; then echo "curl --silent --header \"Content-Type: text/xml;charset=UTF-8\" --header \"SOAPAction:$ACTION\" --data @<(echo \"$LOGIN_ENV\") $ADDRESS/$ENDPOINT/services/authentication.authenticationHttpSoap11Endpoint/" ; fi
	xmllint --format <(curl --silent --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --data @<(echo "$LOGIN_ENV") $ADDRESS/$ENDPOINT/services/authentication.authenticationHttpSoap11Endpoint/ ) | sed -n -e  's/.\+sessionId>\(.\+\)<\/.\+/\1/p' > .sessionid
}

######################

submitRequest(){
	envelope=$1
	if [[ $VERBOSE ]]; then echo "submitting request $envelope" ; fi
	if [[ $VERBOSE ]]; then echo "... to $ADDRESS" ; fi
	ACTION='urn:submitRequest'

	H_CONTENT_TYPE="Content-Type: text/xml;charset=UTF-8"
	H_ACTION="SOAPAction:$ACTION"
	H_AUTH="cookie:JSESSIONID=$SESSIONID"

	#xmllint --format <( curl -V -H $H_CONTENT_TYPE -H $H_ACTION -H $H_AUTH --data @"$EXEC_PATH/$ENVELOPE" $ADDRESS/$ENDPOINT/services/realtime.realtimeHttpSoap11Endpoint/ )
	#curl -H $H_CONTENT_TYPE -H $H_ACTION -H $H_AUTH --data @"$EXEC_PATH/$envelope" $ADDRESS/$ENDPOINT/services/realtime.realtimeHttpSoap11Endpoint/
	if [[ $VERBOSE ]]; then echo "curl --silent -H \"$H_CONTENT_TYPE\" -H \"$H_ACTION\" -H \"$H_AUTH\" --data @\"$EXEC_PATH/$envelope\" $ADDRESS/$ENDPOINT/services/realtime.realtimeHttpSoap11Endpoint/" ; fi
	curl --silent -H "$H_CONTENT_TYPE" -H "$H_ACTION" -H "$H_AUTH" --data @"$EXEC_PATH/$envelope" $ADDRESS/$ENDPOINT/services/realtime.realtimeHttpSoap11Endpoint/
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
	rm -f .sessionid
	#echo "parsing credentials..."
	USERNAME=$(echo "$CREDENTIALS" | cut -d':' -f1)
	PASSWORD=$(echo "$CREDENTIALS" | cut -d':' -f2)
fi
# Remove cached credentials if they are too old
# in minutes
max_old=10
find .sessionid -mmin +$max_old -exec rm {} \; 2> /dev/null
SESSIONID=$(cat .sessionid 2> /dev/null )

if [ -z $SESSIONID ]; then
	get_sessionid
	SESSIONID=$(cat .sessionid)
else
	if [[ $VERBOSE ]]; then echo "reusing sessionid" 1>&2 ; fi
fi

# 2. Execute request
case "$subcommand" in
	submitRequest)
		payload=$1
		shift
		# Parse options to the submitRequest sub command
		optstring="a:"
		while getopts ${optstring} arg; do
			case ${arg} in
				a) ADDITIONAL_PARAMETERS=$OPTARG ;;
			esac
		done
		shift $((OPTIND -1))

		submitRequest $payload
esac

#curl -s -k -H $H_CONTENT_TYPE -H $H_ACCEPT -H $H_AUTHORIZATION "$ADDRESS/$ENDPOINT/rest/realtime/v1/reports/single/PON_DATA_COLLECTION/DSLE%2022232%2F0" -d $ADDITIONAL_PARAMETERS

