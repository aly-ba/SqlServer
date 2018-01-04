USE CustomerManagement
GO

CREATE PROC dbo.Util_GetFirstOfMonth @Date DATE, @FirstOfMonth DATETIME OUTPUT AS
--Utility procedure to return the start of the month.
SET @FirstOfMonth = DATEADD(dd,1,EOMONTH(@Date,-1))

GO

CREATE PROC dbo.RptContactsWithinPeriod @WithinLastMonths INT, @RunAsAt DATE AS

--Display a summary of contacts and durations within the last X months
--Exclude current month as it is incomplete.

DECLARE @StartDate DATETIME, @EndDate DATETIME

EXEC Util_GetFirstOfMonth @Date = @RunAsAt, @FirstOfMonth = @EndDate OUTPUT

SET @StartDate = DATEADD(mm,-@WithinLastMonths,@EndDate)

SELECT  IT.InteractionTypeText,
		COUNT(*) Occurrences,
		SUM(DATEDIFF(MI,InteractionStartDT,InteractionEndDT)) TotalTimeMins
 FROM dbo.Interaction I 
 INNER JOIN dbo.InteractionType IT 
	ON IT.InteractionTypeID = I.InteractionTypeID
	WHERE I.InteractionStartDT >= @Startdate 
			AND I.InteractionStartDT < @Enddate
GROUP BY IT.InteractionTypeText


GO


