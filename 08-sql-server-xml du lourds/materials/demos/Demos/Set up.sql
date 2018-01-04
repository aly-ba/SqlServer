USE CompressionTest;
GO
IF OBJECT_ID('TestFixedWidth') IS NOT NULL DROP TABLE TestFixedWidth;

CREATE TABLE TestFixedWidth
(
    Col1 INT, Col2 TINYINT, 
    Col3 DATETIME, Col4 DATE,
    Col5 CHAR(8), Col6 VARCHAR(8)
) WITH (DATA_COMPRESSION = ROW);

INSERT INTO TestFixedWidth
VALUES(1,1,'2017-01-01','2017-01-01','Test','Test'),
(NULL,NULL,NULL,NULL,NULL,NULL);

IF OBJECT_ID('TestSpecial') IS NOT NULL DROP TABLE TestSpecial;

CREATE TABLE TestSpecial
(
    Col1 INT, 
    Col2 BIT,
    Col3 INT, 
    Col4 NCHAR(8),
    Col5 CHAR(8),
    Col6 CHAR(12)
) WITH (DATA_COMPRESSION = ROW);

INSERT INTO TestSpecial
VALUES(0,1,NULL,'test','','test example');

IF OBJECT_ID('TestCluster') IS NOT NULL DROP TABLE TestCluster;

CREATE TABLE TestCluster(
col1 VARCHAR(250), 
col2 VARCHAR(250), 
col3 VARCHAR(250), 
col4 VARCHAR(250), 
col5 VARCHAR(250), 
col6 VARCHAR(250), 
col7 VARCHAR(250), 
col8 VARCHAR(250), 
col9 VARCHAR(250), 
col10 VARCHAR(250), 
col11 VARCHAR(250), 
col12 VARCHAR(250), 
col13 VARCHAR(250), 
col14 VARCHAR(250), 
col15 VARCHAR(250), 
col16 INT, 
col17 INT, 
col18 INT, 
col19 INT, 
col20 INT, 
col21 INT, 
col22 INT, 
col23 INT, 
col24 INT, 
col25 INT, 
col26 INT, 
col27 INT, 
col28 INT, 
col29 INT, 
col30 INT, 
col31 varchar(250), 
col32 varchar(250), 
col33 varchar(250), 
col34 varchar(250), 
col35 varchar(250), 
col36 varchar(250), 
col37 varchar(250), 
col38 varchar(250), 
col39 varchar(250), 
col40 varchar(250), 
col41 varchar(250), 
col42 varchar(250), 
col43 varchar(250), 
col44 varchar(250), 
col45 varchar(250), 
col46 INT, 
col47 INT, 
col48 INT, 
col49 INT, 
col50 INT, 
col51 INT, 
col52 INT, 
col53 INT, 
col54 INT, 
col55 INT, 
col56 INT, 
col57 INT, 
col58 INT, 
col59 INT, 
col60 INT) WITH(DATA_COMPRESSION = ROW);

INSERT INTO TestCluster 
VALUES (
'sysrscols',
'sysrowsets',
'sysclones',
'sysallocunits',
'sysfiles1',
'sysseobjvalues',
'syspriorities',
'sysdbfrag',
'sysfgfrag',
'sysdbfiles',
'syspru',
'sysbrickfiles',
'sysphfg',
'sysprufiles',
'sysftinds',
455,
814,
835,
72,
357,
573,
99,
72,
78,
700,
71,
15,
157,
174,
366,
'nchars',
'sysfgfrag',
'sysprufiles',
'sysxmlplacement',
'sysmultiobjvalues',
'sysidxstats',
'plan_persist_runtime_stats_interval',
'offrow',
'plan_persist_query_text',
'sysextsources',
'ServiceBrokerQueue',
'sysseobjvalues',
'sysnsobjs',
'DF__uniqid__col1__398D8EEE',
'sysdbfiles',
2537,
8775,
9418,
4991,
914,
4244,
5861,
8647,
4378,
5717,
8116,
3068,
9099,
4376,
3604
);




