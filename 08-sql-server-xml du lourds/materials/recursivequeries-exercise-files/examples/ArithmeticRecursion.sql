with f1(A, B)
as
(
select 502, 4
union all
select A-1, B+A from f1
where not A <= 1
)
select B from f1
where A = 1
option (maxrecursion 0)



create  function f1(@A int, @B int)
returns int
as
BEGIN
if(@A <= 1) return @B;
return dbo.f1(@A -1, @B + @A);
END

select dbo.f1(100,4)




