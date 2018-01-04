SELECT  c.LegalName,
        ss.OfficialName,
        s.Priority,
        s.ReferenceNumber,
        SUM(t.Amount) AS ShipmentTotal,
        sd.TotalMass,
        sd.TotalVolume,
        sd.TotalContainers
FROM    dbo.Clients c
        INNER JOIN dbo.Shipments s ON s.ClientID = c.ClientID
        INNER JOIN (SELECT  shipmentID,
                            SUM(Mass) AS TotalMass,
                            SUM(Volume) AS TotalVolume,
                            SUM(NumberOfContainers) AS TotalContainers
                    FROM    dbo.ShipmentDetails
                    GROUP BY ShipmentID
                   ) sd ON sd.ShipmentID = s.ShipmentID
        INNER JOIN dbo.Transactions t ON t.ReferenceShipmentID = s.ShipmentID
        INNER JOIN dbo.StarSystems ss ON ss.StarSystemID = c.HeadquarterSystemID
WHERE   s.Priority = 2
        AND c.ClientID = 652
GROUP BY c.LegalName,
        ss.OfficialName,
        s.Priority,
        s.ReferenceNumber,
        sd.TotalMass,
        sd.TotalVolume,
        sd.TotalContainers;
GO

SELECT  [Extent1].[ShipmentID] AS [ShipmentID],
        [Extent1].[ClientID] AS [ClientID],
        [Extent1].[Priority] AS [Priority],
        [Extent1].[OriginStationID] AS [OriginStationID],
        [Extent1].[DestinationStationID] AS [DestinationStationID],
        [Extent1].[HasTemperatureControlled] AS [HasTemperatureControlled],
        [Extent1].[HasHazardous] AS [HasHazardous],
        [Extent1].[HasLivestock] AS [HasLivestock],
        [Extent1].[ReferenceNumber] AS [ReferenceNumber]
FROM    [dbo].[Shipments] AS [Extent1]
WHERE   1 = [Extent1].[HasHazardous];
GO



SELECT  [Project2].[OriginStationID] AS [OriginStationID],
        [Project2].[C1] AS [C1],
        [Project2].[ShipmentID] AS [ShipmentID],
        [Project2].[ClientID] AS [ClientID],
        [Project2].[Priority] AS [Priority],
        [Project2].[OriginStationID1] AS [OriginStationID1],
        [Project2].[DestinationStationID] AS [DestinationStationID],
        [Project2].[HasTemperatureControlled] AS [HasTemperatureControlled],
        [Project2].[HasHazardous] AS [HasHazardous],
        [Project2].[HasLivestock] AS [HasLivestock],
        [Project2].[ReferenceNumber] AS [ReferenceNumber]
FROM    (SELECT [Distinct1].[OriginStationID] AS [OriginStationID],
                [Join2].[ShipmentID] AS [ShipmentID],
                [Join2].[ClientID] AS [ClientID],
                [Join2].[Priority] AS [Priority],
                [Join2].[OriginStationID] AS [OriginStationID1],
                [Join2].[DestinationStationID] AS [DestinationStationID],
                [Join2].[HasTemperatureControlled] AS [HasTemperatureControlled],
                [Join2].[HasHazardous] AS [HasHazardous],
                [Join2].[HasLivestock] AS [HasLivestock],
                [Join2].[ReferenceNumber] AS [ReferenceNumber],
                CASE WHEN ([Join2].[StationID] IS NULL) THEN CAST(NULL AS INT)
                     ELSE 1
                END AS [C1]
         FROM   (SELECT DISTINCT
                        [Extent2].[OriginStationID] AS [OriginStationID]
                 FROM   [dbo].[Stations] AS [Extent1]
                        INNER JOIN [dbo].[Shipments] AS [Extent2] ON [Extent1].[StationID] = [Extent2].[OriginStationID]
                 WHERE  1 = [Extent1].[StarSystemID]
                ) AS [Distinct1]
                LEFT OUTER JOIN (SELECT [Extent3].[StationID] AS [StationID],
                                        [Extent3].[StarSystemID] AS [StarSystemID],
                                        [Extent4].[ShipmentID] AS [ShipmentID],
                                        [Extent4].[ClientID] AS [ClientID],
                                        [Extent4].[Priority] AS [Priority],
                                        [Extent4].[OriginStationID] AS [OriginStationID],
                                        [Extent4].[DestinationStationID] AS [DestinationStationID],
                                        [Extent4].[HasTemperatureControlled] AS [HasTemperatureControlled],
                                        [Extent4].[HasHazardous] AS [HasHazardous],
                                        [Extent4].[HasLivestock] AS [HasLivestock],
                                        [Extent4].[ReferenceNumber] AS [ReferenceNumber]
                                 FROM   [dbo].[Stations] AS [Extent3]
                                        INNER JOIN [dbo].[Shipments] AS [Extent4] ON [Extent3].[StationID] = [Extent4].[OriginStationID]
                                ) AS [Join2] ON (1 = [Join2].[StarSystemID])
                                                AND ([Distinct1].[OriginStationID] = [Join2].[OriginStationID])
        ) AS [Project2]
ORDER BY [Project2].[OriginStationID] ASC,
        [Project2].[C1] ASC;
GO


SELECT  [Extent1].[ClientID] [ClientID],
        [Extent1].[LegalName] [LegalName],
        [Extent1].[HeadquarterSystemID] [HeadquarterSystemID],
        [Extent1].[HypernetAddress] [HypernetAddress]
FROM    [dbo].[Clients] [Extent1]
WHERE   1 = [Extent1].[HeadquarterSystemID];
SELECT  [Extent4].[RouteID] AS [RouteID],
        [Extent4].[StartStationID] AS [StartStationID],
        [Extent4].[EndStationID] AS [EndStationID],
        [Extent4].[RouteLength] AS [RouteLength]
FROM    [dbo].[StarSystems] AS [Extent1]
        INNER JOIN [dbo].[Stations] AS [Extent2] ON [Extent1].[StarSystemID] = [Extent2].[StarSystemID]
        INNER JOIN [dbo].[RouteStations] AS [Extent3] ON [Extent2].[StationID] = [Extent3].[StationID]
        INNER JOIN [dbo].[routes] AS [Extent4] ON [Extent3].[RouteID] = [Extent4].[RouteID]
WHERE   1 = [Extent1].[IsVariable];
