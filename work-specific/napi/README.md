Verified in **demo-b v5.7.0.1**.


##### Setup
```sh

SERVER=http://demo-b.assia-inc.com:8080
TOKEN=$(curl -u "rest-client-trusted:gnQB_jC-XU8RB*3#"  -k -X POST -d 'username=administrator&password=assia&grant_type=password' $SERVER/expresse/oauth/token | cut -d'"' -f4)

```

----
#### Test 1: Integration test using REST
##### Steps
```sh

TYPE='GET'
URI="provisioning/v1/lines/$LINE_ID"
LINE_ID='0000020019'
ADDITIONAL_PARAMETERS="{
    \"lineId\":\"$LINE_ID\"
}"
curl -k --request $TYPE --url $SERVER/expresse/rest/$URI --header 'accept: application/json' --header "Authorization: bearer $TOKEN" --header 'cache-control: no-cache' --header 'content-type: application/json' -d $ADDITIONAL_PARAMETERS | python -m json.tool

```

##### Result
```json
{
    "additionalParameters": [
        {
            "key": "STATUS",
            "value": "0"
        },
        {
            "key": "CREATION_DATE",
            "value": "2015-09-24 15:49:15"
        },
        {
            "key": "UPDATE_DATE",
            "value": "2015-09-24 15:49:15"
        },
        {
            "key": "NETWORK",
            "value": "DEFAULT"
        },
        {
            "key": "IS_BONDED",
            "value": "0"
        },
        {
            "key": "BONDED_GROUP_ID",
            "value": "0000020019"
        },
        {
            "key": "PE_ENABLED",
            "value": "1"
        },
        {
            "key": "DSLAM_TYPE",
            "value": "HUAWEI5600T"
        },
        {
            "key": "PO_ENABLED",
            "value": "1"
        },
        {
            "key": "TECHNOLOGY",
            "value": "DSL"
        },
        {
            "key": "LINE_ID2",
            "value": "000.002.0019"
        }
    ],
    "dslamName": "HUAWEI2",
    "lineId": "0000020019",
    "message": "Successful",
    "port": "0-0-19",
    "serviceProduct": "ASSIA_MAX",
    "statusCode": 0
}
```

{color:green}PASS{color}

----

#### Test 2: Page not found
##### Steps
```sh

TYPE='GET'
URI="provisioning/v1/line/$LINE_ID"
LINE_ID='0000020019'
ADDITIONAL_PARAMETERS="{
    \"lineId\":\"$LINE_ID\"
}"
curl -k --request $TYPE --url $SERVER/expresse/rest/$URI --header 'accept: application/json' --header "Authorization: bearer $TOKEN" --header 'cache-control: no-cache' --header 'content-type: application/json' -d $ADDITIONAL_PARAMETERS | python -m json.tool

```

##### Result
```json
{
    "message": "Provided URI does not match a valid REST endpoint",
    "statusCode": 90
}
```

{color:green}PASS{color}

----

#### Test 3: Bad request
##### Steps
```sh

TYPE='POST'
URI="realtime/v1/reports/single/DATA_COLLECTION/$LINE_ID"
LINE_ID='0000020019'
ADDITIONAL_PARAMETERS="{
empty
}"
curl -k --request $TYPE --url $SERVER/expresse/rest/$URI --header 'accept: application/json' --header "Authorization: bearer $TOKEN" --header 'cache-control: no-cache' --header 'content-type: application/json' -d $ADDITIONAL_PARAMETERS | python -m json.tool

```

##### Result
```json

{
    "message": "Provided REST request is invalid",
    "statusCode": 91
}

```

{color:green}PASS{color}

----

#### Test 4: Internal Service Validation
##### Steps
```sh

TYPE='GET'
URI="realtime/v1/reports/DATA_COLLECTION/search?filter_n_request.id=0000040111:172.16.3.117:1597097321170:DATA_COLLECTION&start_position=0"
curl -k --request $TYPE --url $SERVER/expresse/rest/$URI --header 'accept: application/json' --header "Authorization: bearer $TOKEN" --header 'cache-control: no-cache' --header 'content-type: application/json' -d $ADDITIONAL_PARAMETERS | python -m json.tool

```

##### Result
```json

{
    "message": "Provided data size is not present, but start position is",
    "statusCode": 72
}

```

{color:green}PASS{color}
