-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- We can create constraints via CREATE TABLE or ALTER TABLE
CREATE TABLE #payment
(
 [payment_no] INT IDENTITY(1, 1)
                  NOT NULL
                  PRIMARY KEY,
 [member_no] INT NOT NULL,
 [payment_dt] [datetime] NOT NULL,
 [payment_amt] [money] NOT NULL
                       CHECK (([payment_amt] <> 0)),
 [statement_no] INT NULL
                    DEFAULT (0),
 [payment_code] CHAR(2) NOT NULL
);
GO


-- But will foreign key constraints work?
ALTER TABLE #payment  WITH CHECK ADD CONSTRAINT [payment_member_link] FOREIGN KEY([member_no])
REFERENCES [dbo].[member] ([member_no]);
GO


-- Cleanup
DROP TABLE #payment;
GO
