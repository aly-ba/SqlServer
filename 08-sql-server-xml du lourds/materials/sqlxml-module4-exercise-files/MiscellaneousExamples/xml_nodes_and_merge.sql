
/*
Following are two example of bringing a small amount of XML into a table using SQL Server 2005 and SQL Server 2008. In the case of SQL Server 2005, the example simply inserts data into the target table without any handling or attempts to update existing matching rows.
*/
use scratch
go
if not OBJECT_ID('dbo.books') is null
 drop table dbo.books;
go
create table dbo.books(
 id tinyint not null primary key,
 sku nvarchar(15) not null,
 skuType nvarchar(10) not null, 
 title nvarchar(100) not null,
 listPrice money not null);
go
set nocount on
declare @booklist xml;
select @booklist = bulkcolumn from openRowSet(bulk 'c:\booklist.xml',single_blob) as b;
select @booklist; 
-- Yukon-style insert, you could do update similarly.
insert into dbo.books
select t.c.value('./id[1]','tinyint')
  , t.c.value('./sku[1]','nvarchar(15)')
  , t.c.value('./skuType[1]','nvarchar(10)') 
  , t.c.value('./title[1]','nvarchar(100)')
  , t.c.value('./listPrice[1]','money')
from @booklist.nodes('//book') as t(c);
go
select * from dbo.books;
go  
/*
Transact-SQL for SQL Server 2008 adds a very useful new statement called MERGE. This statement allows us synchronize two data sources. While that may not seem to have much use in a case like this, we can actually use it like an "UPSERT" where existing data is update and new data is inserted into a destination table.
*/
declare @booklist xml;
select @booklist = bulkcolumn from openRowSet(bulk 'c:\booklist.xml',single_blob) as b;
with b2(id,sku,skuType,title,listPrice) as (
select t.c.value('./id[1]','tinyint') 
  , t.c.value('./sku[1]','nvarchar(15)')
  , t.c.value('./skuType[1]','nvarchar(10)')
  , t.c.value('./title[1]','nvarchar(100)')
  , t.c.value('./listPrice[1]','money') 
from @booklist.nodes('//book') as t(c))
merge into dbo.books as b1
using b2
on(b1.id = b2.id)
when matched then
 update set
  b1.sku = b2.sku 
  , b1.skuType = b2.skuType
  , b1.title = b2.title
  , b1.listPrice = b2.listPrice
when not matched on target  then
 insert (id,sku,skuType,title,listPrice)
 values (b2.id,b2.sku ,b2.skuType,b2.title,b2.listPrice);
go
select * from dbo.books;
go 
