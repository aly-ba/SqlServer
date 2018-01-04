/*
T-SQL Window Functions Class
Demo1: Solving the Stock Market Problem
*/

--Run Demo0_Setup.sql to create the table

USE PL_SampleData;
GO


SELECT TickerSymbol, TradeDate, ClosePrice 
FROM dbo.StockHistory
ORDER BY TickerSymbol, TradeDate;

SELECT TickerSymbol, TradeDate, ClosePrice,
	ClosePrice - 
	LAG(ClosePrice) OVER(PARTITION BY TickerSymbol ORDER BY TradeDate) AS Dif
FROM dbo.StockHistory
ORDER BY TickerSymbol, TradeDate;







