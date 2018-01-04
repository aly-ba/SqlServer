  SELECT    s.OfficialName,
            s.CommonName,
            s.Planet,
            s.Location,
            tl.TransitLogID,
            tl.ShipmentStartTime,
            tl.TransitLegOrder,
            es.OfficialName,
            es.CommonName,
            es.Planet,
            es.Location,
            ship.Priority,
            ship.HasTemperatureControlled,
            ship.HasHazardous,
            ship.HasLivestock,
            ship.ReferenceNumber
  FROM      dbo.Stations s
            INNER JOIN dbo.TransitLog tl ON tl.StartingStationID = s.StationID
            INNER JOIN dbo.Stations es ON es.StationID = tl.EndingStationID
            INNER JOIN dbo.Shipments ship ON ship.ShipmentID = tl.ShipmentID
  WHERE     s.Location = 'Low Orbit';
  GO
  


  SELECT COUNT(*) FROM dbo.TransitLog;