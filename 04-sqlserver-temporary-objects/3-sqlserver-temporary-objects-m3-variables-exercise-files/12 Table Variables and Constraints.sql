-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

DECLARE @payment TABLE
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


-- Will a foreign key constraint work?
DECLARE @payment TABLE
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

ALTER TABLE @payment  WITH CHECK ADD CONSTRAINT [payment_member_link] FOREIGN KEY([member_no])
REFERENCES [dbo].[member] ([member_no]);
GO

-- Foreign keys are not permitted inline or named


-- Named constraints are also not permitted 

-- Temporary table
CREATE TABLE #payment
(
 [payment_no] INT IDENTITY(1, 1) NOT NULL,
 [member_no] INT NOT NULL,
 [payment_dt] [datetime] NOT NULL,
 [payment_amt] [money] NOT NULL
                       CHECK (([payment_amt] <> 0)),
 [statement_no] INT NULL
                    DEFAULT (0),
 [payment_code] CHAR(2) NOT NULL,
 CONSTRAINT [PK_payment_tv] PRIMARY KEY CLUSTERED ([payment_no])
);
GO

-- Table variable
DECLARE @payment TABLE
(
 [payment_no] INT IDENTITY(1, 1) NOT NULL,
 [member_no] INT NOT NULL,
 [payment_dt] [datetime] NOT NULL,
 [payment_amt] [money] NOT NULL
                       CHECK (([payment_amt] <> 0)),
 [statement_no] INT NULL
                    DEFAULT (0),
 [payment_code] CHAR(2) NOT NULL,
 CONSTRAINT [PK_payment_tv] PRIMARY KEY CLUSTERED ([payment_no])
);
GO



-- Cleanup
DROP TABLE [#payment];
GO
