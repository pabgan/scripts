Verified in **demo-b v5.7.0**.

```sh

SERVER=demo-b
ACTION='urn:login'
SESSIONID=$(xmllint --format <(curl --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --data @login.env http://$SERVER.assia-inc.com:8080/expresse/services/authentication.authenticationHttpSoap11Endpoint/ ) | sed -n -e  's/.\+sessionId>\(.\+\)<\/.\+/\1/p')

```

#### Test 1: `getAvailableFields`
```sh

ACTION='urn:getAvailableFields' 
xmllint --format <( curl --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --header "cookie:JSESSIONID=$SESSIONID" --data @getAvailableFields.env http://$SERVER.assia-inc.com:8080/expresse/services/pe_data.pe_dataHttpSoap11Endpoint/ ) > t1-response.xml

```

1. (/)
```sh
grep 'layer2.state<' t1-response.xml
            <ax253:value>layer2.state</ax253:value>
```
1. (/)
```sh
grep 'layer2.speed<' t1-response.xml
            <ax253:value>layer2.speed</ax253:value>
```
1. (/)
```sh
grep 'layer2.speed_configured<' t1-response.xml
            <ax253:value>layer2.speed_configured</ax253:value>
```
1. (/)
```sh
grep 'layer2.duplex_mode<' t1-response.xml
            <ax253:value>layer2.duplex_mode</ax253:value>
```
1. (/)
```sh
grep 'layer2.duplex_mode.code<' t1-response.xml
            <ax253:value>layer2.duplex_mode.code</ax253:value>
```
1. (/)
```sh
grep 'layer2.duplex_mode_configured<' t1-response.xml
            <ax253:value>layer2.duplex_mode_configured</ax253:value>
```
1. (/)
```sh
grep 'layer2.duplex_mode_configured.code<' t1-response.xml
            <ax253:value>layer2.duplex_mode_configured.code</ax253:value>
```

{color:green}PASS{color}

----
#### Test 2: `getData` fields are requested
```sh

ACTION='urn:getData' 
xmllint --format <( curl --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --header "cookie:JSESSIONID=$SESSIONID" --data @getData.env http://$SERVER.assia-inc.com:8080/expresse/services/pe_data.pe_dataHttpSoap11Endpoint/ ) > t2-response.xml

```

```sh
cat t2-response.xml
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:getDataResponse xmlns:ns="http://ws.api.report.dslo.assia.com">
      <ns:return xmlns:ax253="http://model.napi.dslo.assia.com/xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ax253:ResponseDataBean">
        <ax253:message>No data returned.</ax253:message>
        <ax253:statusCode>30</ax253:statusCode>
      </ns:return>
    </ns:getDataResponse>
  </soapenv:Body>
</soapenv:Envelope>
```
@jmatias, for this I had to provision this DSLAM in **demo-b**. For that I executed: `provision_odn_3splitters.sql`, `provision_odn.sql`, `simulator_dslam_info_provisioning.sql`, `simulator_dslam_info_snmpv2c_provisioning.sql` and `simulator_port_info_provisioning.sql`. After that I executed two `PON_ALL` requests with the following results:
```sql
select * from dcpc_status_code
	where line_id = '9875550011';

LINE_ID   	PORT        	DSLAM       	COLLECTION_DATE    	STATUS_CODE
----------	------------	------------	-------------------	-----------
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 07:01:00	10200      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 07:00:31	10900      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 07:00:44	10100      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 07:00:47	10800      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 07:00:22	11700      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 05:08:14	11700      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 05:08:15	11700      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 05:08:16	11700      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 05:08:17	11700      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:43:37	11080      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:52:24	11000      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:52:24	10100      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:52:24	10200      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:52:24	10800      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:52:24	10900      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:48:43	11080      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:54:33	11000      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:54:33	10100      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:54:33	10200      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:54:33	10800      
9875550011	1-1-1-4#1-g1	ISAM_PON_5_5	2020-09-21 01:54:33	10900      
```
You can find the log at [t2-expresseGuiNapi.log](t2-expresseGuiNapi.log).

I hope you find this information useful, otherwise just let me know.

----
#### Test 3: `getData` fileds are NOT requested
_Pending_
