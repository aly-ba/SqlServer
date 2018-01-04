use CLR1;
declare @result int
select @result = dbo.IntMul(3,4)
if(@result = 12)
print 'OK'
else
print 'Oops'

