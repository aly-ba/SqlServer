/*============================================================================
  File:     estimated_subtree_cost.sql

  Summary:  Shows steps in a plan, can sort by estimated subtree cost.

  Date:     Sept 2008

  SQL Server Version: 10.0.1600.22 (RTM)
------------------------------------------------------------------------------
  Written by Bob Beauchemin, SQLskills.com

  For more scripts and sample code, check out http://www.SQLskills.com 
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================*/

-- Load XML from a file (file must be saved as Unicode)
DECLARE @x XML
SET @x = (
SELECT * FROM OPENROWSET(BULK 'C:\slowquery.sqlplan', SINGLE_BLOB) AS x
);

-- or put the XML plan inline
-- DECLARE @x XML
-- SET @x = '...your XML goes here'


-- if you don't want to use WITH XMLNAMESPACES, this goes in every XQuery that refers to elements
-- declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/showplan";

WITH XMLNAMESPACES(DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
SELECT 
       tab.col.value('./@LogicalOp', 'varchar(30)') as LogicalOp
     , tab.col.value('./@PhysicalOp', 'varchar(30)') as PhysicalOp
     , tab.col.value('count(./*/RelOp)', 'int') as NumChildren
     , tab.col.value('./@EstimatedTotalSubtreeCost', 'float') as SubtreeCost
     -- , CONVERT(decimal(10,6),tab.col.value('sum(./*/RelOp/@EstimatedTotalSubtreeCost)', 'float')) as SubtreeCostOfChildren
     , CONVERT(decimal(10,6),tab.col.value('sum(./@EstimatedTotalSubtreeCost) - sum(./*/RelOp/@EstimatedTotalSubtreeCost)', 'float')) as SubtreeCostOfThisStep
     , CONVERT(decimal(10,0),tab.col.value('(sum(./@EstimatedTotalSubtreeCost) - sum(./*/RelOp/@EstimatedTotalSubtreeCost)) div max(//RelOp/@EstimatedTotalSubtreeCost)', 'float') * 100) as PercentOfCost
     , CONVERT(varchar(256), tab.col.query('data(./*/Object/@*)')) as [Object]
     , tab.col.query('.') as ThisStepAsXML
     , tab.col.query('./*[not(RelOp)]') as DirectChildrenExceptRelOp   
FROM
@x.nodes('
/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple/QueryPlan//RelOp
') as tab(col)
ORDER BY SubtreeCostOfThisStep DESC
-- or...
-- ORDER BY PercentOfCost DESC
-- or...
-- unsorted, you can deduce the tree structure of the steps