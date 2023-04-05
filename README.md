Oracle-Database-23c-Free-on-Docker
==================================

A set of scripts for using Oracle Database 23c Free docker image in [Oracle Container Registry](https://container-registry.oracle.com/ords/f?p=113:1).

Configuration
-------------

Copy the file `dotenv.sample` to a file named `.env` and rewrite the contents as needed.

```shell
ORACLE_CONTAINER_NAME=oracle_database_23c_free
ORACLE_LISTENER_PORT=1521
ORACLE_PWD=oracle
```

Example of use
--------------

### [run.sh](run.sh) ###

Create a new container and start an Oracle Database server instance.

```console
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$ ./run.sh
Starting an Oracle Database Server Instance.
5fb7e0d33f9477e8a340749f162d7093e296571a4cb777295e4a8278c382289a
Waiting for oracle_database_23c to get healthy ....................................................... done
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$
```

### [install-sample.sh](install-sample.sh) ###

Installs sample schemas.

```console
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$ ./install-sample.sh

SQL*Plus: Release 23.0.0.0.0 - Developer-Release on Wed Apr 5 08:45:31 2023
Version 23.2.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Last Successful login time: Tue Mar 28 2023 13:24:39 +00:00

Connected to:
Oracle Database 23c Free, Release 23.0.0.0.0 - Developer-Release
Version 23.2.0.0.0

SQL>
specify password for SYSTEM as parameter 1:
...
...
...
SH     PROMO_PK                            503        503
SH     SALES_CHANNEL_BIX                     4         92
SH     SALES_CUST_BIX                     7059      35808
SH     SALES_PROD_BIX                       72       1074
SH     SALES_PROMO_BIX                       4         54
SH     SALES_TIME_BIX                     1460       1460
SH     SUP_TEXT_IDX
SH     TIMES_PK                           1826       1826

72 rows selected.

SQL> Disconnected from Oracle Database 23c Free, Release 23.0.0.0.0 - Developer-Release
Version 23.2.0.0.0
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$
```

### [sqlplus.sh](sqlplus.sh) ###

Connect to CDB root and confirm the connection.

```console
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$ ./sqlplus.sh system/oracle

SQL*Plus: Release 23.0.0.0.0 - Developer-Release on Wed Apr 5 08:47:36 2023
Version 23.2.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Last Successful login time: Wed Apr 05 2023 08:47:10 +00:00

Connected to:
Oracle Database 23c Free, Release 23.0.0.0.0 - Developer-Release
Version 23.2.0.0.0

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT
SQL> exit
Disconnected from Oracle Database 23c Free, Release 23.0.0.0.0 - Developer-Release
Version 23.2.0.0.0
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$
```

Connect to PDB and confirm the connection. If you have sample schemas installed, browse to the sample table.

```console
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$ ./sqlplus.sh system/oracle@FREEPDB1

SQL*Plus: Release 23.0.0.0.0 - Developer-Release on Wed Apr 5 08:48:32 2023
Version 23.2.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Last Successful login time: Wed Apr 05 2023 08:47:36 +00:00

Connected to:
Oracle Database 23c Free, Release 23.0.0.0.0 - Developer-Release
Version 23.2.0.0.0

SQL> SHOW CON_NAME

CON_NAME
------------------------------
FREEPDB1
SQL> -- If you have sample schemas installed
SQL> SELECT JSON_OBJECT(*) FROM hr.employees WHERE rownum <= 3;

JSON_OBJECT(*)
--------------------------------------------------------------------------------
{"EMPLOYEE_ID":100,"FIRST_NAME":"Steven","LAST_NAME":"King","EMAIL":"SKING","PHO
NE_NUMBER":"515.123.4567","HIRE_DATE":"2003-06-17T00:00:00","JOB_ID":"AD_PRES","
SALARY":24000,"COMMISSION_PCT":null,"MANAGER_ID":null,"DEPARTMENT_ID":90}

{"EMPLOYEE_ID":101,"FIRST_NAME":"Neena","LAST_NAME":"Kochhar","EMAIL":"NKOCHHAR"
,"PHONE_NUMBER":"515.123.4568","HIRE_DATE":"2005-09-21T00:00:00","JOB_ID":"AD_VP
","SALARY":17000,"COMMISSION_PCT":null,"MANAGER_ID":100,"DEPARTMENT_ID":90}

{"EMPLOYEE_ID":102,"FIRST_NAME":"Lex","LAST_NAME":"De Haan","EMAIL":"LDEHAAN","P
HONE_NUMBER":"515.123.4569","HIRE_DATE":"2001-01-13T00:00:00","JOB_ID":"AD_VP","
SALARY":17000,"COMMISSION_PCT":null,"MANAGER_ID":100,"DEPARTMENT_ID":90}

JSON_OBJECT(*)
--------------------------------------------------------------------------------


SQL> SELECT 2*3;

       2*3
----------
         6

SQL> exit
Disconnected from Oracle Database 23c Free, Release 23.0.0.0.0 - Developer-Release
Version 23.2.0.0.0
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$
```

### [logs.sh](logs.sh) ###

Show the database alert log and others.

```console
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$ ./logs.sh
Starting Oracle Net Listener.
Oracle Net Listener started.
Starting Oracle Database instance FREE.
Oracle Database instance FREE started.

The Oracle base remains unchanged with value /opt/oracle

SQL*Plus: Release 23.0.0.0.0 - Developer-Release on Wed Apr 5 08:43:31 2023
Version 23.2.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 23c Free, Release 23.0.0.0.0 - Developer-Release
Version 23.2.0.0.0

SQL>
User altered.
...
...
...
2023-04-05T08:48:39.258928+00:00
Resize operation completed for file# 201, fname /opt/oracle/oradata/FREE/temp01.dbf, old size 20480K, new size 86016K
2023-04-05T08:48:40.707851+00:00
Resize operation completed for file# 201, fname /opt/oracle/oradata/FREE/temp01.dbf, old size 86016K, new size 151552K
2023-04-05T08:48:42.272123+00:00
Resize operation completed for file# 201, fname /opt/oracle/oradata/FREE/temp01.dbf, old size 151552K, new size 217088K
2023-04-05T08:48:43.703270+00:00
Resize operation completed for file# 201, fname /opt/oracle/oradata/FREE/temp01.dbf, old size 217088K, new size 282624K
2023-04-05T08:48:45.174855+00:00
Resize operation completed for file# 201, fname /opt/oracle/oradata/FREE/temp01.dbf, old size 282624K, new size 348160K
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$
```

### [start.sh](start.sh) ###

Start container and Oracle Database server instance.

```
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$ ./start.sh
oracle_database_23c
Waiting for oracle_database_23c to get healthy ........................................................ done
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$
```

### [stop.sh](stop.sh) ###

Shutdown database and stop container.

```
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$ ./stop.sh
oracle_database_23c
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$
```

### [remove.sh](remove.sh) ###

Remove container.

```
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$ ./remove.sh
5fb7e0d33f9477e8a340749f162d7093e296571a4cb777295e4a8278c382289a
[opc@instance-20230405-1443 Oracle-Database-23c-Free-on-Docker]$
```

Author
------

[Shinichi Akiyama](https://github.com/shakiyam)

License
-------

[MIT License](https://opensource.org/licenses/MIT)
