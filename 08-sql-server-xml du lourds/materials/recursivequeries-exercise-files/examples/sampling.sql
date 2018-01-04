select * from [sales receipts]
where 0.001 >= cast(checksum(newid(), id) & 0x7fffffff AS float) 
/ cast (0x7fffffff AS int) 
order by id


select *  from [sales receipts]
tablesample (.1 percent);


select avg(total) from [sales receipts]


select avg(total)-250 from [sales receipts]
where 0.001 >= cast(checksum(newid(), id) & 0x7fffffff as float) 
/ cast (0x7fffffff as int) 


select avg(total)-250 from [sales receipts]
tablesample(.1 percent)


alter table [dbo].[sales receipts] add primary key clustered 
(
  total asc,
    [id] asc
    )
    
select * from [sales receipts]
tablesample(1000 rows);

select * from [sales receipts]
tablesample(1000 rows)
repeatable(444);



    
    




























































































