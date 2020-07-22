--
-- http://support.microsoft.com/kb/2154845/en-us
--

USE tempdb
GO

SELECT * FROM sys.database_files
GO
--
-- Letter drive named paths below should be carefully checked, proceed with caution as this is a not easy to revert operation
--
ALTER DATABASE TEMPDB MODIFY FILE (NAME='tempdev', FILENAME='E:\MSSQL\DATA\tempdev.mdf',SIZE=1000MB, FILEGROWTH=100MB)
GO

ALTER DATABASE TEMPDB MODIFY FILE (NAME='templog', FILENAME='L:\MSSQL\TLOG\templog.ldf',SIZE=1000MB, FILEGROWTH=100MB)
GO


SET NOCOUNT ON

IF ( (SELECT count(name) FROM sys.database_files) > 2 ) -- that is, besides "tempdev" and "templog" default logical files...
BEGIN
	SELECT('!!! Error, suplemental tempdev files already exist at the file-system, please check before proceeding!!!') AS ERROR
	PRINT CHAR(13) + '!!! Error, suplemental tempdev files already exist at the file-system, please check before proceeding!!!'
END
ELSE
BEGIN
	DECLARE @nCPUs_wAffinity tinyint = ( SELECT COUNT(*) from sys.dm_os_schedulers WHERE STATUS = 'VISIBLE ONLINE' )

	IF ( @nCPUs_wAffinity > 1 )
		ALTER DATABASE TEMPDB ADD FILE (NAME=tempdev2, FILENAME='E:\MSSQL\DATA\tempdev2.ndf',SIZE=1000MB, FILEGROWTH=100MB)

	IF ( @nCPUs_wAffinity > 2 )
		ALTER DATABASE TEMPDB ADD FILE (NAME=tempdev3, FILENAME='E:\MSSQL\DATA\tempdev3.ndf',SIZE=1000MB, FILEGROWTH=100MB)

	IF ( @nCPUs_wAffinity > 3 )
		ALTER DATABASE TEMPDB ADD FILE (NAME=tempdev4, FILENAME='E:\MSSQL\DATA\tempdev4.ndf',SIZE=1000MB, FILEGROWTH=100MB)

	IF ( @nCPUs_wAffinity > 4 )
		ALTER DATABASE TEMPDB ADD FILE (NAME=tempdev5, FILENAME='E:\MSSQL\DATA\tempdev5.ndf',SIZE=1000MB, FILEGROWTH=100MB)

	IF ( @nCPUs_wAffinity > 5 )
		ALTER DATABASE TEMPDB ADD FILE (NAME=tempdev6, FILENAME='E:\MSSQL\DATA\tempdev6.ndf',SIZE=1000MB, FILEGROWTH=100MB)

	IF ( @nCPUs_wAffinity > 6 )
		ALTER DATABASE TEMPDB ADD FILE (NAME=tempdev7, FILENAME='E:\MSSQL\DATA\tempdev7.ndf',SIZE=1000MB, FILEGROWTH=100MB)

	IF ( @nCPUs_wAffinity > 7 )
		ALTER DATABASE TEMPDB ADD FILE (NAME=tempdev8, FILENAME='E:\MSSQL\DATA\tempdev8.ndf',SIZE=1000MB, FILEGROWTH=100MB)
	
	SET NOCOUNT OFF

	SELECT * FROM sys.database_files
END

/* *****************************************************************************************************************************

Expected output results (similar):

BEFORE:
-------

file_id	file_guid	type	type_desc	data_space_id	name	physical_name	state	state_desc	size	max_size	growth	is_media_read_only	is_read_only	is_sparse	is_percent_growth	is_name_reserved	create_lsn	drop_lsn	read_only_lsn	read_write_lsn	differential_base_lsn	differential_base_guid	differential_base_time	redo_start_lsn	redo_start_fork_guid	redo_target_lsn	redo_target_fork_guid	backup_lsn
1	NULL	0	ROWS	1	tempdev	D:\SQLServer\Data\tempdev.mdf	0	ONLINE	65536	-1	8192	0	0	0	0	0	NULL	NULL	NULL	NULL	32000000030700037	BAF06B70-CABB-4637-BF1F-F9128BD08A36	2013-11-11 15:33:48.753	NULL	NULL	NULL	NULL	NULL
2	NULL	1	LOG	0	templog	D:\SQLServer\Tlog\templog.ldf	0	ONLINE	65536	-1	8192	0	0	0	0	0	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL

AFTER (for 8 CPU threads):
------

file_id	file_guid	type	type_desc	data_space_id	name	physical_name	state	state_desc	size	max_size	growth	is_media_read_only	is_read_only	is_sparse	is_percent_growth	is_name_reserved	create_lsn	drop_lsn	read_only_lsn	read_write_lsn	differential_base_lsn	differential_base_guid	differential_base_time	redo_start_lsn	redo_start_fork_guid	redo_target_lsn	redo_target_fork_guid	backup_lsn
1	NULL	0	ROWS	1	tempdev	D:\SQLServer\Data\tempdev.mdf	0	ONLINE	65536	-1	8192	0	0	0	0	0	NULL	NULL	NULL	NULL	32000000030700037	BAF06B70-CABB-4637-BF1F-F9128BD08A36	2013-11-11 15:33:48.753	NULL	NULL	NULL	NULL	NULL
2	NULL	1	LOG	0	templog	D:\SQLServer\Tlog\templog.ldf	0	ONLINE	65536	-1	8192	0	0	0	0	0	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
3	F9EC30AA-3DDB-433A-91CC-0DAAB0482A5D	0	ROWS	1	tempdev2	D:\SQLServer\Data\tempdev2.ndf	0	ONLINE	640	-1	8192	0	0	0	0	0	33000000946200233	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
4	A21CA032-AE18-4FC2-B524-2E9F68211F1D	0	ROWS	1	tempdev3	D:\SQLServer\Data\tempdev3.ndf	0	ONLINE	640	-1	8192	0	0	0	0	0	33000000952900006	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
5	B22E497C-E100D-4E8A-A206-8FCFC70F929C	0	ROWS	1	tempdev4	D:\SQLServer\Data\tempdev4.ndf	0	ONLINE	640	-1	8192	0	0	0	0	0	33000000953600006	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
6	32C574E6-4132-418F-928A-25BCE77811CD	0	ROWS	1	tempdev5	D:\SQLServer\Data\tempdev5.ndf	0	ONLINE	640	-1	8192	0	0	0	0	0	33000000954300006	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	6D747C0A-2A20-4CBF-B7FC-C876B0100020C	0	ROWS	1	tempdev6	D:\SQLServer\Data\tempdev6.ndf	0	ONLINE	640	-1	8192	0	0	0	0	0	330000009510000006	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
8	05A464A4-C4FC-4FFA-9086-65F81111841B	0	ROWS	1	tempdev7	D:\SQLServer\Data\tempdev7.ndf	0	ONLINE	640	-1	8192	0	0	0	0	0	33000000955700006	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
9	FC933C20-4866-4768-9F2D-76446D3ED590	0	ROWS	1	tempdev8	D:\SQLServer\Data\tempdev8.ndf	0	ONLINE	640	-1	8192	0	0	0	0	0	33000000956400006	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL

Expected output message (similar):

The file "tempdev" has been modified in the system catalog. The new path will be used the next time the database is started.
The file "templog" has been modified in the system catalog. The new path will be used the next time the database is started.

(9 row(s) affected)


NOTE:

If secondary data files for tempdb already exist, then following message is displayed:

!!! Error, suplemental tempdev files already exist at the file-system, please check before proceeding!!!
**************************************************************************************************************************************** */
