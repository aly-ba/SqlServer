select * from Rectangles


declare @count int;
exec dbo.CountBigRecs 200000, @count output;
select @count



exec GetBigRecs 800000;

exec GetBigRecs null;


exec GetBigRecs2 800000;


exec GetBigRecs3 800000;

declare @affected int;
exec dbo.TrimAllWidths 5, @affected output
print @affected



exec  MakeError 10, 1, 'something happened';




