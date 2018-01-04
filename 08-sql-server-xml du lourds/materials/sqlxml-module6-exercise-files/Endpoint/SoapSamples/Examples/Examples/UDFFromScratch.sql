select dbo.IntMul(3,4);

select dbo.[Integer Multiply](3,9);


create table MulTab
(
id int identity,
m1 int,
m2 int,
prod as dbo.[Integer Multiply](m1, m2) persisted
)

select OBJECTPROPERTY(OBJECT_ID('Integer Multiply'), 'IsDeterministic') as IsDeterministic,
OBJECTPROPERTY(OBJECT_ID('Integer Multiply'), 'IsPrecise') as IsPrecise


create function fmul(@m1 float, @m2 float)
returns float
begin
return @m1 * @m2;
end


select OBJECTPROPERTY(OBJECT_ID('fmul'), 'IsDeterministic') as IsDeterministic,
OBJECTPROPERTY(OBJECT_ID('fmul'), 'IsPrecise') as IsPrecise


