USE [Credit];
GO

CREATE FUNCTION dbo.mstvf_provider (@member_no INT = NULL)
RETURNS @provider TABLE
(
 [member_no] [int] NOT NULL,
 [lastname] [varchar](15) NOT NULL,
 [firstname] [varchar](15) NOT NULL,
 [region_no] [int] NOT NULL,
 [region_name] [varchar](15) NOT NULL,
 [provider_name] [varchar](15) NOT NULL,
 [category_desc] [varchar](31) NOT NULL,
 [charge_no] [int] NOT NULL,
 [provider_no] [int] NOT NULL,
 [category_no] [int] NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [charge_amt] [money] NOT NULL,
 [charge_code] [char](2) NOT NULL
)
AS 
BEGIN

    INSERT  @provider
	 SELECT 
		member.member_no,
        member.lastname,
        member.firstname,
        region.region_no,
        region.region_name,
        provider.provider_name,
        category.category_desc,
        charge.charge_no,
        charge.provider_no,
        charge.category_no,
        charge.charge_dt,
        charge.charge_amt,
        charge.charge_code
 FROM   member
 INNER JOIN charge ON
 member.member_no = charge.member_no 
 INNER JOIN region ON
 region.region_no = member.region_no
 INNER JOIN  provider ON
 provider.provider_no = charge.provider_no
 INNER JOIN category ON
 category.category_no = charge.category_no
 WHERE member.[member_no] = ISNULL(@member_no, member.[member_no]);

    RETURN
END
GO

-- Run both queries together
 SELECT TOP 1
		member.member_no,
        member.lastname,
        member.firstname
 FROM   dbo.member;

-- Will take a few seconds
SELECT  member_no, lastname, firstname
FROM    dbo.mstvf_provider(NULL);
GO



-- Cleanup
DROP FUNCTION dbo.mstvf_provider;
GO

