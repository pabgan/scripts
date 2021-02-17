### VIM macros
0ce##jd7j
 - Clean header of every test imported from a @adelacruz sql file 

0Wi<( sort €ü€krE€kbEa ) <( sortA )
 - sort files

###
prev_sltp='../../5.5.2.0/sltp'

## Test 2.5.1.1

SELECT dcpc_util.CONNECTIVITY_CHECK(dslam_name) 
FROM dslam_info 
WHERE status = 0 order by 1;

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

## 3.8
```sh

diff ../../5.5.2.0/sltp/output_test_3.8.1.dat output_test_3.8.1.dat

diff ../../5.5.2.0/sltp/output_test_3.8.2.1.dat output_test_3.8.2.1.dat

diff ../../5.5.2.0/sltp/output_test_3.8.2.2.dat output_test_3.8.2.2.dat

diff ../../5.5.2.0/sltp/output_test_3.8.2.3.dat output_test_3.8.2.3.dat

diff ../../5.5.2.0/sltp/output_test_3.8.2.4.1.dat output_test_3.8.2.4.1.dat

diff ../../5.5.2.0/sltp/output_test_3.8.2.5.dat output_test_3.8.2.5.dat

diff ../../5.5.2.0/sltp/output_test_3.8.2.6.dat output_test_3.8.2.6.dat

diff <( sort ../../5.5.2.0/sltp/output_test_3.8.2.7.dat ) <( sort output_test_3.8.2.7.dat )

diff ../../5.5.2.0/sltp/output_test_3.8.2.8.0.dat output_test_3.8.2.8.0.dat

diff ../../5.5.2.0/sltp/output_test_3.8.2.8.dat output_test_3.8.2.8.dat

diff ../../5.5.2.0/sltp/output_test_3.8.2.9.dat output_test_3.8.2.9.dat

```

----
## Test 3.9
```sh

diff ../../5.5.2.0/sltp/output_test_3.9.1.dat output_test_3.9.1.dat

diff ../../5.5.2.0/sltp/output_test_3.9.2.dat output_test_3.9.2.dat

diff ../../5.5.2.0/sltp/output_test_3.9.3.1.dat output_test_3.9.3.1.dat

diff <( sort ../../5.5.2.0/sltp/output_test_3.9.3.3.dat ) <( sort output_test_3.9.3.3.dat )

```

----
## Test 3.10

----
## Test 3.13
```sh

diff ../../5.5.2.0/sltp/output_test_3.13.2.dat output_test_3.13.2.dat

diff ../../5.5.2.0/sltp/output_test_3.13.3.dat output_test_3.13.3.dat

```

----
## Test 3.14
```sh

for f in $( ls output_test_3.14.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

### Test 3.14.2.2
```sql

SELECT DISTINCT a.dslam, line_id, max(date_performed)
FROM adsl_pe_est_sl_all a
  LEFT JOIN profile_change_record using(line_id)
  WHERE a.stability=9
  AND TRUNC(estimation_date)='13-FEB-21'
  group by a.dslam, line_id
  ORDER BY 1,2,3;

```

### Test 3.14.2.2
```sql

SELECT a.LINE_ID, MAX(date_performed)
FROM adsl_pe_po_trigger a 
  LEFT JOIN profile_change_record b
      ON (a.line_id=b.line_id AND date_performed<trunc(sysdate)) 
      WHERE request_code=793 AND estimation_date>=trunc(sysdate-2)
      GROUP BY a.LINE_ID 
      order by 2;

```

### Test 3.15.6
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


----
## Test 3.21
```sh

diff ../../5.5.2.0/sltp/output_test_3.21.1.dat output_test_3.21.1.dat

diff <( sort ../../5.5.2.0/sltp/output_test_3.21.2.dat ) <( sort output_test_3.21.2.dat )

diff <( sort ../../5.5.2.0/sltp/output_test_3.21.3.1.dat ) <( sort output_test_3.21.3.1.dat )

diff ../../5.5.2.0/sltp/output_test_3.21.3.2.dat output_test_3.21.3.2.dat

diff <( sort ../../5.5.2.0/sltp/output_test_3.21.4.dat | tr -s ' ' | cut -d' ' -f1,2,3 ) <( sort output_test_3.21.4.dat | tr -s ' ' | cut -d' ' -f1,2,3 )

diff ../../5.5.2.0/sltp/output_test_3.21.4.1.dat output_test_3.21.4.1.dat

```

----
## Test 3.25
```sh

for f in $( ls output_test_3.25.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.26
```sh

for f in $( ls output_test_3.26.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.27
```sh

for f in $( ls output_test_3.27.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.28
```sh

for f in $( ls output_test_3.28.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.30
```sh

for f in $( ls output_test_3.30.* ); do
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

napi.sh submitRequest ./PROFILE_RECONCILIATION.xml | xmllint --format - > output_test_3.30.3.xml

```

----
## Test 3.31
```sh

for f in $( ls output_test_3.31.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## Test 3.32
```sh

for f in $( ls output_test_3.32.* ); do
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
## Test 3.34
```sh

for f in $( ls output_test_3.34.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```


----
## Test 3.35
```sh

for f in $( ls output_test_3.35.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

### 3.35.1
```sql

update adsl_pe_est_sl_latest set ds_synch_rate=1000
  where line_id='00040411';

select line_id from v_port_reset_candidates;

commit;

```
```sh
ant -f ~/install/server/build.xml pe restart -Dparam="-target portResetModules"
```
```sql

SELECT line_id, request_date
FROM port_reset_request_history
WHERE request_date > sysdate-2
order by request_date;

SELECT line_id, action, date_performed, status_code
FROM manage_port_status_results
where date_performed>sysdate-2
order by date_performed;

```

----
## Test 3.36
```sh

for f in $( ls output_test_3.36.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```


----
## Test 3.37
```sh

for f in $( ls output_test_3.37.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```


----
## Test 3.38
```sh

for f in $( ls output_test_3.38.* ); do
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

for f in $( ls output_test_3.39.* ); do
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
