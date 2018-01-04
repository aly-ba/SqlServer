USE Credit;
GO

INSERT  [dbo].[charge]
        ([provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
VALUES  (1, -- provider_no - numeric_id
         34, -- category_no - numeric_id
         '2013-03-14 18:16:02', -- charge_dt - datetime
         10.22, -- charge_amt - money
         94, -- statement_no - numeric_id
         1  -- charge_code - status_code
         )
GO


-- Estimated number of rows for constant scan?
INSERT  [dbo].[charge]
        ([provider_no], [category_no], [charge_dt], [charge_amt],
         [statement_no], [charge_code])
VALUES  (1, -- provider_no - numeric_id
         34, -- category_no - numeric_id
         '2013-03-14 18:16:02', -- charge_dt - datetime
         10.22, -- charge_amt - money
         94, -- statement_no - numeric_id
         1  -- charge_code - status_code
         ),
        (2, -- provider_no - numeric_id
         33, -- category_no - numeric_id
         '2013-03-14 18:16:02', -- charge_dt - datetime
         10.99, -- charge_amt - money
         94, -- statement_no - numeric_id
         1  -- charge_code - status_code
         ),
        (2, -- provider_no - numeric_id
         22, -- category_no - numeric_id
         '2013-03-14 18:16:02', -- charge_dt - datetime
         19.99, -- charge_amt - money
         94, -- statement_no - numeric_id
         1  -- charge_code - status_code
         )

