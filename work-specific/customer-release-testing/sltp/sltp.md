
3.6	Database Partitioning
Status: PASS
3.7	DSLAM Support (via DB)
Status: PASS

3.11	Software Installation
Status: PASS
3.20	Service Recommendation
Status:
3.22	Amendment to Running PE scenario
3.23	Real Time Port Reset New GUI
Status:
3.41	Review release notes
Status:
3.42	Log Verification
Status:
4	Customer specific Test Cases
4.1	Customer specific  -  Oracle Wallets Connectivity
Status:
4.2	Customer specific - Profile Change for bonded lines
Status:
4.3	Customer specific  -  PEN Test specific checks
Status:
4.4	Customer specific  -  Scheduled Collection Reports
Status:
4.5	Customer specific  -  Realtime Traffic
Status:
4.6	Customer specific - NDS integration for Old and New GUI
Status:
4.7	Customer specific  -  DSLAM description / version locator
Status:
4.8	Customer specific  -  ADSL to VDSL Migration
Status:
4.9	Customer specific  -  PO Control
Status:
4.10	Customer specific  -  AXIONE collections files load
Status: N/A
4.11	Customer specific  -  PO_COMPLETION_NOTIFICATION
Status:
4.12	Customer specific  -  stm distribution

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
## 3.5	Tablespace Version
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
## 3.8	SERVICE_PRODUCT Support (via DB)
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
## 3.9	Schedules Verification
```sh

test='3.9'
for f in $( ls output_test_$test.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```
### 3.9.3
```sh

f='output_test_3.9.3.3.dat'
diff <(sort $prev_sltp/$f | cut -d' ' -f 1) <(sort $f | cut -d' ' -f 1) ;

```

----
## 3.10	Feature Control
```sh

test='3.10'
for f in $( ls output_test_$test.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## 3.12	Data Collection
```sh

# compare the files without date info, only request name and hour of execution
test='3.12.4'
diff <( cut -d' ' -f3- $prev_sltp/output_test_$test.dat | sed -E 's/(_?[0-9]+)+.dat.bk//' | sort ) <( cut -d' ' -f3- output_test_$test.dat | sed -E 's/(_?[0-9]+)+.dat.bk//' | sort )

2d1
< 00:00 1DSLAMs_BULK_OID
5c4,5
< 00:01 1DSLAMs_BULK_OID
---
> 00:00 Query_BULK_OID
> 00:01 Query_BULK_OID
9c9
< 00:03 1DSLAMs_BULK_OID
---
> 00:03 Query_BULK_OID
13a14
> 00:30 Query_POP_O
18d18
< 02:00 profile_change
35c35
< 02:15 profile_change
---
> 02:14 profile_change
41a42,45
> 02:22 profile_change
> 02:23 profile_change
> 02:24 profile_change
> 02:24 profile_change
46d49
< 03:00 1DSLAMs_BULK_OID
49c52,53
< 03:01 1DSLAMs_BULK_OID
---
> 03:00 Query_BULK_OID
> 03:01 Query_BULK_OID
53c57
< 03:03 1DSLAMs_BULK_OID
---
> 03:03 Query_BULK_OID
69a74
> 04:30 Query_POP_O
71a77,78
> 05:00 11DSLAMs_BULK_LINE_STATUS
> 05:00 3DSLAMs_BULK_PON_LINE_STATUS
74a82
> 05:15 Query_PROFILE_CREATION
80d87
< 06:00 1DSLAMs_BULK_OID
84c91,92
< 06:01 1DSLAMs_BULK_OID
---
> 06:00 Query_BULK_OID
> 06:01 Query_BULK_OID
88c96
< 06:03 1DSLAMs_BULK_OID
---
> 06:03 Query_BULK_OID
102a111
> 08:00 3DSLAMs_BULK_PON_ALL
108a118
> 08:30 Query_POP_O
111d120
< 09:00 1DSLAMs_BULK_OID
114c123,124
< 09:01 1DSLAMs_BULK_OID
---
> 09:00 Query_BULK_OID
> 09:01 Query_BULK_OID
118c128
< 09:03 1DSLAMs_BULK_OID
---
> 09:03 Query_BULK_OID
127a138
> 11:00 11DSLAMs_BULK_LINE_STATUS
128a140
> 11:00 3DSLAMs_BULK_PON_LINE_STATUS
133d144
< 12:00 1DSLAMs_BULK_OID
137c148,149
< 12:01 1DSLAMs_BULK_OID
---
> 12:00 Query_BULK_OID
> 12:01 Query_BULK_OID
141c153
< 12:03 1DSLAMs_BULK_OID
---
> 12:03 Query_BULK_OID
144a157
> 12:30 Query_POP_O
155d167
< 15:00 1DSLAMs_BULK_OID
158c170,171
< 15:01 1DSLAMs_BULK_OID
---
> 15:00 Query_BULK_OID
> 15:01 Query_BULK_OID
162c175
< 15:03 1DSLAMs_BULK_OID
---
> 15:03 Query_BULK_OID
168a182
> 16:30 Query_POP_O
169a184,186
> 17:00 11DSLAMs_BULK_LINE_STATUS
> 17:00 3DSLAMs_BULK_PON_ALL
> 17:00 3DSLAMs_BULK_PON_LINE_STATUS
173d189
< 18:00 1DSLAMs_BULK_OID
176c192,193
< 18:01 1DSLAMs_BULK_OID
---
> 18:00 Query_BULK_OID
> 18:01 Query_BULK_OID
180c197
< 18:03 1DSLAMs_BULK_OID
---
> 18:03 Query_BULK_OID
191d207
< 20:00 3DSLAMs_BULK_PON_ALL
197a214
> 20:30 Query_POP_O
201d217
< 21:00 1DSLAMs_BULK_OID
205c221,222
< 21:01 1DSLAMs_BULK_OID
---
> 21:00 Query_BULK_OID
> 21:01 Query_BULK_OID
209c226
< 21:03 1DSLAMs_BULK_OID
---
> 21:03 Query_BULK_OID
215a233
> 22:00 11DSLAMs_BULK_LINE_STATUS
217a236,237
> 22:00 3DSLAMs_BULK_PON_LINE_STATUS
> 22:01 profile_change_mismatch
219a240
> 22:21 profile_change_mismatch
221a243
> 22:31 profile_change_mismatch

```

----
## 3.13	Uploading Data into Oracle
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

16,18c16,18
< ISAM7360_PON                     ISAM7360_PON               16          1
< OH_BOGOTA_MA5800_PON             MA5800_PON                 20          2
< OH_ZTEC300MPON                   ZTE_PON                    16          1
---
> ISAM7360_PON                     ISAM7360_PON               32          2
> OH_BOGOTA_MA5800_PON             MA5800_PON                 40          2
> OH_ZTEC300MPON                   ZTE_PON                    32          2
```
compare files first removing non foreseable manual collections
| code | type | Comment |
|------|------|---------|
| <600 |Individual requests|Manual. Not foreseable|
| 600  |`BULK_POP_O SUCCESS`|One for each line and collection. `BULK_PER_TONE` collection generates one `BULK_POP_O`|
| 700  |`BULK_POP_P SUCCESS`| |One for each line and collection.|
| 800  |`BULK_VENDOR_ID SUCCESS`|One for each line and collection.|
| 900  |`VENDOR_ID SUCCESS` |  |
| 1000 |`POP_ALL SUCCESS`   |Manual. Not foreseable|
| 1100|`PER_TONE_DATA SUCCESS`   |Manual. Not foreseable|
| 1200 |`BULK_PER_TONE_DATA SUCCESS`|One for each line|
| 1300 |`BULK_PROFILE_COLLECTION SUCCESS`|One for each profile in the DSLAM and collection. It usually is issued once a week|
| 1400 |`MANAGE_PORT_STATUS SUCCESS`|Port reset |
| 1800 |`CONNECTIVITY_CHECK SUCCESS`|Manual. Not foreseable.|
| 3000 | `PORT_CONFIGURATION SUCCESS` |PORT_CONFIGURATION Successful.|
| 3200 | `BULK_LINE_STATUS SUCCESS` |BULK_LINE_STATUS Successful|
|10100 |`PON_POP_O SUCCESS` |Manual. Not foreseable.|
|11900 | `BULK_PON_LINE_STATUS SUCCESS` | |

```sh

test='3.13.3'
excluded_codes=' [1-5]00 | 1000 | 1100 | 1800 | 10100 | 10200 '
diff <( grep -vE $excluded_codes $prev_sltp/output_test_$test.dat ) <( grep -vE $excluded_codes output_test_$test.dat )

9c9
< BOGOTA_ISAM7302                         1400    16
---
> BOGOTA_ISAM7302                         1400    24
15,16c15,16
< BOGOTA_ISAM7302                         3000    16
< BOGOTA_ISAM7302                         3200   100
---
> BOGOTA_ISAM7302                         3000    24
> BOGOTA_ISAM7302                         3200   500
21a22
> BOGOTA_ISAM7302_1                       1400     1
25c26,27
< BOGOTA_ISAM7302_1                       3200   100
---
> BOGOTA_ISAM7302_1                       3000     1
> BOGOTA_ISAM7302_1                       3200   500
31c33
< BOGOTA_ISAM7330                         1400    15
---
> BOGOTA_ISAM7330                         1400    25
37,38c39,40
< BOGOTA_ISAM7330                         3000    15
< BOGOTA_ISAM7330                         3200   100
---
> BOGOTA_ISAM7330                         3000    25
> BOGOTA_ISAM7330                         3200   500
44c46
< BOGOTA_MA5100                           3200   100
---
> BOGOTA_MA5100                           3200   500
54c56
< BOGOTA_MA5600                           3200   100
---
> BOGOTA_MA5600                           3200   500
64,68c66,70
< BOGOTA_MA5600T                          3200   100
< BOGOTA_MA5600_1                          600   300
< BOGOTA_MA5600_1                          700   100
< BOGOTA_MA5600_1                          800   200
< BOGOTA_MA5600_1                         1200   100
---
> BOGOTA_MA5600T                          3200   500
> BOGOTA_MA5600_1                          600   297
> BOGOTA_MA5600_1                          700    99
> BOGOTA_MA5600_1                          800   198
> BOGOTA_MA5600_1                         1200    99

select * from v_ports
	where dslam='BOGOTA_MA5600_1'
		and line_id not in (
select line_id from dcpc_status_code where dslam='BOGOTA_MA5600_1' and status_code=600
and collection_date >=TRUNC(sysdate-1) AND collection_date<TRUNC(sysdate)
);


73,74c75,76
< BOGOTA_MA5600_1                         2900   100
< BOGOTA_MA5600_1                         3200   100
---
> BOGOTA_MA5600_1                         2900    99
> BOGOTA_MA5600_1                         3200   496
84c86
< BOGOTA_MA5603T                          3200   100
---
> BOGOTA_MA5603T                          3200   500
102c104
< BOGOTA_MA5616                           3200   100
---
> BOGOTA_MA5616                           3200   500
107c109,110
< BOGOTA_MA5616_1                         1300  1009
---
> BOGOTA_MA5616_1                         1300  1012
> BOGOTA_MA5616_1                         2050   150
111c114
< BOGOTA_MA5616_1                         3200   100
---
> BOGOTA_MA5616_1                         3200   500
119c122
< BOGOTA_UA5000                           3200   100
---
> BOGOTA_UA5000                           3200   500
122,126c125,129
< ISAM7360_PON                            2900    13
< ISAM7360_PON                            2914     3
< ISAM7360_PON                           10700   384
< ISAM7360_PON                           10800    32
< ISAM7360_PON                           10900    32
---
> ISAM7360_PON                            2900    26
> ISAM7360_PON                            2914     6
> ISAM7360_PON                           10700   768
> ISAM7360_PON                           10800    64
> ISAM7360_PON                           10900    64
128c131
< ISAM7360_PON                           11300    40
---
> ISAM7360_PON                           11300   108
130c133
< ISAM7360_PON                           11414    36
---
> ISAM7360_PON                           11414   104
132,133c135,137
< ISAM7360_PON                           11700     4
< OH_BOGOTA_MA5800_PON                    2400   321
---
> ISAM7360_PON                           11700     5
> ISAM7360_PON                           11900   128
> OH_BOGOTA_MA5800_PON                    2400   609
136,141c140,145
< OH_BOGOTA_MA5800_PON                    2900    20
< OH_BOGOTA_MA5800_PON                   10700   480
< OH_BOGOTA_MA5800_PON                   10800    40
< OH_BOGOTA_MA5800_PON                   10900    40
< OH_BOGOTA_MA5800_PON                   11300    45
< OH_BOGOTA_MA5800_PON                   11400    45
---
> OH_BOGOTA_MA5800_PON                    2900    40
> OH_BOGOTA_MA5800_PON                   10700   960
> OH_BOGOTA_MA5800_PON                   10800    80
> OH_BOGOTA_MA5800_PON                   10900    80
> OH_BOGOTA_MA5800_PON                   11300   125
> OH_BOGOTA_MA5800_PON                   11400   125
144c148,149
< OH_ZTEC300MPON                          2400    17
---
> OH_BOGOTA_MA5800_PON                   11900   160
> OH_ZTEC300MPON                          2400    33
147,152c152,157
< OH_ZTEC300MPON                          2900    16
< OH_ZTEC300MPON                         10700   192
< OH_ZTEC300MPON                         10800    32
< OH_ZTEC300MPON                         10900    32
< OH_ZTEC300MPON                         11300    40
< OH_ZTEC300MPON                         11400    36
---
> OH_ZTEC300MPON                          2900    32
> OH_ZTEC300MPON                         10700   384
> OH_ZTEC300MPON                         10800    64
> OH_ZTEC300MPON                         10900    64
> OH_ZTEC300MPON                         11300   100
> OH_ZTEC300MPON                         11400    96
155a161
> OH_ZTEC300MPON                         11900   128

```
```sql

select line_id, status_code, count(*) from DCPC_STATUS_CODE
	where status_code like '18__'
		and collection_date>sysdate-7
		and dslam='BOGOTA_MA5600T'
group by line_id, status_code;

LINE_ID	STATUS_CODE	COUNT(*)
-------	-----------	--------
TELNET 	1803       	13      
SNMPV2C	1800       	15      

select *
	from DCPC_STATUS_CODE
	where status_code like '18__'
		and collection_date>sysdate-7
		and dslam='BOGOTA_MA5600T';

select *
	from DCPC_STATUS_CODE
	where status_code like '354'
		and collection_date>sysdate-7
		and dslam='BOGOTA_MA5616_1'
order by collection_date;

```
Son requests generadas por el mismatch
```sh

user@support-telefonica-colombia-a:~/pganuza/Releases/telefonica_colombia/21.5.0/sltp$ grep 90100411 ~/install/dcpc/data/backup/*profile*
/home/user/install/dcpc/data/backup/profile_change_mismatch20210702221100233.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-02 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210702223100184.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-02 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210702224100306.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-02 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210703220100893.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-03 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210703222100444.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-03 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210703223100196.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-03 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210704220100472.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-04 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210704222100523.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-04 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210704223100148.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-04 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210705220101516.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-05 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210705222100621.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-05 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE
/home/user/install/dcpc/data/backup/profile_change_mismatch20210705223100230.dat.bk:PROFILE_CHANGE, 90100411, 9, 2021-07-05 00:01:00, -1, UNKNOWN_OK; Speedy_512k,OOS_OK=111;IS_SAFE

```
El perfil elegido está determinado por
```sh
user@support-telefonica-colombia-a:~/pganuza/Releases/telefonica_colombia/21.5.0/sltp$ grep mismatch.replace.target.profile ~/install/server/config/* -r
/home/user/install/server/config/migration/process.properties:mismatch.replace.target.profile=true
```
```sql

select dslam, service_product, dslam_type, card_type, card_version from v_ports_line_card_data where line_id='90100411';

DSLAM          	SERVICE_PRODUCT 	DSLAM_TYPE	CARD_TYPE	CARD_VERSION  
---------------	----------------	----------	---------	--------------
BOGOTA_MA5616_1	512k_Residencial	MA5616    	H83DVCPE 	MA5600V300R005

select * from MIGRATION_SP_TO_PROFILE
	where service_product='512k_Residencial' and dslam_type='MA5616';

SERVICE_PRODUCT 	DSLAM_TYPE	CARD_TYPE	CARD_VERSION	PROFILE                    
----------------	----------	---------	------------	---------------------------
512k_Residencial	MA5616    	H836ADLE 	UNKNOWN     	Huawei_616_384_16_8:EXT_2_1
512k_Residencial	MA5616    	H83BVCMM 	UNKNOWN     	Speedy_512k                
512k_Residencial	MA5616    	H83BVDLE 	UNKNOWN     	Speedy_512k                
512k_Residencial	MA5616    	H83DVCPE 	UNKNOWN     	Speedy_512k                

select line_id from DCPC_STATUS_CODE
	where status_code='300'
		and dslam='BOGOTA_MA5616';

```
Con lo cual coincide. ¿Por qué ese perfil no está en el DSLAM? Y si es correcto que no esté, ¿por qué está ese perfil configurado ahí?

----
## 3.14	Running PE
```sh

test='3.14'
for f in $( ls output_test_$test.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```
```sql

-- Test 3.14.2.1
-- Lines with stability info
SELECT TRUNC(estimation_date) AS est_date, count(*) AS samples
FROM adsl_pe_est_sl_all
WHERE stability<=3 and estimation_date>sysdate-20
GROUP BY TRUNC(estimation_date)
ORDER BY trunc(estimation_date);

-- Test 3.14.2.2
-- Lines with poor stability
-- ¿¿De verdad hace falta mirar 20 días para atrás?? Seguro que si miras menos días todo se ve mucho mejor
SELECT TRUNC(estimation_date) AS est_date, count(*) AS samples 
FROM adsl_pe_est_sl_all 
WHERE stability=9 and estimation_date>sysdate-20
GROUP BY TRUNC(estimation_date) 
ORDER BY TRUNC(estimation_date);

-- Triage stability=9
select estimation_date, stability from adsl_pe_est_sl_all where line_id='00030415'
	order by 1;

SELECT DISTINCT a.dslam, a.line_id, trunc(max(collection_date)) as collected, trunc(max(date_performed)) as prof_changed
FROM adsl_pe_est_sl_all a
  LEFT JOIN profile_change_record c
  	on a.line_id=c.line_id
  LEFT JOIN adc_pop_o p
  	on a.line_id=p.tn
  WHERE a.stability=9
  AND TRUNC(a.estimation_date)='30-JUN-21'
  group by a.dslam, a.line_id
  ORDER BY 1,2,3;

--SELECT DISTINCT a.dslam, line_id, max(collection_date)
SELECT DISTINCT trunc(sysdate)
FROM adsl_pe_est_sl_all a
  LEFT JOIN adc_pop_o p
  	on a.line_id=p.tn
  WHERE a.stability=9
  AND TRUNC(estimation_date)='30-JUN-21'
  --group by a.dslam, a.line_id
 -- ORDER BY 1,2,3
  ;

select count(*) from (SELECT a.LINE_ID, MAX(date_performed)
FROM adsl_pe_po_trigger a 
  LEFT JOIN profile_change_record b
      ON (a.line_id=b.line_id AND date_performed<trunc(sysdate)) 
WHERE request_code=793 AND estimation_date>=trunc(sysdate-1)
GROUP BY a.LINE_ID 
order by 2);
-- Test 3.14.2.3
SELECT TRUNC(estimation_date) AS est_date, count(*) AS samples
FROM adsl_pe_est_sl_ts where estimation_date>sysdate-20
GROUP BY TRUNC(estimation_date)
ORDER BY TRUNC(estimation_date);

--Test 3.14.2.4
SELECT TRUNC(estimation_date) as est_date, count(*) AS samples
FROM line_summary where estimation_date>sysdate-20
GROUP BY TRUNC(estimation_date)
ORDER BY TRUNC(estimation_date);

--Test 3.14.2.5
SELECT TRUNC(data_date) AS est_date, COUNT(*) AS samples
FROM adsl_pe_est_sl_summary where data_date>sysdate-20
GROUP BY TRUNC(data_date)
ORDER BY trunc(data_date);

--Test 3.14.3.1
SELECT TRUNC(estimation_date) AS est_date, count(1) AS samples
FROM adsl_pe_po_trigger where estimation_date>sysdate-20
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

-- Test 3.14.5.2
SELECT recommendation_code AS status_code, COUNT(1) AS samples,
       CODE_STRING as DESCRIPTION
       FROM adsl_pe_sr_sl
       left join STATUS_CODES_DESCRIPTIONS
         on (CODE_NUMBER= recommendation_code and CODE_TYPE='SR')
	 WHERE ESTIMATION_DATE>sysdate-4
	 GROUP BY recommendation_code,CODE_STRING
	 ORDER BY recommendation_code,CODE_STRING;

select * from adsl_pe_sr_sl where recommendation_code=888;

select * from HIST_PORT_INFO
	where line_id='00020412';

-- Test 3.14.5.4
select count(distinct line_id)
      FROM adsl_pe_sr_sl_aggregate
      where line_id not in (select distinct line_id FROM adsl_pe_sr_sl_aggregate_latest);

select count(distinct line_id)
        FROM adsl_pe_sr_sl_aggregate
          where line_id not in (select distinct line_id FROM adsl_pe_sr_sl_aggregate_latest)
                and RECOMMENDED_SERVICE_PRODUCT!='NO_SUCCESS';



```

----
## 3.15	Running PO
```sh

test='3.15'
for f in $( ls output_test_$test.* ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```
### 6
```sql

Test 3.15.6
select start_date as "PO since" from (
    select trunc(date_request) as start_date, count(*) cnt
    from po_state
    where date_request<trunc(sysdate)
    group by trunc(date_request) order by cnt desc
) where rownum<2;
SELECT status_code, count(*) as SAMPLES,CODE_STRING as DESCRIPTION
from po_record
left join STATUS_CODES_DESCRIPTIONS
    on (CODE_NUMBER=status_code and CODE_TYPE='PO')
where DATE_COMPLETION > (select start_date from (
    select trunc(date_request) as start_date, count(*) cnt
    from po_state
    where date_request<trunc(sysdate)
    group by trunc(date_request) order by cnt desc
) where rownum<2)
group by status_code, CODE_STRING
order by 1;

select * from dslam_info where dslam_name in (select dslam_name from v_ports where line_id in (select line_id from po_record where status_code=663
	and DATE_COMPLETION>trunc(sysdate-5)));

select * from dslam_topology
	where dslam_ip in ('127.0.0.1', '127.0.0.2');


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
## 3.16	Profile Change requests generated and processed.
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
## 3.17	PO Control via GUI
```sql

select line_id||' - '||dslam||' - '||service_product from v_ports
	where technology='DSL'
		and line_id not in (select line_id from po_state);


```
```sh

for li in 00050111  ; do
	echo "Requesting RT_PO for $li"
	sed "s/#line_id#/$li/" test_3.17-REALTIME_PO.xml > test_3.17-$li-request.xml
	napi.sh submitRequest  test_3.17-$li-request.xml | xmllint --format - >  test_3.17-$li-response.xml
	grep statusCode -B1 test_3.17-$li-response.xml
	echo "------------------------"
done

```

----
## 3.18	NAPI check

./test_jenkins_json.py 'napi_job_name' ./config.properties 'output_test_3.18' results/

----
## Test 3.19: GUI check

./test_jenkins_json.py 'selenium_job_name' ./config.properties 'output_test_3.19' results/

----
## 3.21	DB Job Validation
```sh

test='3.21'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## 3.23	Real Time Port Reset New GUI
```sh

select line_id||' - '||dslam||' - '||service_product from v_ports
	where technology='DSL'
		and line_id in ('00050111', '00010406');

LINE_ID||'-'||DSLAM||'-'||SERVICE_PRODUCT   
--------------------------------------------
00010406 - BOGOTA_MA5600 - 8192k_Residencial
00050111 - BOGOTA_ISAM7302 - 4096k_Negocio  

for li in 00050111 00010406 ; do
	echo "-------------- $li --------------"
	##########################
	req="PORT_RESET"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.23-$req.xml > test_3.23-$li-$req.xml
	napi.sh submitRequest  test_3.23-$li-$req.xml | xmllint --format - > results/test_3.23-$li-$req-response.xml
	grep statusCode -B1 results/test_3.23-$li-$req-response.xml

	##########################
	req="BLOCK"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.23-$req.xml > test_3.23-$li-$req.xml
	napi.sh submitRequest  test_3.23-$li-$req.xml | xmllint --format - > results/test_3.23-$li-$req-response.xml
	grep statusCode -B1 results/test_3.23-$li-$req-response.xml

	##########################
	req="POP_O"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.23-$req.xml > test_3.23-$li-$req.xml
	napi.sh submitRequest  test_3.23-$li-$req.xml | xmllint --format - > results/test_3.23-$li-$req.1-response.xml
	grep statusCode -B1 results/test_3.23-$li-$req.1-response.xml

	##########################
	req="UNBLOCK"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.23-$req.xml > test_3.23-$li-$req.xml
	napi.sh submitRequest  test_3.23-$li-$req.xml | xmllint --format - > results/test_3.23-$li-$req-response.xml
	grep statusCode -B1 results/test_3.23-$li-$req-response.xml

	##########################
	req="POP_O"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.23-$req.xml > test_3.23-$li-$req.xml
	napi.sh submitRequest  test_3.23-$li-$req.xml | xmllint --format - > results/test_3.23-$li-$req.2-response.xml
	grep statusCode -B1  results/test_3.23-$li-$req.2-response.xml

	echo "------------------------"
done

```

----
## 3.24	Customized GUI and ClearView messages
```sh

test='3.24'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## 3.25	G.INP and Missing Microfilter check
```sh

test='3.25'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## 3.26	PON Check
```sh

test='3.26'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done


```
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

----
## 3.27	DcPc mode
```sh

test='3.27'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## 3.28	Real Time Profile Change
```sh

test='3.28'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## 3.29	Manage ONT/OLT status
```sql

SELECT distinct dslam FROM v_dslams where technology='PON';

select line_id||' - '||dslam||' - '||service_product from v_ports
	where technology='PON'
		and line_id in ('00141003', '00511010');

LINE_ID||'-'||DSLAM||'-'||SERVICE_PRODUCT            
-----------------------------------------------------
00141003 - OH_BOGOTA_MA5800_PON - 22M_Residencial_PON
00511010 - OH_ZTEC300MPON - 13M_Residencial_PON      

for li in 00511010 00141003 ; do
	echo "-------------- $li --------------"
	##########################
	req="ONT-RESET"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req-response.xml
	grep statusCode -B1 results/test_3.29-$li-$req-response.xml

	##########################
	req="ONT-REMOTE_RESET"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req-response.xml
	grep statusCode -B1 results/test_3.29-$li-$req-response.xml

	##########################
	req="ONT-BLOCK"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req-response.xml
	grep statusCode -B1 results/test_3.29-$li-$req-response.xml

	##########################
	req="ONT-PON_POP_O"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req.1-response.xml
	grep statusCode -B1 results/test_3.29-$li-$req.1-response.xml

	##########################
	req="ONT-UNBLOCK"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req-response.xml
	grep statusCode -B1 results/test_3.29-$li-$req-response.xml

	##########################
	req="ONT-PON_POP_O"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req.2-response.xml
	grep statusCode -B1  results/test_3.29-$li-$req.2-response.xml

	echo "------------------------"
done

for li in 00511010 00141003 ; do
	echo "-------------- $li --------------"
	##########################
	req="OLT-RESET"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req-response.xml
	grep statusCode -B1 results/test_3.29-$li-$req-response.xml

	##########################
	req="OLT-BLOCK"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req-response.xml
	grep statusCode -B1 results/test_3.29-$li-$req-response.xml

	##########################
	req="ONT-PON_POP_O"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req.3-response.xml
	grep statusCode -B1 results/test_3.29-$li-$req.3-response.xml

	##########################
	req="OLT-UNBLOCK"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req-response.xml
	grep statusCode -B1 results/test_3.29-$li-$req-response.xml

	##########################
	req="ONT-PON_POP_O"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.29-$req.xml > test_3.29-$li-$req.xml
	napi.sh submitRequest  test_3.29-$li-$req.xml | xmllint --format - > results/test_3.29-$li-$req.4-response.xml
	grep statusCode -B1  results/test_3.29-$li-$req.4-response.xml

	echo "------------------------"
done



```

----
## 3.30	Profile Reconciliation
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

LINE_ID 	DSLAM            	PROFILE                                	DEFAULT_PROFILE                        	SERVICE_PRODUCT   
--------	-----------------	---------------------------------------	---------------------------------------	------------------
00030304	BOGOTA_UA5000    	Huawei_8896_992_16_8:EXT_1_1           	Huawei_9600_1200_8_8:EXT_1_1           	8192k_Residencial 
90100411	BOGOTA_MA5616_1  	Speedy                                 	Speedy_512k                            	512k_Residencial  

00030304 90100411


```
```sh

for li in 00030304 90100411; do
	echo "-------------- $li --------------"
	##########################
	req="PROFILE_CHANGE"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.30-$req.xml > test_3.30-$li-$req.xml
	napi.sh submitRequest  test_3.30-$li-$req.xml | xmllint --format - > results/test_3.30-$li-$req-response.xml
	grep statusCode -B1 results/test_3.30-$li-$req-response.xml

	##########################
	req="POP_O"
	echo "-- Requesting $req"

	sed "s/#line_id#/$li/" test_3.30-$req.xml > test_3.30-$li-$req.xml
	napi.sh submitRequest  test_3.30-$li-$req.xml | xmllint --format - > results/test_3.30-$li-$req-response.xml
	grep 'key>lineinfo.profile' -A1 results/test_3.30-$li-$req-response.xml
	echo "------------------------"
done

```

----
## 3.31	Clearview
```sh

test='3.31'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## 3.32	PON PE
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
### Test 3.32.2.2
```sql

select trunc(ESTIMATION_DATE) as est_date,
       count(*) as samples
from PON_PE_ONT_LATEST
group by trunc(ESTIMATION_DATE)
order by trunc(ESTIMATION_DATE);

```
### Test 3.32.3.5
```sql

select status_code, count(*) as samples,
       CODE_STRING as DESCRIPTION
from PON_PE_OLT
left join STATUS_CODES_DESCRIPTIONS
  on (CODE_NUMBER=status_code+2100 and
      CODE_TYPE='RT_ONT_PE_ESTIMATOR')
where estimation_date=trunc(sysdate-1)
group by status_code,CODE_STRING order by 1;

```
### Test 3.32.5.2
```sql

select trunc(ESTIMATION_DATE) as est_date,
      count(case when DS_BW_PERCENTILE is not null THEN 1 END) as DS_LINES,
      count(case when US_BW_PERCENTILE is not null THEN 1 END) as US_LINES
from pon_pe_ont where ESTIMATION_DATE>sysdate-20
group by trunc(ESTIMATION_DATE) order by 1;


```

----
## 3.33	Running OSP
```sh

test='3.33'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## 3.34	Check PO and PM supported cards.
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
## 3.35	Selective Port Reset
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

V_PORT_RESET_CANDIDATES

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
## 3.36	Layer 2 Data
```sh

test='3.36'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done


select line_id from v_ports
	where dslam='BOGOTA_MA5600_1'
	and line_id not in (select a.line_id
	from v_ports a
	left join LAYER2_DATA b on ( (a.line_id=b.line_id) and
	      (COLLECTION_DATE>=trunc(sysdate-1)) and (COLLECTION_DATE<trunc(sysdate)) )
	      where status=0
	      );

select a.dslam, count(distinct a.line_id) as LINE_IDS, count(distinct b.line_id) as SAMPLES
from v_ports a
left join LAYER2_DATA b on ( (a.line_id=b.line_id) and
      (COLLECTION_DATE>=trunc(sysdate-1)) and (COLLECTION_DATE<trunc(sysdate)) )
      where status=0
      group by a.dslam order by 1;

```


----
## 3.37	SELT / MELT
```sh

test='3.37'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```


----
## 3.38	Running migration / mismatch
```sh

test='3.38'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff <(sort $prev_sltp/$f) <(sort $f) ;
done

```
```sql

select distinct dslam_type, card_type, current_sp, target_sp
	from MIGRATION_REQUEST_DETAIL
	join v_ports_line_card_data
		on dslam=dslam_name
	where creation_date>trunc(sysdate-10)
		and mapped_profile is NULL
order by 1, 2, 3, 4;


select * from MIGRATION_SP_TO_PROFILE
        where      dslam_type='ISAM7302'
--	  and service_product='20480k_Residencial'
	        and card_type='NALT-C'
;

```
### Test 3.38.12
```sql

-- Muestra sólo los que son distintos

select c.SERVICE_PRODUCT,
	b.dslam_type,
	c.dslam_type as REGION_DTYPE,
	NEW_PROFILE,
	profile as TARGET_PROFILE,
	a.EXECUTION_DATE as migration_exec_date,
	d.date_performed prof_xg_date
from MIGRATION_REQUEST_DETAIL a
join v_ports_line_card_data b
	on (a.line_id=b.line_id)
join MIGRATION_SP_TO_PROFILE c
     on (CURRENT_SP=c.SERVICE_PRODUCT
         and c.dslam_type like (b.dslam_type||'%')
         and b.card_type=c.card_type)
left join profile_change_record d
	on (a.line_id=d.line_id)
where a.STATUS_CODE in (0,53)
	and REGEXP_REPLACE(NEW_PROFILE, '\s*', '') <> REGEXP_REPLACE(PROFILE, '\s*', '')
order by 1,2;

```

----
## 3.39	Neighborhood configuration
```sh

test='3.39'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

----
## 3.40	Vectoring
```sh

pushd ~/Repositorios/bookmarks/log_verification_tool
./run.sh
mv log_verification.log $CUSTOMER_DIR/sltp/
popd

```

----
## 3.42	Log verification
```sh

(cd ~/Repositorios/bookmarks/log_verification_tool/ && ./run.sh && mv log_verification.log $CUSTOMER_DIR/sltp/results/)

```

-------------------------------------
-- Customer specific
-------------------------------------

-- telefonica_colombia
## 4.7	Neighborhood configuration
```sh

prev_sltp='../../../5.3.2/sltp/results'
test='4.7'
for f in $( ls output_test_$test.*.dat ); do
	echo "$f"
	echo "------------------"
	diff $prev_sltp/$f $f ;
done

```

