USE Credit;
GO

SELECT  [charge_no],
        [category_no],
        [charge_amt],
        NTILE(10) OVER (PARTITION BY [category_no] 
		                ORDER BY [category_no], [charge_amt])
						AS [ntile_value]
FROM dbo.[charge] AS c;
GO


