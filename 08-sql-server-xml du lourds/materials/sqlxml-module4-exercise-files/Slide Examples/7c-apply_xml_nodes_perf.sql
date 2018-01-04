
-- Consider the following script, which seeks to retrieve the data 
-- from the title elements at each level of the XML:

-- ParentAxisAccessFixDemo
-- run via SSMS with Include Actual Execution Plan turned on

/*
If we examine the XML, we see that each node will have, at maximum, 
one title attribute.  There can be any number of level0 nodes under 
the root solutionmap node, any number of level1 nodes under a 
particular level0 node, and so on.  Each of them will have a single 
title attribute, and we wish to retrieve them all. 
*/

DECLARE @xml XML

SET @xml ='<solutionmap>
      <title>SolutionX</title>
      <level0-item><title>ScenarioGroupA</title>
           <level1-item><title>Scenario1</title>
                  <process><title>ProcessA</title></process>
            </level1-item>
            <level1-item><title>Scenario2</title>
                  <process><title>ProcessA</title></process>
                  <process><title>ProcessB</title></process>
            </level1-item>
      </level0-item>
      <level0-item><title>ScenarioGroupB</title>
            <level1-item><title>Scenario1</title>
                  <process><title>ProcessA</title></process>
            </level1-item>
            <level1-item><title>Scenario2</title>
                  <process><title>ProcessA</title></process>
                  <process><title>ProcessB</title></process>
            </level1-item>
      </level0-item>
      <title>SolutionX</title>
      <level0-item><title>ScenarioGroupA</title>
            <level1-item><title>Scenario1</title>
                  <process><title>ProcessA</title></process>
            </level1-item>
            <level1-item><title>Scenario2</title>
                  <process><title>ProcessA</title></process>
                  <process><title>ProcessB</title></process>
            </level1-item>
      </level0-item>
      <level0-item><title>ScenarioGroupB</title>
            <level1-item><title>Scenario1</title>
                  <process><title>ProcessA</title></process>
            </level1-item>
            <level1-item><title>Scenario2</title>
                  <process><title>ProcessA</title></process>
                  <process><title>ProcessB</title></process>
            </level1-item>
      </level0-item>
</solutionmap>'

SELECT  @xml

SELECT  c.value('(../../../title/text())[1]', 'nvarchar(100)') AS Solution,
        c.value('(../../title/text())[1]', 'nvarchar(100)')    AS ScenarioGroup,
        c.value('(../title/text())[1]', 'nvarchar(100)')       AS Scenario,
        c.value('(title/text())[1]', 'nvarchar(100)')          AS Capability
FROM    @xml.nodes('/solutionmap[1]/level0-item/level1-item/process')
AS      t(c)

-- the query above is 87% of total cost of my single proc system

 

SELECT  sm.sm.value('(title/text())[1]', 'nvarchar(100)')     AS Solution,
        l0.item.value('(title/text())[1]', 'nvarchar(100)')   AS ScenarioGroup,
        l1.item.value('(title/text())[1]', 'nvarchar(100)')   AS Scenario,
        p.process.value('(title/text())[1]', 'nvarchar(100)') AS Capability
FROM    @xml.nodes('/solutionmap[1]')
AS      sm(sm)
CROSS APPLY
        sm.sm.nodes('level0-item')
AS      l0(item)
CROSS APPLY
        l0.item.nodes('level1-item')
AS      l1(item)
CROSS APPLY
        l1.item.nodes('process')
AS      p(process)

-- the query above is 13% of total cost of my single proc system
