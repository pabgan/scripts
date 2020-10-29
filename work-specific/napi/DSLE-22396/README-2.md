Hi, @jmatias. Thanks for your help, but as I mentioned before I already tried to update the column as Miguel mentioned and it did not work. Anyway, as I mentioned in my previous comment, I only had to wait for a day to get results without doing any further modification.

----
Verified in **demo-b v5.7.0**.

```sh

SERVER=demo-b
ACTION='urn:login'
SESSIONID=$(xmllint --format <(curl --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --data @login.env http://$SERVER.assia-inc.com:8080/expresse/services/authentication.authenticationHttpSoap11Endpoint/ ) | sed -n -e  's/.\+sessionId>\(.\+\)<\/.\+/\1/p')

```

### Test 2: `getData` without `FIELDS` parameter
#### Steps
1. Make sure there is information.
	- First I had to provision the DSLAM using: `provision_odn_3splitters.sql`, `provision_odn.sql`, `simulator_dslam_info_provisioning.sql`, `simulator_dslam_info_snmpv2c_provisioning.sql` and `simulator_port_info_provisioning.sql`. Then I had to wait 24 hours for collections to happen.
	- Then I waited 24 hours for things to happen.
	- Then I modified the `OTHER` data.
```sql

update LAYER2_DATA 
set other='ALTERNATE_SOFTWARE_VERSION=J74.00.0001.G2;BATTERY_BACKUP=false;CLEI_CODE=BVL3AX7DTA;DESCRIPTION=1380 Troy S;HARDWARE_VERSION=D;MODE=dual;OMCC_VERSION=G_988_2011_Amd_1_Base;PART_NUMBER=1287702G1C;REGISTRATION_ID=0003010424;TRAFFIC_MANAGEMENT=priorityControlled' 
where LINE_ID='9875550011';

4 rows updated.

SQL> commit;

Commit complete.

```
1. Execute request.
```sh

ACTION='urn:getData' 
xmllint --format <( curl --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --header "cookie:JSESSIONID=$SESSIONID" --data @getData.env http://$SERVER.assia-inc.com:8080/expresse/services/pe_data.pe_dataHttpSoap11Endpoint/ ) > t2-response.xml

```

#### Expected
1. All new fields are returned.

#### Result
1. (/)
```sh
grep 'layer2.state<' t2-response.xml
            <ax253:key>layer2.state</ax253:key>
        <ax253:fieldNames>layer2.state</ax253:fieldNames>
```
1. (/)
```sh
grep 'layer2.speed<' t2-response.xml
            <ax253:key>layer2.speed</ax253:key>
        <ax253:fieldNames>layer2.speed</ax253:fieldNames>
```
1. (/)
```sh
grep 'layer2.speed_configured<' t2-response.xml
            <ax253:key>layer2.speed_configured</ax253:key>
        <ax253:fieldNames>layer2.speed_configured</ax253:fieldNames>
```
1. (/)
```sh
grep 'layer2.duplex_mode<' t2-response.xml
            <ax253:key>layer2.duplex_mode</ax253:key>
        <ax253:fieldNames>layer2.duplex_mode</ax253:fieldNames>
```
1. (/)
```sh
grep 'layer2.duplex_mode.code<' t2-response.xml
            <ax253:key>layer2.duplex_mode.code</ax253:key>
        <ax253:fieldNames>layer2.duplex_mode.code</ax253:fieldNames>
```
1. (/)
```sh
grep 'layer2.duplex_mode_configured<' t2-response.xml
            <ax253:key>layer2.duplex_mode_configured</ax253:key>
        <ax253:fieldNames>layer2.duplex_mode_configured</ax253:fieldNames>
```
1. (/)
```sh
grep 'layer2.duplex_mode_configured.code<' t2-response.xml
            <ax253:key>layer2.duplex_mode_configured.code</ax253:key>
        <ax253:fieldNames>layer2.duplex_mode_configured.code</ax253:fieldNames>
```

{color:green}PASS{color}

----
### Test 3: `getData` with `FIELDS` parameter
#### Steps
1. Make sure there is information.
1. Execute request.
```sh

ACTION='urn:getData' 
xmllint --format <( curl --header "Content-Type: text/xml;charset=UTF-8" --header "SOAPAction:$ACTION" --header "cookie:JSESSIONID=$SESSIONID" --data @getData-fields.env http://$SERVER.assia-inc.com:8080/expresse/services/pe_data.pe_dataHttpSoap11Endpoint/ ) > t3-response.xml

```

#### Expected
1. Only requested fields and additional fields are returned.
```sh
grep -A1 FIELDS getData-fields.env
            <xsd:type>FIELDS</xsd:type>
            <xsd:value>layer2.speed_configured, layer2.duplex_mode, layer2.duplex_mode.code, layer2.duplex_mode_configured, layer2.duplex_mode_configured.code, lineinfo.port</xsd:value>
```

#### Result
1. (/)
```sh
cat t3-response.xml
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <ns:getDataResponse xmlns:ns="http://ws.api.report.dslo.assia.com">
      <ns:return xmlns:ax253="http://model.napi.dslo.assia.com/xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ax253:ResponseDataBean">
        <ax253:entries xsi:type="ax253:ResponseDataEntry">
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.additional.clei_code</ax253:key>
            <ax253:value>BVL3AX7DTA</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.additional.omcc_version</ax253:key>
            <ax253:value>G_988_2011_Amd_1_Base</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.duplex_mode.code</ax253:key>
            <ax253:value>-1</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.duplex_mode</ax253:key>
            <ax253:value>INVALID</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.duplex_mode_configured</ax253:key>
            <ax253:value>AUTO</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.additional.alternate_software_version</ax253:key>
            <ax253:value>J74.00.0001.G2</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.additional.hardware_version</ax253:key>
            <ax253:value>D</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.duplex_mode_configured.code</ax253:key>
            <ax253:value>0</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.additional.mode</ax253:key>
            <ax253:value>dual</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.additional.part_number</ax253:key>
            <ax253:value>1287702G1C</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.additional.battery_backup</ax253:key>
            <ax253:value>false</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.additional.traffic_management</ax253:key>
            <ax253:value>priorityControlled</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.additional.description</ax253:key>
            <ax253:value>1380 Troy S</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.speed_configured</ax253:key>
            <ax253:value>0</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>lineinfo.port</ax253:key>
            <ax253:value>1-1-1-4#1-g1</ax253:value>
          </ax253:values>
          <ax253:values xsi:type="ax253:ValueMappingBean">
            <ax253:key>layer2.additional.registration_id</ax253:key>
            <ax253:value>0003010424</ax253:value>
          </ax253:values>
        </ax253:entries>
        <ax253:fieldNames>layer2.additional.clei_code</ax253:fieldNames>
        <ax253:fieldNames>layer2.additional.omcc_version</ax253:fieldNames>
        <ax253:fieldNames>layer2.duplex_mode.code</ax253:fieldNames>
        <ax253:fieldNames>layer2.duplex_mode</ax253:fieldNames>
        <ax253:fieldNames>layer2.duplex_mode_configured</ax253:fieldNames>
        <ax253:fieldNames>layer2.additional.alternate_software_version</ax253:fieldNames>
        <ax253:fieldNames>layer2.additional.hardware_version</ax253:fieldNames>
        <ax253:fieldNames>layer2.duplex_mode_configured.code</ax253:fieldNames>
        <ax253:fieldNames>layer2.additional.mode</ax253:fieldNames>
        <ax253:fieldNames>layer2.additional.part_number</ax253:fieldNames>
        <ax253:fieldNames>layer2.additional.battery_backup</ax253:fieldNames>
        <ax253:fieldNames>layer2.additional.traffic_management</ax253:fieldNames>
        <ax253:fieldNames>layer2.additional.description</ax253:fieldNames>
        <ax253:fieldNames>layer2.speed_configured</ax253:fieldNames>
        <ax253:fieldNames>lineinfo.port</ax253:fieldNames>
        <ax253:fieldNames>layer2.additional.registration_id</ax253:fieldNames>
        <ax253:message xsi:nil="true"/>
        <ax253:statusCode>0</ax253:statusCode>
      </ns:return>
    </ns:getDataResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

{color:green}PASS{color}
