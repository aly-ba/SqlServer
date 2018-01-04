
USE tempdb
GO

-- entitized, correctly fits in XML data type
DECLARE @x xml
SET @x = '
<ShowPlanXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Version="1.0" Build="9.00.2153.00" xmlns="http://schemas.microsoft.com/sqlserver/2004/07/showplan">
  <BatchSequence>
    <Batch>
      <Statements>
        <StmtSimple StatementCompId="4" StatementEstRows="1" StatementId="1" StatementOptmLevel="FULL" StatementOptmEarlyAbortReason="GoodEnoughPlanFound" StatementSubTreeCost="1.69101E-05" 
                    StatementText="select count(*) from master.sys.sysprocesses where spid = @spid&#xD;&#xA;" StatementType="SELECT">
          <StatementSetOptions ANSI_NULLS="false" ANSI_PADDING="false" ANSI_WARNINGS="false" ARITHABORT="true" CONCAT_NULL_YIELDS_NULL="false" NUMERIC_ROUNDABORT="false" QUOTED_IDENTIFIER="false" />
          <QueryPlan DegreeOfParallelism="0" CachedPlanSize="8">
            <RelOp AvgRowSize="11" EstimateCPU="6.59492E-06" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="1" LogicalOp="Compute Scalar" NodeId="0" Parallel="false" PhysicalOp="Compute Scalar" EstimatedTotalSubtreeCost="1.69101E-05">
              <OutputList>
                <ColumnReference Column="Expr1000" />
              </OutputList>
              <ComputeScalar>
                <DefinedValues>
                  <DefinedValue>
                    <ColumnReference Column="Expr1000" />
                    <ScalarOperator ScalarString="CONVERT_IMPLICIT(int,[Expr1003],0)">
                      <Convert DataType="int" Style="0" Implicit="true">
                        <ScalarOperator>
                          <Identifier>
                            <ColumnReference Column="Expr1003" />
                          </Identifier>
                        </ScalarOperator>
                      </Convert>
                    </ScalarOperator>
                  </DefinedValue>
                </DefinedValues>
                <RelOp AvgRowSize="11" EstimateCPU="6.59492E-06" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="1" LogicalOp="Aggregate" NodeId="1" Parallel="false" PhysicalOp="Stream Aggregate" EstimatedTotalSubtreeCost="1.69101E-05">
                  <OutputList>
                    <ColumnReference Column="Expr1003" />
                  </OutputList>
                  <RunTimeInformation>
                    <RunTimeCountersPerThread Thread="0" ActualRows="1" ActualEndOfScans="1" ActualExecutions="1" />
                  </RunTimeInformation>
                  <StreamAggregate>
                    <DefinedValues>
                      <DefinedValue>
                        <ColumnReference Column="Expr1003" />
                        <ScalarOperator ScalarString="Count(*)">
                          <Aggregate AggType="countstar" Distinct="false" />
                        </ScalarOperator>
                      </DefinedValue>
                    </DefinedValues>
                    <RelOp AvgRowSize="9" EstimateCPU="1.03152E-05" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="10.1582" LogicalOp="Table-valued function" NodeId="2" Parallel="false" PhysicalOp="Table-valued function" EstimatedTotalSubtreeCost="1.03152E-05">
                      <OutputList />
                      <RunTimeInformation>
                        <RunTimeCountersPerThread Thread="0" ActualRebinds="1" ActualRewinds="0" ActualRows="1" ActualEndOfScans="1" ActualExecutions="1" />
                      </RunTimeInformation>
                      <TableValuedFunction>
                        <DefinedValues />
                        <Object Table="[SYSPROCESSES]" />
                        <ParameterList>
                          <ScalarOperator ScalarString="(1)">
                            <Const ConstValue="(1)" />
                          </ScalarOperator>
                          <ScalarOperator ScalarString="[@spid]">
                            <Identifier>
                              <ColumnReference Column="@spid" />
                            </Identifier>
                          </ScalarOperator>
                        </ParameterList>
                      </TableValuedFunction>
                    </RelOp>
                  </StreamAggregate>
                </RelOp>
              </ComputeScalar>
            </RelOp>
            <ParameterList>
              <ColumnReference Column="@spid" ParameterRuntimeValue="(51)" />
            </ParameterList>
          </QueryPlan>
        </StmtSimple>
      </Statements>
    </Batch>
  </BatchSequence>
</ShowPlanXML>'
GO

-- Add an entitized hex '01', now it doesn't parse
DECLARE @x xml
SET @x = '
<ShowPlanXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Version="1.0" Build="9.00.2153.00" xmlns="http://schemas.microsoft.com/sqlserver/2004/07/showplan">
  <BatchSequence>
    <Batch>
      <Statements>
        <StmtSimple StatementCompId="4" StatementEstRows="1" StatementId="1" StatementOptmLevel="FULL" StatementOptmEarlyAbortReason="GoodEnoughPlanFound" StatementSubTreeCost="1.69101E-05" 
                    StatementText="select count(*) from master.sys.sysprocesses where spid = @spid&#xD;&#xA;&#x1;" StatementType="SELECT">
          <StatementSetOptions ANSI_NULLS="false" ANSI_PADDING="false" ANSI_WARNINGS="false" ARITHABORT="true" CONCAT_NULL_YIELDS_NULL="false" NUMERIC_ROUNDABORT="false" QUOTED_IDENTIFIER="false" />
          <QueryPlan DegreeOfParallelism="0" CachedPlanSize="8">
            <RelOp AvgRowSize="11" EstimateCPU="6.59492E-06" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="1" LogicalOp="Compute Scalar" NodeId="0" Parallel="false" PhysicalOp="Compute Scalar" EstimatedTotalSubtreeCost="1.69101E-05">
              <OutputList>
                <ColumnReference Column="Expr1000" />
              </OutputList>
              <ComputeScalar>
                <DefinedValues>
                  <DefinedValue>
                    <ColumnReference Column="Expr1000" />
                    <ScalarOperator ScalarString="CONVERT_IMPLICIT(int,[Expr1003],0)">
                      <Convert DataType="int" Style="0" Implicit="true">
                        <ScalarOperator>
                          <Identifier>
                            <ColumnReference Column="Expr1003" />
                          </Identifier>
                        </ScalarOperator>
                      </Convert>
                    </ScalarOperator>
                  </DefinedValue>
                </DefinedValues>
                <RelOp AvgRowSize="11" EstimateCPU="6.59492E-06" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="1" LogicalOp="Aggregate" NodeId="1" Parallel="false" PhysicalOp="Stream Aggregate" EstimatedTotalSubtreeCost="1.69101E-05">
                  <OutputList>
                    <ColumnReference Column="Expr1003" />
                  </OutputList>
                  <RunTimeInformation>
                    <RunTimeCountersPerThread Thread="0" ActualRows="1" ActualEndOfScans="1" ActualExecutions="1" />
                  </RunTimeInformation>
                  <StreamAggregate>
                    <DefinedValues>
                      <DefinedValue>
                        <ColumnReference Column="Expr1003" />
                        <ScalarOperator ScalarString="Count(*)">
                          <Aggregate AggType="countstar" Distinct="false" />
                        </ScalarOperator>
                      </DefinedValue>
                    </DefinedValues>
                    <RelOp AvgRowSize="9" EstimateCPU="1.03152E-05" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="10.1582" LogicalOp="Table-valued function" NodeId="2" Parallel="false" PhysicalOp="Table-valued function" EstimatedTotalSubtreeCost="1.03152E-05">
                      <OutputList />
                      <RunTimeInformation>
                        <RunTimeCountersPerThread Thread="0" ActualRebinds="1" ActualRewinds="0" ActualRows="1" ActualEndOfScans="1" ActualExecutions="1" />
                      </RunTimeInformation>
                      <TableValuedFunction>
                        <DefinedValues />
                        <Object Table="[SYSPROCESSES]" />
                        <ParameterList>
                          <ScalarOperator ScalarString="(1)">
                            <Const ConstValue="(1)" />
                          </ScalarOperator>
                          <ScalarOperator ScalarString="[@spid]">
                            <Identifier>
                              <ColumnReference Column="@spid" />
                            </Identifier>
                          </ScalarOperator>
                        </ParameterList>
                      </TableValuedFunction>
                    </RelOp>
                  </StreamAggregate>
                </RelOp>
              </ComputeScalar>
            </RelOp>
            <ParameterList>
              <ColumnReference Column="@spid" ParameterRuntimeValue="(51)" />
            </ParameterList>
          </QueryPlan>
        </StmtSimple>
      </Statements>
    </Batch>
  </BatchSequence>
</ShowPlanXML>'

-- XML external unparsed entities
--
DECLARE @x XML
SET @x =
'<!DOCTYPE person [
  <!ENTITY n "<fname>Bob</fname><lname>Smith</lname>">
  <!ENTITY a "<age>53</age>">
]>
<person>
   <name>&n;</name>
   &a;
</person>'

DECLARE @x XML
SET @x =
CONVERT(XML,'<!DOCTYPE person [
  <!ENTITY n "<fname>Bob</fname><lname>Smith</lname>">
  <!ENTITY a "<age>53</age>">
]>
<person>
   <name>&n;</name>
   &a;
</person>',2)
SELECT @x


-- expand defaults
-- NO validation
DECLARE @x XML
SET @x = 
CONVERT(XML, '<!DOCTYPE company [
<!ELEMENT employees (employee*)>
<!ELEMENT employee (#PCDATA)>
<!ATTLIST employee
   name CDATA #REQUIRED
   species NMTOKEN #FIXED "human">
]>
<employees>
  <employee name="Bob"/>
  <employee name="Sam" species="cat"/>
</employees>',2)
SELECT @x
