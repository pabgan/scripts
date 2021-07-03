### VIM macros
0ce##jd7j
 - Clean header of every test imported from a @adelacruz sql file 

0Wi<( sort €ü€krE€kbEa ) <( sortA )
 - sort files

###

prev_sltp='../../../21.1.0/sltp/results'

----
## Test 2.5.1.1

SELECT dcpc_util.CONNECTIVITY_CHECK(dslam_name) 
FROM dslam_info 
WHERE status = 0 order by 1;

----
## 3.5
```sql

SELECT OBJECT_NAME,OBJECT_TYPE  FROM user_objects WHERE status='INVALID';

OBJECT_NAME               	OBJECT_TYPE      
--------------------------	-----------------
MV_SR_PER_LINE            	MATERIALIZED VIEW
V_LINE_CARD_INFO_LATEST_PM	MATERIALIZED VIEW

SELECT count(*) FROM MV_SR_PER_LINE;
SELECT count(*) FROM V_LINE_CARD_INFO_LATEST_PM;

exec DBMS_SNAPSHOT.REFRESH('MV_SR_PER_LINE','c');

exec DBMS_SNAPSHOT.REFRESH('V_LINE_CARD_INFO_LATEST_PM','c');

```

----
## 3.8
```sh

test='3.8'
for f in $( ls output_test_$test.* ); do
	echo "$f"
	echo "------------------"
	diff <(sort $prev_sltp/$f) <(sort $f) ;
done

```
### 3.8.2.3 Algo cambió @adelacruz en la query y lo ha jodido
```sh

diff <(sed -E 's/\s+/;/g' $prev_sltp/output_test_3.8.2.3.dat ) <(sed -E 's/\s+/;/g' output_test_3.8.2.3.dat )

```

----
## Test 3.9
```sh

test='3.9.1'
diff $prev_sltp/output_test_$test.dat output_test_$test.dat

test='3.9.2'
diff $prev_sltp/output_test_$test.dat output_test_$test.dat

test='3.9.3.1'
diff $prev_sltp/output_test_$test.dat output_test_$test.dat

test='3.9.3.3'
diff <( sort $prev_sltp/output_test_$test.dat ) <( sort output_test_$test.dat )

```

----
## Test 3.10
```sh

diff $prev_sltp/output_test_3.10.dat output_test_3.10.dat

```

----
## Test 3.12
```sh

# compare the files without date info, only request name and hour of execution
test='3.12.4'
diff <( cut -d' ' -f3- $prev_sltp/output_test_$test.dat | sed -E 's/(_?[0-9]+)+.dat.bk//' | sort ) <( cut -d' ' -f3- output_test_$test.dat | sed -E 's/(_?[0-9]+)+.dat.bk//' | sort )

```

----
## Test 3.13
```sql

SELECT dslam,status_code,COUNT(1) as LINE_IDS
FROM dcpc_status_code
WHERE collection_date >=TRUNC(sysdate-1) AND collection_date<TRUNC(sysdate)
GROUP BY dslam, status_code
ORDER BY dslam, status_code ASC;

select * from v_ports
	where dslam='ISAM_PON'
		and port like '%17%';

select port from v_ports
	where dslam='ISAM_PON';

select distinct(line_id) from DCPC_STATUS_CODE
	where dslam='ISAM_PON'
		and status_code='11909';

select trunc(collection_date), dslam, status_code, count(*)
	from dcpc_status_code
	where status_code like '119__'
group by trunc(collection_date), dslam, status_code
order by 1, 2, 3;

select distinct collection_date, status_code
	from dcpc_status_code
	where status_code like '119__';

select d.port, d.line_id, d.dslam, d.collection_date, d.status_code, v.service_product, v.status
	from dcpc_status_code d
	full outer join v_ports v
		on d.dslam=v.dslam and d.port=v.port
	where status_code like '119__'
		and collection_date>trunc(sysdate-3)
order by dslam, status_code;

select * from DCPC_STATUS_CODE
	where dslam='ISAM_PON'
		and port='1-1-1-1#1'
		and status_code like '119__'
order by collection_date;

```
```sh

test='3.13.2'
diff $prev_sltp/output_test_$test.dat output_test_$test.dat

# compare files first removing non foreseable manual collections
# | <600 |Individual requests|Manual. Not foreseable|
# | 600  |`BULK_POP_O SUCCESS`|One for each line and collection. `BULK_PER_TONE` collection generates one `BULK_POP_O`|
# | 700  |`BULK_POP_P SUCCESS`| |One for each line and collection.|
# | 800  |`BULK_VENDOR_ID SUCCESS`|One for each line and collection.|
# | 900  |`VENDOR_ID SUCCESS` |  |
# | 1000 |`POP_ALL SUCCESS`   |Manual. Not foreseable|
# | 1100|`PER_TONE_DATA SUCCESS`   |Manual. Not foreseable|
# | 1200 |`BULK_PER_TONE_DATA SUCCESS`|One for each line|
# | 1300 |`BULK_PROFILE_COLLECTION SUCCESS`|One for each profile in the DSLAM and collection. It usually is issued once a week|
# | 1400 |`MANAGE_PORT_STATUS SUCCESS`|Port reset |
# | 1800 |`CONNECTIVITY_CHECK SUCCESS`|Manual. Not foreseable.|
# |10100 |`PON_POP_O SUCCESS'|Manual. Not foreseable.|

test='3.13.3'
excluded_codes=' [1-5].. | 10.. | 11.. | 18.. | 101.. | 102.. |'
diff <( grep -vE $excluded_codes $prev_sltp/output_test_$test.dat ) <( grep -vE $excluded_codes output_test_$test.dat )

select * from DCPC_STATUS_CODE
	where status_code like '24__'
		and collection_date>sysdate-7;

```

----
## Test 3.14
```sh

test='3.14'
for f in $( ls output_test_$test.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```
```sql

-- Test 3.14.2.2
-- Lines with poor stability
SELECT TRUNC(estimation_date) AS est_date, count(*) AS samples 
FROM adsl_pe_est_sl_all 
WHERE stability=9 and estimation_date>sysdate-20
GROUP BY TRUNC(estimation_date) 
ORDER BY TRUNC(estimation_date);

-- Test 3.14.3.2
-- PO trigger status
SELECT request_code as status_code, COUNT(1) AS samples, CODE_STRING as DESCRIPTION
FROM adsl_pe_po_trigger
left join STATUS_CODES_DESCRIPTIONS
on (CODE_NUMBER=request_code and CODE_TYPE='PE_PO_TRIGGER')
WHERE estimation_date>=TRUNC(sysdate-1)
GROUP BY request_code, CODE_STRING
ORDER BY request_code, CODE_STRING;

select count(*) from (SELECT a.LINE_ID, MAX(date_performed)
FROM adsl_pe_po_trigger a 
  LEFT JOIN profile_change_record b
      ON (a.line_id=b.line_id AND date_performed<trunc(sysdate)) 
WHERE request_code=793 AND estimation_date>=trunc(sysdate-1)
GROUP BY a.LINE_ID 
order by 2);

```

----
## Test 3.15
### 6
```sql

-- Troubleshooting
SELECT DISTINCT
	service_type,
	original_profile,
	max_rate_ds AS ds_rate_prof,
	max_rate_us AS us_rate_prof,
	ds_max_rate AS max_ds_rate_sp,
	ds_min_rate AS min_ds_rate_sp,
	us_max_rate AS max_us_rate_sp,
	us_min_rate AS min_us_rate_sp
FROM PO_RECORD_LATEST 
	JOIN v_profiles ON original_profile = name
	JOIN CONFIG_SERVICE_PRODUCT ON service_product = service_type
WHERE status_code = 665
	and ( ds_max_rate < max_rate_ds
		or ds_min_rate > max_rate_ds
		or us_max_rate < max_rate_us 
		or us_min_rate > max_rate_us)
ORDER BY 1;

```

### 7
```sql

-- DS
select * from(select(case
when rp1.max_rate<=rp2.max_rate then 'RATE_INCREASE OR SAME'
else  'RATE_DECREASE'end) ds_rate_change,ds_stability_start
from po_state ps, line_profile lp1, line_profile lp2, rate_profile rp1, rate_profile rp2
where ps.original_profile = lp1.name and
ps.next_profile = lp2.name and lp1.rate_ds = rp1.name and
lp2.rate_ds = rp2.name and ps.original_profile!=ps.next_profile and
original_profile!='INIT_UNKN' and next_profile!='INIT_UNKN')
pivot (count(ds_stability_start)
for ds_stability_start in (0,1,2,3,9));


select count(*) from (select ps.line_id||','||rp2.max_rate||','||DS_MABR_ESTIMATED2||','||service_type
from po_state  ps, line_profile lp1, line_profile lp2, rate_profile rp1, rate_profile rp2, adsl_pe_est_sl_latest al
where ps.original_profile = lp1.name
	and ps.next_profile = lp2.name
	and lp1.rate_ds = rp1.name
	and lp2.rate_ds = rp2.name
	and ps.original_profile!=ps.next_profile
	and original_profile!='INIT_UNKN'
	and next_profile!='INIT_UNKN'
	and rp1.max_rate>rp2.max_rate
	and ps.line_id=al.line_id);

-- US
select * from(
	select(case
		when rp1.max_rate<=rp2.max_rate
			then 'RATE_INCREASE OR SAME'
			else  'RATE_DECREASE'
		end) us_rate_change,
		us_stability_start
from po_state ps, line_profile lp1, line_profile lp2, rate_profile rp1, rate_profile rp2
where ps.original_profile = lp1.name
	and ps.next_profile = lp2.name
	and lp1.rate_us = rp1.name
	and lp2.rate_us = rp2.name
	and ps.original_profile!=ps.next_profile
	and original_profile!='INIT_UNKN'
	and next_profile!='INIT_UNKN')
pivot (count(us_stability_start)
for us_stability_start in (0,1,2,3,9));

select count(*) from (select ps.line_id||','||rp2.max_rate||','||US_MABR_ESTIMATED1||','||service_type from po_state  ps, line_profile lp1, line_profile lp2, rate_profile rp1, rate_profile rp2, adsl_pe_est_sl_latest al
where ps.original_profile = lp1.name and ps.next_profile = lp2.name and lp1.rate_us = rp1.name and lp2.rate_us = rp2.name and ps.original_profile!=ps.next_profile and original_profile!='INIT_UNKN' and next_profile!='INIT_UNKN' and  rp1.max_rate>rp2.max_rate and ps.line_id=al.line_id);

```

----
## Test 3.16
```sql

compute sum of samples on report
break on report
SELECT status_code, COUNT(*) as SAMPLES,  CODE_STRING as DESCRIPTION
FROM profile_change_record
left join STATUS_CODES_DESCRIPTIONS on (CODE_NUMBER=status_code+300 and CODE_TYPE='DcPc')
WHERE date_performed > sysdate-1
GROUP BY status_code, code_string ORDER BY status_code;

```

----
## Test 3.17
```sql

-- select line
select line_id, dslam, service_product from v_ports
	where technology='DSL'
		and line_id not in (select line_id from po_state);

```

----
## Test 3.21
```sh

test='3.21'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.24
```sh

test='3.24'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.25
```sh

test='3.25'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.26
```sql

-- select lines
select line_id, dslam, service_product
	from v_ports
	where technology='PON';

select * from pon_ont_info
	where line_id='9375550011';

select * from pon_pop_p
	where line_id='9375550011';

select trunc(collection_date), status_code, count(*)
	from DCPC_STATUS_CODE
	where dslam='ISAM_PON'
		and status_code like '119__'
		and collection_date>sysdate-30
group by trunc(collection_date), status_code
order by trunc(collection_date), status_code;

select * from V_PON_PE_ONT_INTERNAL
	where line_id='9375550011'
	AND (ESTIMATION_DATE >= '1615726311000') AND (ESTIMATION_DATE <= '1618318311000');

SELECT  LINE_ID, DSLAM, PORT, REQUEST_TYPE, RUN_DATE, ESTIMATION_DATE, POPO_COLLECTION_DATE, POPP_COLLECTION_DATE, STATUS_CODE, NEIGHBORHOOD_INFO, OLT_STATE, LINK_STATE, RANGE, FAULT, THROUGHPUT_REF_DATE, THROUGHPUT_INTERVAL_COUNTS, DS_BW_AVG, US_BW_AVG, DS_BW_SATURATION, US_BW_SATURATION, DS_BW_HOURLY, US_BW_HOURLY, DS_TOTAL_PKTS_AVG, US_TOTAL_PKTS_AVG, DS_UNICAST_PKTS_AVG, US_UNICAST_PKTS_AVG, DS_UNICAST_BW_HOURLY, US_UNICAST_BW_HOURLY, DS_BIT_ERROR_X1, DS_BIT_ERROR_X1_RAW, US_BIT_ERROR_X1, US_BIT_ERROR_X1_RAW, LINK_QUALITY, LINK_QUALITY_REASON, DS_ERROR_COUNTERS, US_ERROR_COUNTERS, DS_ATTENUATION, US_ATTENUATION, ONT_LASER_HEALTH, ONT_LASER_HEALTH_RAW, OLT_LASER_HEALTH, OLT_LASER_HEALTH_RAW, ETHERNET_STATE, ETHERNET_STATE_RAW, DS_BW, US_BW, DS_BW_PERCENTILE, US_BW_PERCENTILE, SHORT_TERM_LINK_QUALITY, SHORT_TERM_LINK_QUALITY_REASON, AVERAGE_RETRAIN, SHORT_TERM_AVERAGE_RETRAIN, DS_RX_POWER, US_RX_POWER, DS_CHANGE_FROM_BASELINE, US_CHANGE_FROM_BASELINE, DS_CHANGE_FROM_BASELINE_DET, US_CHANGE_FROM_BASELINE_DET, DS_BIT_ERROR_DAILY, DS_BIT_ERROR_DAILY_RAW, US_BIT_ERROR_DAILY, US_BIT_ERROR_DAILY_RAW, LAYER2_COLLECTION_DATE, ETHERNET_SPEED, ETHERNET_DUPLEX, ETHERNET_OP_STATE, ETHERNET_OP_STATE_REASON, FAULT_LOCATION, FAULT_ELEMENT_NAME, FAULT_STATUS_CODE, FAULT_CONFIDENCE, FAULTY_LINES FROM V_PON_PE_ONT_INTERNAL WHERE (LINE_ID = '937555001') AND (ESTIMATION_DATE >= '161572631100') AND (ESTIMATION_DATE <= '1618318311000') ORDER BY ESTIMATION_DATE;

SELECT distinct ESTIMATION_DATE FROM PON_PE_SR_SL WHERE (LINE_ID = '9375550011') AND (ESTIMATION_DATE >=sysdate-7) AND (NUM_DAYS = 7) ORDER BY ESTIMATION_DATE;

SELECT LINE_CARD, TYPE, VERSION, COLLECTION_DATE, NO_OF_PORTS, STATUS, VCE_ID FROM LINE_CARD_INFO_LATEST WHERE (LINE_CARD = '1-1-1') AND (DSLAM_NAME = 'ISAM_PON');

select * from v_ports where dslam='ISAM_PON';

select port||','||collection_date||','||status_code
	from dcpc_status_code
	where ((dslam='HUAWEI5600_PON' and port='0-0-0#0') or (dslam='ISAM_PON' and port='1-1-1-1#1'))
		and collection_date>sysdate-1 
		and status_code not in (10700,10100,10800,11400,10900,10200)
order by 1;

select * from port_info_history

```
```sh

test='3.26'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.27
```sh

test='3.27'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.28
```sh

test='3.28'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.29
```sql

SELECT distinct dslam FROM v_dslams where technology='PON';

for line in 9485550100 0000510001; do
	# block
	sed "s/{operation}/block/" PON_MANAGE_ONT_STATUS.xml | sed "s/{line_id}/"$line"/" > "$line"-block.xml
	napi.sh submitRequest "$line"-block.xml | xmllint --format - > "$line"-block_result.xml

	# reset
	sed "s/{operation}/reset/" PON_MANAGE_ONT_STATUS.xml | sed "s/{line_id}/"$line"/" > "$line"-reset.xml
	napi.sh submitRequest "$line"-reset.xml | xmllint --format - > "$line"-reset1_result.xml

	# unblock
	sed "s/{operation}/unblock/" PON_MANAGE_ONT_STATUS.xml | sed "s/{line_id}/"$line"/" > "$line"-unblock.xml
	napi.sh submitRequest "$line"-unblock.xml | xmllint --format - > "$line"-unblock_result.xml

	# reset
	napi.sh submitRequest "$line"-reset.xml | xmllint --format - > "$line"-reset2_result.xml

	# remote_reset
	sed "s/{operation}/remote_reset/" PON_MANAGE_ONT_STATUS.xml | sed "s/{line_id}/"$line"/" > "$line"-remote_reset.xml
	napi.sh submitRequest "$line"-remote_reset.xml | xmllint --format - > "$line"-remote_reset_result.xml
done

```
```sh


```

----
## Test 3.30
```sh

test='3.30'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

```sql

select A.line_id, A.dslam, apo.profile, A.field_value as default_profile, a.service_product
 from
   (select line_id, dslam, field_value, service_product
	from v_ports_line_card_data vp
	inner join service_equipment_config sec
	 on (vp.service_product=sec.service_type
		 and ((vp.dslam_type=sec.dslam_type and vp.card_type=sec.line_CARD_TYPE) 
			  or sec.dslam_type='UNKNOWN'))
	where technology like '%DSL%'
	 and status=0
	 and field_name='po.default.profile.for.service.product') A
 join adc_pop_o_latest apo
  on (a.line_id = apo.tn)
 where apo.profile != A.field_value
	and line_id not in (select line_id from po_state);


```
```sh

sed -i 's/#line_id#/000009020/' profile_change-default.xml

napi.sh submitRequest ./profile_change-default.xml | xmllint --format - > output_test_3.30.3.xml
xclip < output_test_3.30.3.xml

```

----
## Test 3.31
```sh

test='3.31'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.32
```sh

test='3.32'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

### 3.32.1.9
```sql

select trunc(COLLECTION_DATE) as est_date,
	count(distinct line_id) as line_ids
from PON_ALARM
where COLLECTION_DATE>sysdate-20
group by trunc(COLLECTION_DATE)
order by trunc(COLLECTION_DATE);

select *
from v_ports where pe_enabled=1 and status=0 and technology='PON'
	and line_id not in (
select distinct line_id
from PON_ALARM
where COLLECTION_DATE>sysdate-4);

```

----
## Test 3.33
```sh

test='3.33'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.34
```sh

test='3.34'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```
### Test 3.34.3
```sql

SELECT DISTINCT dslam_type, line_card_type as CARD_TYPE, line_card_version as CARD_VERSION,
  CASE WHEN ((line_card_type = card_type) OR
             (line_card_type = 'UNKNOWN')) THEN 'PM' ELSE NULL END as PM
FROM po_service_type_map
LEFT JOIN supported_card_types_po_pm
  ON (
       (
        (line_card_type = card_type)
        OR (line_card_type = 'UNKNOWN')
       )
     AND
       (
        (line_card_version='UNKNOWN')
        OR (dslam_version=line_card_version)
       )
    )
WHERE (cpe_version_number='PM' or cpe_vendor_id='PM')
ORDER BY 1;

```

----
## Test 3.35
```sh

test='3.35'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

### 3.35.1
```sql

select text from user_views
	where view_name='V_PORT_RESET_CANDIDATES';

SELECT
       PI.LINE_ID,
       PI.DSLAM,
       PI.PORT,
       SYSDATE AS REQUEST_DATE,
    P.COLLECTION_DATE AS DATA_COLLECTION_DATE,
    PI.SERVICE_PRODUCT,
    P.PROFILE,
    MAXRATEDS as ESTIMATED_MAX_RATE_DS,
    MAXRATEUS as ESTIMATED_MAX_RATE_US,
    CURRENTRATEDS as CURRENT_RATE_DS,
    CURRENTRATEUS as CURRENT_RATE_US,
    MARGINDS as MARGIN_DS,
    MARGINUS AS MARGIN_US,
    9 AS STABILITY,
    SYSTEMTYPE,
    'LOW_MABR' as REASON_FOR_RESET
 	FROM ADC_POP_O_LATEST P, V_PROFILES PROF, V_PORTS PI
     WHERE P.PROFILE = PROF.NAME
       AND P.TN = PI.LINE_ID
       AND P.COLLECTION_DATE > trunc(SYSDATE - 1)
--       AND (CURRENTRATEDS/MAX_RATE_DS < 0.75 AND MARGINDS > 16)
       AND TN NOT IN (SELECT LINE_ID FROM PO_STATE)
       AND PO_ENABLED = 1
       AND STATUS = 0;

update adsl_pe_est_sl_latest set ds_synch_rate=100000;

update adc_pop_o_latest set CURRENTRATEDS=10
where tn='0000030807';

select line_id from v_port_reset_candidates;

rollback;

commit;

```
```sh

ant -f ~/install/server/build.xml pe restart -Dparam="-target portResetModules"

!!! RESTART IT AFTERWARDS !!!

ant -f ~/install/server/build.xml pe restart

```
### Test 3.35.2.1
```sql

SELECT line_id, request_date
FROM port_reset_request_history
WHERE request_date > trunc(sysdate)
order by request_date;


```
### Test 3.35.2.2
```sql

SELECT line_id, action, date_performed, status_code
FROM manage_port_status_results
where date_performed> trunc(sysdate)
order by date_performed;


```
### Test 3.35.2.3
```sql

SELECT line_id, request_date FROM v_port_reset_lines;


```
### Test 3.35.3
```sql

select * from V_DR_SELECTIVE_PORT_RESET;

```
### Test 3.35.4
```sql

ALTER SESSION SET nls_date_format = 'yyyy/mm/dd hh24:mi:ss';
SELECT line_id, trunc(collection_date, 'MI') as DATE_PERFORMED, status_code, count(*) as SAMPLES
FROM dcpc_status_code
WHERE status_code LIKE '14__' AND collection_date>trunc(sysdate-1)
GROUP BY line_id, trunc(collection_date, 'MI'), status_code
ORDER BY 1;

```

----
## Test 3.36
```sh

test='3.36'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```


----
## Test 3.37
```sh

test='3.37'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```


----
## Test 3.38
```sh

test='3.38'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done


# Whitelist
cd ~/Workspace/tickets/QA-595/
./whitelist-provisioning.sh $CUSTOMER_DB $CUSTOMER_ENV.assia-inc.com

```


----
## Test 3.39
```sh

test='3.39'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.40
```sh

pushd ~/Repositorios/bookmarks/log_verification_tool
./run.sh
mv log_verification.log $CUSTOMER_DIR/sltp/
popd
