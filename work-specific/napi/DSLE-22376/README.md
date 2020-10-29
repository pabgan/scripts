Verified in **demo-b v5.7.0.1**.

```sh

SERVER=demo-b
ACTION='urn:login'
SESSIONID=$(xmllint --format <(curl --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --data @login.env http://$SERVER.assia-inc.com:8080/expresse/services/authentication.authenticationHttpSoap11Endpoint/ ) | sed -n -e  's/.\+sessionId>\(.\+\)<\/.\+/\1/p')

```

### Test 1: `submitRequest` for `PON_DATA_COLLECTION`
#### Steps
1. Make sure there is information.
```sql

update LAYER2_DATA 
set other='ALTERNATE_SOFTWARE_VERSION=J74.00.0001.G2;BATTERY_BACKUP=false;CLEI_CODE=BVL3AX7DTA;DESCRIPTION=1380 Troy S;HARDWARE_VERSION=D;MODE=dual;OMCC_VERSION=G_988_2011_Amd_1_Base;PART_NUMBER=1287702G1C;REGISTRATION_ID=0003010424;TRAFFIC_MANAGEMENT=priorityControlled' 
where LINE_ID='9875550011';

12 updated.

SQL> commit;

Commit complete.

```
1. Execute request.
```sh

ACTION='urn:submitRequest' 
xmllint --format <( curl --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --header "cookie:JSESSIONID=$SESSIONID" --data @PON_DATA_COLLECTION.env http://$SERVER.assia-inc.com:8080/expresse/services/realtime.realtimeHttpSoap11Endpoint/ ) > t1-response.xml

```

#### Expected
1. All new fields are returned.

#### Result
1. (/)
```sh
grep -A1 'layer2.state<' t1-response.xml
            <ax29:key>layer2.state</ax29:key>
            <ax29:value>IS</ax29:value>
--
        <ax29:fieldNames>layer2.state</ax29:fieldNames>
        <ax29:fieldNames>line.info.pon.olt.vendor</ax29:fieldNames>
```
1. (/)
```sh
grep -A1 'layer2.state.code<' t1-response.xml
```
In DSLE-22396 it was already clarified that this field is finally not returned.
1. (/)
```sh
grep -A1 'layer2.speed<' t1-response.xml
            <ax29:key>layer2.speed</ax29:key>
            <ax29:value>-1</ax29:value>
--
        <ax29:fieldNames>layer2.speed</ax29:fieldNames>
        <ax29:fieldNames>line.operation.pon.us.tx.power</ax29:fieldNames>
```
1. (/)
```sh
grep -A1 'layer2.speed_configured<' t1-response.xml
            <ax29:key>layer2.speed_configured</ax29:key>
            <ax29:value>0</ax29:value>
--
        <ax29:fieldNames>layer2.speed_configured</ax29:fieldNames>
        <ax29:fieldNames>line.performance.pon.ds.total.packets</ax29:fieldNames>
```
1. (/)
```sh
grep -A1 'layer2.duplex_mode<' t1-response.xml
            <ax29:key>layer2.duplex_mode</ax29:key>
            <ax29:value>INVALID</ax29:value>
--
        <ax29:fieldNames>layer2.duplex_mode</ax29:fieldNames>
        <ax29:fieldNames>line.operation.pon.range.unit</ax29:fieldNames>
```
1. (/)
```sh
grep -A1 'layer2.duplex_mode.code<' t1-response.xml
            <ax29:key>layer2.duplex_mode.code</ax29:key>
            <ax29:value>-1</ax29:value>
--
        <ax29:fieldNames>layer2.duplex_mode.code</ax29:fieldNames>
        <ax29:fieldNames>line.performance.pon.us.total.packets</ax29:fieldNames>
```
1. (/)
```sh
grep -A1 'layer2.duplex_mode_configured<' t1-response.xml
            <ax29:key>layer2.duplex_mode_configured</ax29:key>
            <ax29:value>AUTO</ax29:value>
--
        <ax29:fieldNames>layer2.duplex_mode_configured</ax29:fieldNames>
        <ax29:fieldNames>layer2.duplex_mode</ax29:fieldNames>
```
1. (/)
```sh
grep -A1 'layer2.duplex_mode_configured.code<' t1-response.xml
            <ax29:key>layer2.duplex_mode_configured.code</ax29:key>
            <ax29:value>0</ax29:value>
--
        <ax29:fieldNames>layer2.duplex_mode_configured.code</ax29:fieldNames>
        <ax29:fieldNames>layer2.speed</ax29:fieldNames>
```
1. (/)
```sh
grep -A1 'realtime.dcpc.statuscode.layer2<' t1-response.xml
            <ax29:key>realtime.dcpc.statuscode.layer2</ax29:key>
            <ax29:value>0</ax29:value>
--
        <ax29:fieldNames>realtime.dcpc.statuscode.layer2</ax29:fieldNames>
        <ax29:fieldNames>line.performance.pon.measured.seconds</ax29:fieldNames>
```

{color:green}PASS{color}

----
### Test 2: `getAvailableFields` for `PON_DATA_COLLECTION`
1. Execute request.
```sh

ACTION='urn:getAvailableFields' 
xmllint --format <( curl --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --header "cookie:JSESSIONID=$SESSIONID" --data @getAvailableFields.env http://$SERVER.assia-inc.com:8080/expresse/services/realtime.realtimeHttpSoap11Endpoint/ ) > t2-response.xml

```

#### Expected
1. All new fields are returned (except `realtime.dcpc.statuscode.layer2` and `layer2.state.code`).

#### Result
1. (/)
```sh
grep 'layer2.state<' t2-response.xml
        <ax29:fieldNames>layer2.state</ax29:fieldNames>
```
1. (/)
```sh
grep 'layer2.state.code<' t2-response.xml
```
In DSLE-22396 it was already clarified that this field is finally not returned.
1. (/)
```sh
grep 'layer2.speed<' t2-response.xml
        <ax29:fieldNames>layer2.speed</ax29:fieldNames>
```
1. (/)
```sh
grep 'layer2.speed_configured<' t2-response.xml
        <ax29:fieldNames>layer2.speed_configured</ax29:fieldNames>
```
1. (/)
```sh
grep 'layer2.duplex_mode<' t2-response.xml
        <ax29:fieldNames>layer2.duplex_mode</ax29:fieldNames>
```
1. (/)
```sh
grep 'layer2.duplex_mode.code<' t2-response.xml
        <ax29:fieldNames>layer2.duplex_mode.code</ax29:fieldNames>
```
1. (/)
```sh
grep 'layer2.duplex_mode_configured<' t2-response.xml
        <ax29:fieldNames>layer2.duplex_mode_configured</ax29:fieldNames>
```
1. (/)
```sh
grep 'layer2.duplex_mode_configured.code<' t2-response.xml
        <ax29:fieldNames>layer2.duplex_mode_configured.code</ax29:fieldNames>
```
1. (/)
```sh
grep 'realtime.dcpc.statuscode.layer2<' t2-response.xml
```

{color:green}PASS{color}
