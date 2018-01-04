EXEC sp_create_plan_guide @name = N'ForcerdPlanforClientTransactions',
@stmt = N'SELECT c.LegalName,
       ss.OfficialName,
       s.Priority,
	   s.ReferenceNumber,
       SUM(t.Amount) AS ShipmentTotal,
	   sd.TotalMass,
	   sd.TotalVolume,
	   sd.TotalContainers
	FROM dbo.Clients c 
		INNER JOIN dbo.Shipments s ON s.ClientID = c.ClientID 
		INNER JOIN (SELECT shipmentID, SUM(Mass) AS TotalMass, SUM(Volume) AS TotalVolume, SUM(NumberOfContainers) AS TotalContainers FROM dbo.ShipmentDetails GROUP BY ShipmentID) sd ON sd.ShipmentID = s.ShipmentID
		INNER JOIN dbo.Transactions t ON t.ReferenceShipmentID = s.ShipmentID
		INNER JOIN dbo.StarSystems ss ON ss.StarSystemID = c.HeadquarterSystemID
	WHERE s.Priority = @Priority AND c.ClientID = @ClientID
	GROUP BY c.LegalName,
             ss.OfficialName,
             s.Priority,
             s.ReferenceNumber,
             sd.TotalMass,
             sd.TotalVolume,
             sd.TotalContainers',
@type = N'OBJECT',
@module_or_batch = 'GetClientTransactions',
@hints = N'OPTION (USE PLAN N''<ShowPlanXML xmlns="http://schemas.microsoft.com/sqlserver/2004/07/showplan" Version="1.5" Build="13.0.4202.2">
  <BatchSequence>
    <Batch>
      <Statements>
        <StmtSimple StatementText="-- useful for showing off bad parameter sniffing&#xD;&#xA;&#xD;&#xA;CREATE PROCEDURE [dbo].[GetClientTransactions] (@Priority TINYINT, @ClientID INT)&#xD;&#xA;AS&#xD;&#xA;&#xD;&#xA;SELECT c.LegalName,&#xD;&#xA;       ss.OfficialName,&#xD;&#xA;       s.Priority,&#xD;&#xA;	   s.ReferenceNumber,&#xD;&#xA;       SUM(t.Amount) AS ShipmentTotal,&#xD;&#xA;	   sd.TotalMass,&#xD;&#xA;	   sd.TotalVolume,&#xD;&#xA;	   sd.TotalContainers&#xD;&#xA;	FROM dbo.Clients c &#xD;&#xA;		INNER JOIN dbo.Shipments s ON s.ClientID = c.ClientID &#xD;&#xA;		INNER JOIN (SELECT shipmentID, SUM(Mass) AS TotalMass, SUM(Volume) AS TotalVolume, SUM(NumberOfContainers) AS TotalContainers FROM dbo.ShipmentDetails GROUP BY ShipmentID) sd ON sd.ShipmentID = s.ShipmentID&#xD;&#xA;		INNER JOIN dbo.Transactions t ON t.ReferenceShipmentID = s.ShipmentID&#xD;&#xA;		INNER JOIN dbo.StarSystems ss ON ss.StarSystemID = c.HeadquarterSystemID&#xD;&#xA;	WHERE s.Priority = @Priority AND c.ClientID = @ClientID&#xD;&#xA;	GROUP BY c.LegalName,&#xD;&#xA;             ss.OfficialName,&#xD;&#xA;             s.Priority,&#xD;&#xA;             s.ReferenceNumber,&#xD;&#xA;             sd.TotalMass,&#xD;&#xA;             sd.TotalVolume,&#xD;&#xA;             sd.TotalContainers" StatementId="1" StatementCompId="3" StatementType="SELECT" StatementSqlHandle="0x09006CD601CDDF6833013A38664D6D0CD43F0000000000000000000000000000000000000000000000000000" DatabaseContextSettingsId="4" ParentObjectId="1541580530" StatementParameterizationType="0" RetrievedFromCache="true" StatementSubTreeCost="1.33561" StatementEstRows="25.4428" SecurityPolicyApplied="false" StatementOptmLevel="FULL" QueryHash="0xD8664D278187A531" QueryPlanHash="0xCA2E3C3EC73511E1" StatementOptmEarlyAbortReason="TimeOut" CardinalityEstimationModelVersion="130">
          <StatementSetOptions QUOTED_IDENTIFIER="true" ARITHABORT="true" CONCAT_NULL_YIELDS_NULL="true" ANSI_NULLS="true" ANSI_PADDING="true" ANSI_WARNINGS="true" NUMERIC_ROUNDABORT="false" />
          <QueryPlan CachedPlanSize="144" CompileTime="7" CompileCPU="7" CompileMemory="1120">
            <MemoryGrantInfo SerialRequiredMemory="2560" SerialDesiredMemory="2848" />
            <OptimizerHardwareDependentProperties EstimatedAvailableMemoryGrant="64000" EstimatedPagesCached="32000" EstimatedAvailableDegreeOfParallelism="4" MaxCompileMemory="3574072" />
            <RelOp NodeId="0" PhysicalOp="Compute Scalar" LogicalOp="Compute Scalar" EstimateRows="25.4428" EstimateIO="0" EstimateCPU="0" AvgRowSize="169" EstimatedTotalSubtreeCost="1.33561" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
              <OutputList>
                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="LegalName" />
                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                <ColumnReference Column="Expr1004" />
                <ColumnReference Column="Expr1005" />
                <ColumnReference Column="Expr1006" />
                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="OfficialName" />
                <ColumnReference Column="Expr1009" />
              </OutputList>
              <ComputeScalar>
                <DefinedValues>
                  <DefinedValue>
                    <ColumnReference Column="Expr1009" />
                    <ScalarOperator ScalarString="CASE WHEN [Expr1017]=(0) THEN NULL ELSE [Expr1018] END">
                      <IF>
                        <Condition>
                          <ScalarOperator>
                            <Compare CompareOp="EQ">
                              <ScalarOperator>
                                <Identifier>
                                  <ColumnReference Column="Expr1017" />
                                </Identifier>
                              </ScalarOperator>
                              <ScalarOperator>
                                <Const ConstValue="(0)" />
                              </ScalarOperator>
                            </Compare>
                          </ScalarOperator>
                        </Condition>
                        <Then>
                          <ScalarOperator>
                            <Const ConstValue="NULL" />
                          </ScalarOperator>
                        </Then>
                        <Else>
                          <ScalarOperator>
                            <Identifier>
                              <ColumnReference Column="Expr1018" />
                            </Identifier>
                          </ScalarOperator>
                        </Else>
                      </IF>
                    </ScalarOperator>
                  </DefinedValue>
                </DefinedValues>
                <RelOp NodeId="1" PhysicalOp="Stream Aggregate" LogicalOp="Aggregate" EstimateRows="25.4428" EstimateIO="0" EstimateCPU="0.000206354" AvgRowSize="169" EstimatedTotalSubtreeCost="1.33561" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                  <OutputList>
                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="LegalName" />
                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                    <ColumnReference Column="Expr1004" />
                    <ColumnReference Column="Expr1005" />
                    <ColumnReference Column="Expr1006" />
                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="OfficialName" />
                    <ColumnReference Column="Expr1017" />
                    <ColumnReference Column="Expr1018" />
                  </OutputList>
                  <StreamAggregate>
                    <DefinedValues>
                      <DefinedValue>
                        <ColumnReference Column="Expr1017" />
                        <ScalarOperator ScalarString="COUNT_BIG([InterStellarTransport].[dbo].[Transactions].[Amount] as [t].[Amount])">
                          <Aggregate Distinct="0" AggType="COUNT_BIG">
                            <ScalarOperator>
                              <Identifier>
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="Amount" />
                              </Identifier>
                            </ScalarOperator>
                          </Aggregate>
                        </ScalarOperator>
                      </DefinedValue>
                      <DefinedValue>
                        <ColumnReference Column="Expr1018" />
                        <ScalarOperator ScalarString="SUM([InterStellarTransport].[dbo].[Transactions].[Amount] as [t].[Amount])">
                          <Aggregate Distinct="0" AggType="SUM">
                            <ScalarOperator>
                              <Identifier>
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="Amount" />
                              </Identifier>
                            </ScalarOperator>
                          </Aggregate>
                        </ScalarOperator>
                      </DefinedValue>
                      <DefinedValue>
                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="LegalName" />
                        <ScalarOperator ScalarString="ANY([InterStellarTransport].[dbo].[Clients].[LegalName] as [c].[LegalName])">
                          <Aggregate Distinct="0" AggType="ANY">
                            <ScalarOperator>
                              <Identifier>
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="LegalName" />
                              </Identifier>
                            </ScalarOperator>
                          </Aggregate>
                        </ScalarOperator>
                      </DefinedValue>
                      <DefinedValue>
                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="OfficialName" />
                        <ScalarOperator ScalarString="ANY([InterStellarTransport].[dbo].[StarSystems].[OfficialName] as [ss].[OfficialName])">
                          <Aggregate Distinct="0" AggType="ANY">
                            <ScalarOperator>
                              <Identifier>
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="OfficialName" />
                              </Identifier>
                            </ScalarOperator>
                          </Aggregate>
                        </ScalarOperator>
                      </DefinedValue>
                      <DefinedValue>
                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                        <ScalarOperator ScalarString="ANY([InterStellarTransport].[dbo].[Shipments].[Priority] as [s].[Priority])">
                          <Aggregate Distinct="0" AggType="ANY">
                            <ScalarOperator>
                              <Identifier>
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                              </Identifier>
                            </ScalarOperator>
                          </Aggregate>
                        </ScalarOperator>
                      </DefinedValue>
                    </DefinedValues>
                    <GroupBy>
                      <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                      <ColumnReference Column="Expr1004" />
                      <ColumnReference Column="Expr1005" />
                      <ColumnReference Column="Expr1006" />
                    </GroupBy>
                    <RelOp NodeId="2" PhysicalOp="Sort" LogicalOp="Sort" EstimateRows="322.722" EstimateIO="0.0112613" EstimateCPU="0.00429595" AvgRowSize="157" EstimatedTotalSubtreeCost="1.33541" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                      <OutputList>
                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="LegalName" />
                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                        <ColumnReference Column="Expr1004" />
                        <ColumnReference Column="Expr1005" />
                        <ColumnReference Column="Expr1006" />
                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="Amount" />
                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="OfficialName" />
                      </OutputList>
                      <MemoryFractions Input="0.5" Output="1" />
                      <Sort Distinct="0">
                        <OrderBy>
                          <OrderByColumn Ascending="1">
                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                          </OrderByColumn>
                          <OrderByColumn Ascending="1">
                            <ColumnReference Column="Expr1004" />
                          </OrderByColumn>
                          <OrderByColumn Ascending="1">
                            <ColumnReference Column="Expr1005" />
                          </OrderByColumn>
                          <OrderByColumn Ascending="1">
                            <ColumnReference Column="Expr1006" />
                          </OrderByColumn>
                        </OrderBy>
                        <RelOp NodeId="3" PhysicalOp="Hash Match" LogicalOp="Inner Join" EstimateRows="322.722" EstimateIO="0" EstimateCPU="0.0194966" AvgRowSize="157" EstimatedTotalSubtreeCost="1.31985" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                          <OutputList>
                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="LegalName" />
                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                            <ColumnReference Column="Expr1004" />
                            <ColumnReference Column="Expr1005" />
                            <ColumnReference Column="Expr1006" />
                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="Amount" />
                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="OfficialName" />
                          </OutputList>
                          <MemoryFractions Input="0.222222" Output="0.111111" />
                          <Hash>
                            <DefinedValues />
                            <HashKeysBuild>
                              <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="StarSystemID" />
                            </HashKeysBuild>
                            <HashKeysProbe>
                              <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="HeadquarterSystemID" />
                            </HashKeysProbe>
                            <RelOp NodeId="4" PhysicalOp="Clustered Index Scan" LogicalOp="Clustered Index Scan" EstimateRows="1" EstimatedRowsRead="1" EstimateIO="0.003125" EstimateCPU="0.0001581" AvgRowSize="40" EstimatedTotalSubtreeCost="0.0032831" TableCardinality="1" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                              <OutputList>
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="StarSystemID" />
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="OfficialName" />
                              </OutputList>
                              <IndexScan Ordered="0" ForcedIndex="0" ForceScan="0" NoExpandHint="0" Storage="RowStore">
                                <DefinedValues>
                                  <DefinedValue>
                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="StarSystemID" />
                                  </DefinedValue>
                                  <DefinedValue>
                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Alias="[ss]" Column="OfficialName" />
                                  </DefinedValue>
                                </DefinedValues>
                                <Object Database="[InterStellarTransport]" Schema="[dbo]" Table="[StarSystems]" Index="[PK__StarSyst__96DBC20BCE174BA4]" Alias="[ss]" IndexKind="Clustered" Storage="RowStore" />
                              </IndexScan>
                            </RelOp>
                            <RelOp NodeId="5" PhysicalOp="Nested Loops" LogicalOp="Inner Join" EstimateRows="322.722" EstimateIO="0" EstimateCPU="0.00134898" AvgRowSize="134" EstimatedTotalSubtreeCost="1.29707" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                              <OutputList>
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="LegalName" />
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="HeadquarterSystemID" />
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                                <ColumnReference Column="Expr1004" />
                                <ColumnReference Column="Expr1005" />
                                <ColumnReference Column="Expr1006" />
                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="Amount" />
                              </OutputList>
                              <NestedLoops Optimized="0">
                                <RelOp NodeId="6" PhysicalOp="Clustered Index Seek" LogicalOp="Clustered Index Seek" EstimateRows="1" EstimatedRowsRead="1" EstimateIO="0.003125" EstimateCPU="0.0001581" AvgRowSize="65" EstimatedTotalSubtreeCost="0.0032831" TableCardinality="5000" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                  <OutputList>
                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="LegalName" />
                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="HeadquarterSystemID" />
                                  </OutputList>
                                  <IndexScan Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" ForceScan="0" NoExpandHint="0" Storage="RowStore">
                                    <DefinedValues>
                                      <DefinedValue>
                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="LegalName" />
                                      </DefinedValue>
                                      <DefinedValue>
                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="HeadquarterSystemID" />
                                      </DefinedValue>
                                    </DefinedValues>
                                    <Object Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Index="[PK__Clients__E67E1A04D5659412]" Alias="[c]" IndexKind="Clustered" Storage="RowStore" />
                                    <SeekPredicates>
                                      <SeekPredicateNew>
                                        <SeekKeys>
                                          <Prefix ScanType="EQ">
                                            <RangeColumns>
                                              <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Clients]" Alias="[c]" Column="ClientID" />
                                            </RangeColumns>
                                            <RangeExpressions>
                                              <ScalarOperator ScalarString="[@ClientID]">
                                                <Identifier>
                                                  <ColumnReference Column="@ClientID" />
                                                </Identifier>
                                              </ScalarOperator>
                                            </RangeExpressions>
                                          </Prefix>
                                        </SeekKeys>
                                      </SeekPredicateNew>
                                    </SeekPredicates>
                                  </IndexScan>
                                </RelOp>
                                <RelOp NodeId="7" PhysicalOp="Nested Loops" LogicalOp="Inner Join" EstimateRows="322.722" EstimateIO="0" EstimateCPU="0.00134898" AvgRowSize="76" EstimatedTotalSubtreeCost="1.29244" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                  <OutputList>
                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                                    <ColumnReference Column="Expr1004" />
                                    <ColumnReference Column="Expr1005" />
                                    <ColumnReference Column="Expr1006" />
                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="Amount" />
                                  </OutputList>
                                  <MemoryFractions Input="0" Output="0.277778" />
                                  <NestedLoops Optimized="1" WithUnorderedPrefetch="1">
                                    <OuterReferences>
                                      <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="TransactionID" />
                                      <ColumnReference Column="Expr1016" />
                                    </OuterReferences>
                                    <RelOp NodeId="10" PhysicalOp="Nested Loops" LogicalOp="Inner Join" EstimateRows="322.722" EstimateIO="0" EstimateCPU="0.00134898" AvgRowSize="75" EstimatedTotalSubtreeCost="0.245948" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                      <OutputList>
                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                                        <ColumnReference Column="Expr1004" />
                                        <ColumnReference Column="Expr1005" />
                                        <ColumnReference Column="Expr1006" />
                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="TransactionID" />
                                      </OutputList>
                                      <MemoryFractions Input="0" Output="0.111111" />
                                      <NestedLoops Optimized="1" WithUnorderedPrefetch="1">
                                        <OuterReferences>
                                          <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="ShipmentID" />
                                          <ColumnReference Column="Expr1015" />
                                        </OuterReferences>
                                        <RelOp NodeId="13" PhysicalOp="Stream Aggregate" LogicalOp="Aggregate" EstimateRows="25.443" EstimateIO="0" EstimateCPU="8.90506e-005" AvgRowSize="75" EstimatedTotalSubtreeCost="0.16401" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                          <OutputList>
                                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="ShipmentID" />
                                            <ColumnReference Column="Expr1004" />
                                            <ColumnReference Column="Expr1005" />
                                            <ColumnReference Column="Expr1006" />
                                          </OutputList>
                                          <StreamAggregate>
                                            <DefinedValues>
                                              <DefinedValue>
                                                <ColumnReference Column="Expr1004" />
                                                <ScalarOperator ScalarString="SUM([InterStellarTransport].[dbo].[ShipmentDetails].[Mass])">
                                                  <Aggregate Distinct="0" AggType="SUM">
                                                    <ScalarOperator>
                                                      <Identifier>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="Mass" />
                                                      </Identifier>
                                                    </ScalarOperator>
                                                  </Aggregate>
                                                </ScalarOperator>
                                              </DefinedValue>
                                              <DefinedValue>
                                                <ColumnReference Column="Expr1005" />
                                                <ScalarOperator ScalarString="SUM([InterStellarTransport].[dbo].[ShipmentDetails].[Volume])">
                                                  <Aggregate Distinct="0" AggType="SUM">
                                                    <ScalarOperator>
                                                      <Identifier>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="Volume" />
                                                      </Identifier>
                                                    </ScalarOperator>
                                                  </Aggregate>
                                                </ScalarOperator>
                                              </DefinedValue>
                                              <DefinedValue>
                                                <ColumnReference Column="Expr1006" />
                                                <ScalarOperator ScalarString="SUM([InterStellarTransport].[dbo].[ShipmentDetails].[NumberOfContainers])">
                                                  <Aggregate Distinct="0" AggType="SUM">
                                                    <ScalarOperator>
                                                      <Identifier>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="NumberOfContainers" />
                                                      </Identifier>
                                                    </ScalarOperator>
                                                  </Aggregate>
                                                </ScalarOperator>
                                              </DefinedValue>
                                              <DefinedValue>
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                                <ScalarOperator ScalarString="ANY([InterStellarTransport].[dbo].[Shipments].[Priority] as [s].[Priority])">
                                                  <Aggregate Distinct="0" AggType="ANY">
                                                    <ScalarOperator>
                                                      <Identifier>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                                      </Identifier>
                                                    </ScalarOperator>
                                                  </Aggregate>
                                                </ScalarOperator>
                                              </DefinedValue>
                                              <DefinedValue>
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                                                <ScalarOperator ScalarString="ANY([InterStellarTransport].[dbo].[Shipments].[ReferenceNumber] as [s].[ReferenceNumber])">
                                                  <Aggregate Distinct="0" AggType="ANY">
                                                    <ScalarOperator>
                                                      <Identifier>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                                                      </Identifier>
                                                    </ScalarOperator>
                                                  </Aggregate>
                                                </ScalarOperator>
                                              </DefinedValue>
                                              <DefinedValue>
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="ShipmentID" />
                                                <ScalarOperator ScalarString="ANY([InterStellarTransport].[dbo].[ShipmentDetails].[ShipmentID])">
                                                  <Aggregate Distinct="0" AggType="ANY">
                                                    <ScalarOperator>
                                                      <Identifier>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="ShipmentID" />
                                                      </Identifier>
                                                    </ScalarOperator>
                                                  </Aggregate>
                                                </ScalarOperator>
                                              </DefinedValue>
                                            </DefinedValues>
                                            <GroupBy>
                                              <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ShipmentID" />
                                            </GroupBy>
                                            <RelOp NodeId="14" PhysicalOp="Nested Loops" LogicalOp="Inner Join" EstimateRows="127.215" EstimateIO="0" EstimateCPU="0.000531759" AvgRowSize="53" EstimatedTotalSubtreeCost="0.163921" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                              <OutputList>
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ShipmentID" />
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="ShipmentID" />
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="Mass" />
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="Volume" />
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="NumberOfContainers" />
                                              </OutputList>
                                              <NestedLoops Optimized="0" WithUnorderedPrefetch="1">
                                                <OuterReferences>
                                                  <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ShipmentID" />
                                                  <ColumnReference Column="Expr1014" />
                                                </OuterReferences>
                                                <RelOp NodeId="16" PhysicalOp="Nested Loops" LogicalOp="Inner Join" EstimateRows="25.443" EstimateIO="0" EstimateCPU="0.000106352" AvgRowSize="37" EstimatedTotalSubtreeCost="0.0831474" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                                  <OutputList>
                                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ShipmentID" />
                                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                                                  </OutputList>
                                                  <NestedLoops Optimized="0" WithUnorderedPrefetch="1">
                                                    <OuterReferences>
                                                      <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ShipmentID" />
                                                      <ColumnReference Column="Expr1013" />
                                                    </OuterReferences>
                                                    <RelOp NodeId="18" PhysicalOp="Index Seek" LogicalOp="Index Seek" EstimateRows="25.443" EstimatedRowsRead="25.443" EstimateIO="0.003125" EstimateCPU="0.000184987" AvgRowSize="12" EstimatedTotalSubtreeCost="0.00330999" TableCardinality="200000" Parallel="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                                      <OutputList>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ShipmentID" />
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                                      </OutputList>
                                                      <IndexScan Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" ForceScan="0" NoExpandHint="0" Storage="RowStore">
                                                        <DefinedValues>
                                                          <DefinedValue>
                                                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ShipmentID" />
                                                          </DefinedValue>
                                                          <DefinedValue>
                                                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                                          </DefinedValue>
                                                        </DefinedValues>
                                                        <Object Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Index="[idx_Shipments_ClientIDPriority]" Alias="[s]" IndexKind="NonClustered" Storage="RowStore" />
                                                        <SeekPredicates>
                                                          <SeekPredicateNew>
                                                            <SeekKeys>
                                                              <Prefix ScanType="EQ">
                                                                <RangeColumns>
                                                                  <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ClientID" />
                                                                  <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="Priority" />
                                                                </RangeColumns>
                                                                <RangeExpressions>
                                                                  <ScalarOperator ScalarString="[@ClientID]">
                                                                    <Identifier>
                                                                      <ColumnReference Column="@ClientID" />
                                                                    </Identifier>
                                                                  </ScalarOperator>
                                                                  <ScalarOperator ScalarString="[@Priority]">
                                                                    <Identifier>
                                                                      <ColumnReference Column="@Priority" />
                                                                    </Identifier>
                                                                  </ScalarOperator>
                                                                </RangeExpressions>
                                                              </Prefix>
                                                            </SeekKeys>
                                                          </SeekPredicateNew>
                                                        </SeekPredicates>
                                                      </IndexScan>
                                                    </RelOp>
                                                    <RelOp NodeId="20" PhysicalOp="Clustered Index Seek" LogicalOp="Clustered Index Seek" EstimateRows="1" EstimateIO="0.003125" EstimateCPU="0.0001581" AvgRowSize="32" EstimatedTotalSubtreeCost="0.079731" TableCardinality="200000" Parallel="0" EstimateRebinds="24.443" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                                      <OutputList>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                                                      </OutputList>
                                                      <IndexScan Lookup="1" Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" ForceScan="0" NoExpandHint="0" Storage="RowStore">
                                                        <DefinedValues>
                                                          <DefinedValue>
                                                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ReferenceNumber" />
                                                          </DefinedValue>
                                                        </DefinedValues>
                                                        <Object Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Index="[PK__Shipment__5CAD378D06CD5950]" Alias="[s]" TableReferenceId="-1" IndexKind="Clustered" Storage="RowStore" />
                                                        <SeekPredicates>
                                                          <SeekPredicateNew>
                                                            <SeekKeys>
                                                              <Prefix ScanType="EQ">
                                                                <RangeColumns>
                                                                  <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ShipmentID" />
                                                                </RangeColumns>
                                                                <RangeExpressions>
                                                                  <ScalarOperator ScalarString="[InterStellarTransport].[dbo].[Shipments].[ShipmentID] as [s].[ShipmentID]">
                                                                    <Identifier>
                                                                      <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ShipmentID" />
                                                                    </Identifier>
                                                                  </ScalarOperator>
                                                                </RangeExpressions>
                                                              </Prefix>
                                                            </SeekKeys>
                                                          </SeekPredicateNew>
                                                        </SeekPredicates>
                                                      </IndexScan>
                                                    </RelOp>
                                                  </NestedLoops>
                                                </RelOp>
                                                <RelOp NodeId="21" PhysicalOp="Index Seek" LogicalOp="Index Seek" EstimateRows="5" EstimatedRowsRead="5" EstimateIO="0.003125" EstimateCPU="0.0001625" AvgRowSize="23" EstimatedTotalSubtreeCost="0.0802416" TableCardinality="1e+006" Parallel="0" EstimateRebinds="24.443" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                                  <OutputList>
                                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="ShipmentID" />
                                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="Mass" />
                                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="Volume" />
                                                    <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="NumberOfContainers" />
                                                  </OutputList>
                                                  <IndexScan Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" ForceScan="0" NoExpandHint="0" Storage="RowStore">
                                                    <DefinedValues>
                                                      <DefinedValue>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="ShipmentID" />
                                                      </DefinedValue>
                                                      <DefinedValue>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="Mass" />
                                                      </DefinedValue>
                                                      <DefinedValue>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="Volume" />
                                                      </DefinedValue>
                                                      <DefinedValue>
                                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="NumberOfContainers" />
                                                      </DefinedValue>
                                                    </DefinedValues>
                                                    <Object Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Index="[idx_ShipmentDetails_ShipmentID]" IndexKind="NonClustered" Storage="RowStore" />
                                                    <SeekPredicates>
                                                      <SeekPredicateNew>
                                                        <SeekKeys>
                                                          <Prefix ScanType="EQ">
                                                            <RangeColumns>
                                                              <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="ShipmentID" />
                                                            </RangeColumns>
                                                            <RangeExpressions>
                                                              <ScalarOperator ScalarString="[InterStellarTransport].[dbo].[Shipments].[ShipmentID] as [s].[ShipmentID]">
                                                                <Identifier>
                                                                  <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Shipments]" Alias="[s]" Column="ShipmentID" />
                                                                </Identifier>
                                                              </ScalarOperator>
                                                            </RangeExpressions>
                                                          </Prefix>
                                                        </SeekKeys>
                                                      </SeekPredicateNew>
                                                    </SeekPredicates>
                                                  </IndexScan>
                                                </RelOp>
                                              </NestedLoops>
                                            </RelOp>
                                          </StreamAggregate>
                                        </RelOp>
                                        <RelOp NodeId="22" PhysicalOp="Index Seek" LogicalOp="Index Seek" EstimateRows="12.6841" EstimatedRowsRead="12.6841" EstimateIO="0.003125" EstimateCPU="0.000170952" AvgRowSize="11" EstimatedTotalSubtreeCost="0.0805897" TableCardinality="2.5e+006" Parallel="0" EstimateRebinds="24.443" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                          <OutputList>
                                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="TransactionID" />
                                          </OutputList>
                                          <IndexScan Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" ForceScan="0" NoExpandHint="0" Storage="RowStore">
                                            <DefinedValues>
                                              <DefinedValue>
                                                <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="TransactionID" />
                                              </DefinedValue>
                                            </DefinedValues>
                                            <Object Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Index="[idx_Transactions_ReferenceShipmentID]" Alias="[t]" IndexKind="NonClustered" Storage="RowStore" />
                                            <SeekPredicates>
                                              <SeekPredicateNew>
                                                <SeekKeys>
                                                  <Prefix ScanType="EQ">
                                                    <RangeColumns>
                                                      <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="ReferenceShipmentID" />
                                                    </RangeColumns>
                                                    <RangeExpressions>
                                                      <ScalarOperator ScalarString="[InterStellarTransport].[dbo].[ShipmentDetails].[ShipmentID]">
                                                        <Identifier>
                                                          <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[ShipmentDetails]" Column="ShipmentID" />
                                                        </Identifier>
                                                      </ScalarOperator>
                                                    </RangeExpressions>
                                                  </Prefix>
                                                </SeekKeys>
                                              </SeekPredicateNew>
                                            </SeekPredicates>
                                          </IndexScan>
                                        </RelOp>
                                      </NestedLoops>
                                    </RelOp>
                                    <RelOp NodeId="24" PhysicalOp="Clustered Index Seek" LogicalOp="Clustered Index Seek" EstimateRows="1" EstimateIO="0.003125" EstimateCPU="0.0001581" AvgRowSize="12" EstimatedTotalSubtreeCost="1.04514" TableCardinality="2.5e+006" Parallel="0" EstimateRebinds="321.722" EstimateRewinds="0" EstimatedExecutionMode="Row">
                                      <OutputList>
                                        <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="Amount" />
                                      </OutputList>
                                      <IndexScan Lookup="1" Ordered="1" ScanDirection="FORWARD" ForcedIndex="0" ForceSeek="0" ForceScan="0" NoExpandHint="0" Storage="RowStore">
                                        <DefinedValues>
                                          <DefinedValue>
                                            <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="Amount" />
                                          </DefinedValue>
                                        </DefinedValues>
                                        <Object Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Index="[PK__Transact__55433A4B74832EF2]" Alias="[t]" TableReferenceId="-1" IndexKind="Clustered" Storage="RowStore" />
                                        <SeekPredicates>
                                          <SeekPredicateNew>
                                            <SeekKeys>
                                              <Prefix ScanType="EQ">
                                                <RangeColumns>
                                                  <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="TransactionID" />
                                                </RangeColumns>
                                                <RangeExpressions>
                                                  <ScalarOperator ScalarString="[InterStellarTransport].[dbo].[Transactions].[TransactionID] as [t].[TransactionID]">
                                                    <Identifier>
                                                      <ColumnReference Database="[InterStellarTransport]" Schema="[dbo]" Table="[Transactions]" Alias="[t]" Column="TransactionID" />
                                                    </Identifier>
                                                  </ScalarOperator>
                                                </RangeExpressions>
                                              </Prefix>
                                            </SeekKeys>
                                          </SeekPredicateNew>
                                        </SeekPredicates>
                                      </IndexScan>
                                    </RelOp>
                                  </NestedLoops>
                                </RelOp>
                              </NestedLoops>
                            </RelOp>
                          </Hash>
                        </RelOp>
                      </Sort>
                    </RelOp>
                  </StreamAggregate>
                </RelOp>
              </ComputeScalar>
            </RelOp>
            <ParameterList>
              <ColumnReference Column="@ClientID" ParameterDataType="int" ParameterCompiledValue="(251)" />
              <ColumnReference Column="@Priority" ParameterDataType="tinyint" ParameterCompiledValue="(2)" />
            </ParameterList>
          </QueryPlan>
        </StmtSimple>
      </Statements>
    </Batch>
  </BatchSequence>
</ShowPlanXML>'')';