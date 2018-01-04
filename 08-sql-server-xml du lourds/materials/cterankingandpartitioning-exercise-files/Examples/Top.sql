-- big table
select count(*) from [big table]

select * from [big table]


-- traditional top usage

select TOP 10 * from [big table] 
order by round([net worth], 0)

-- ties excluded by default
select TOP 10 with ties * from [big table] 
order by round([net worth], 0)


select top(cast(rand() *10 as int)) * from [big table]
order by [net worth]



-- do delete in chunks to minimize max lock/resources
updateMore:
delete TOP(100000) [big table]
if @@rowcount != 0
goto updateMore

-- this has been deprecated

deleteMore:
set @@rowcount = 100000
delete [big table]
if @@rowcount != 0
goto deleteMore













