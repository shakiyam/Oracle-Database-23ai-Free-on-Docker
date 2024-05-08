Oracle-Database-23ai-Free-on-Docker
===================================

A set of scripts for using Oracle Database 23ai Free docker image in [Oracle Container Registry](https://container-registry.oracle.com/ords/f?p=113:1).

Configuration
-------------

Copy the file `dotenv.sample` to a file named `.env` and modify the contents as needed.

```shell
ORACLE_CONTAINER_NAME=oracle_database_23ai_free
ORACLE_LISTENER_PORT=1521
ORACLE_PWD=oracle
```

Examples of Use
---------------

### [run.sh](run.sh) ###

Create a new container and start an Oracle Database server instance.

```console
$ ./run.sh
Starting an Oracle Database Server Instance.
Trying to pull container-registry.oracle.com/database/free:23.4.0.0...
Getting image source signatures
Copying blob 6d6e36f7c9fb done
Copying blob 716b489ad5ad done
Copying blob 21def9023b6f done
Copying blob 5e7b2cfeb7fa done
Copying blob b4a24759beff done
Copying blob 78bba54e9814 done
Copying blob c23fd8c6cbee done
Copying blob 79dea26b3a5a done
Copying blob 5dfbcf799df3 done
Copying blob 154719a62576 done
Copying config 7510f8869b done
Writing manifest to image destination
f8dfe48aa572224c865faa07808461e3fdbb1a308e56ef2985f69eca3b4fddc9
Waiting for oracle_database_23ai to get healthy ........................................................... done
$
```

### [install-sample.sh](install-sample.sh) ###

Installs sample schemas.

```console
./install-sample.sh


SQLcl: Release 24.1 Production on Wed May 08 01:11:16 2024

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Last Successful login time: Wed May 08 2024 01:11:17 +00:00

Connected to:
Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.4.0.24.05


Thank you for installing the Oracle Human Resources Sample Schema.
This installation script will automatically exit your database session
at the end of the installation or if any error is encountered.
The entire installation will be logged into the 'hr_install.log' log file.

Enter a password for the user HR:
...
...
...
Installationverification
___________________________
Verification:

Table                            provided    actual
_____________________________ ___________ _________
channels                                5         5
costs                               82112     82112
countries                              35        35
customers                           55500     55500
products                               72        72
promotions                            503       503
sales                              918843    918843
times                                1826      1826
supplementary_demographics           4500      4500

Thankyou!
___________________________________________________________
The installation of the sample schema is now finished.
Please check the installation verification output above.

You will now be disconnected from the database.

Thank you for using Oracle Database!

Disconnected from Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.4.0.24.05
$
```

### [sqlplus.sh](sqlplus.sh) ###

Connect to CDB root and confirm the connection.

```console
$ ./sqlplus.sh system/oracle

SQL*Plus: Release 23.0.0.0.0 - Production on Wed May 8 01:15:42 2024
Version 23.4.0.24.05

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Last Successful login time: Wed May 08 2024 01:11:45 +00:00

Connected to:
Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.4.0.24.05

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT
SQL> exit
Disconnected from Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.4.0.24.05
$
```

Connect to PDB and confirm the connection. If you have sample schemas installed, browse to the sample table.

```console
$ ./sqlplus.sh system/oracle@FREEPDB1

SQL*Plus: Release 23.0.0.0.0 - Production on Wed May 8 01:16:43 2024
Version 23.4.0.24.05

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Last Successful login time: Wed May 08 2024 01:15:42 +00:00

Connected to:
Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.4.0.24.05

SQL> SHOW CON_NAME

CON_NAME
------------------------------
FREEPDB1
SQL> -- If you have sample schemas installed
SQL> SELECT JSON_OBJECT(*) FROM hr.employees WHERE rownum <= 3;

JSON_OBJECT(*)
--------------------------------------------------------------------------------
{"EMPLOYEE_ID":100,"FIRST_NAME":"Steven","LAST_NAME":"King","EMAIL":"SKING","PHO
NE_NUMBER":"1.515.555.0100","HIRE_DATE":"2013-06-17T00:00:00","JOB_ID":"AD_PRES"
,"SALARY":24000,"COMMISSION_PCT":null,"MANAGER_ID":null,"DEPARTMENT_ID":90}

{"EMPLOYEE_ID":101,"FIRST_NAME":"Neena","LAST_NAME":"Yang","EMAIL":"NYANG","PHON
E_NUMBER":"1.515.555.0101","HIRE_DATE":"2015-09-21T00:00:00","JOB_ID":"AD_VP","S
ALARY":17000,"COMMISSION_PCT":null,"MANAGER_ID":100,"DEPARTMENT_ID":90}

{"EMPLOYEE_ID":102,"FIRST_NAME":"Lex","LAST_NAME":"Garcia","EMAIL":"LGARCIA","PH
ONE_NUMBER":"1.515.555.0102","HIRE_DATE":"2011-01-13T00:00:00","JOB_ID":"AD_VP",
"SALARY":17000,"COMMISSION_PCT":null,"MANAGER_ID":100,"DEPARTMENT_ID":90}

JSON_OBJECT(*)
--------------------------------------------------------------------------------


SQL> SELECT 2*3;

       2*3
----------
         6

SQL> exit
Disconnected from Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.4.0.24.05
$
```

### [logs.sh](logs.sh) ###

Show the database alert log and others.

```console
./logs.sh
Starting Oracle Net Listener.
Oracle Net Listener started.
Starting Oracle Database instance FREE.
Oracle Database instance FREE started.

The Oracle base remains unchanged with value /opt/oracle

SQL*Plus: Release 23.0.0.0.0 - Production on Wed May 8 01:08:12 2024
Version 23.4.0.24.05

Copyright (c) 1982, 2024, Oracle.  All rights reserved.


Connected to:
Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.4.0.24.05

SQL>
User altered.
...
...
...
FREEPDB1(3):Resize operation completed for file# 12, fname /opt/oracle/oradata/FREE/FREEPDB1/system01.dbf, old size 286720K, new size 296960K
2024-05-08T01:12:19.725650+00:00
FREEPDB1(3):TABLE SYS.WRI$_OPTSTAT_HISTHEAD_HISTORY: ADDED INTERVAL PARTITION SYS_P324 (45419) VALUES LESS THAN (TO_DATE(' 2024-05-09 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
2024-05-08T01:13:16.189083+00:00
FREEPDB1(3):TABLE SYS.WRP$_REPORTS: ADDED AUTOLIST FRAGMENT SYS_P344 (2) VALUES (( 2991363328, TO_DATE(' 2024-05-06 00:00:00', 'syyyy-mm-dd hh24:mi:ss', 'nls_calendar=gregorian') ))
FREEPDB1(3):TABLE SYS.WRP$_REPORTS_DETAILS: ADDED AUTOLIST FRAGMENT SYS_P345 (2) VALUES (( 2991363328, TO_DATE(' 2024-05-06 00:00:00', 'syyyy-mm-dd hh24:mi:ss', 'nls_calendar=gregorian') ))
FREEPDB1(3):TABLE SYS.WRP$_REPORTS_TIME_BANDS: ADDED AUTOLIST FRAGMENT SYS_P348 (2) VALUES (( 2991363328, TO_DATE(' 2024-05-06 00:00:00', 'syyyy-mm-dd hh24:mi:ss', 'nls_calendar=gregorian') ))
2024-05-08T01:18:07.738866+00:00
FREEPDB1(3):Resize operation completed for file# 13, fname /opt/oracle/oradata/FREE/FREEPDB1/sysaux01.dbf, old size 409600K, new size 419840K
2024-05-08T01:18:07.749602+00:00
Resize operation completed for file# 3, fname /opt/oracle/oradata/FREE/sysaux01.dbf, old size 624640K, new size 655360K
FREEPDB1(3):Resize operation completed for file# 15, fname /opt/oracle/oradata/FREE/FREEPDB1/users01.dbf, old size 285440K, new size 295680K
$
```

### [start.sh](start.sh) ###

Start container and Oracle Database server instance.

```
$ ./start.sh
oracle_database_23ai
Waiting for oracle_database_23ai to get healthy ........................................................... done
$
```

### [stop.sh](stop.sh) ###

Shutdown database and stop container.

```
./stop.sh
oracle_database_23ai
$
```

### [remove.sh](remove.sh) ###

Remove container.

```
$ ./remove.sh
oracle_database_23ai
$
```

Author
------

[Shinichi Akiyama](https://github.com/shakiyam)

License
-------

[MIT License](https://opensource.org/licenses/MIT)
