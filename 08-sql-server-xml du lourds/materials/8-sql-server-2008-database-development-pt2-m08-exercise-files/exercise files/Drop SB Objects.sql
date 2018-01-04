USE veronicas;
GO

--Drop the conversation objects 

IF EXISTS (SELECT * FROM sys.services
           WHERE name =
           N'//VVDB/MSGGrp/TargetService')
     DROP SERVICE
     [//VVDB/MSGGrp/TargetService];

IF EXISTS (SELECT * FROM sys.service_queues
           WHERE name = N'TargetQueue1DB')
     DROP QUEUE TargetQueue1DB;

-- Drop the intitator queue and service if they already exist.
IF EXISTS (SELECT * FROM sys.services
           WHERE name =
           N'//VVDB/MSGGrp/InitiatorService')
     DROP SERVICE
     [//VVDB/MSGGrp/InitiatorService];

IF EXISTS (SELECT * FROM sys.service_queues
           WHERE name = N'InitiatorQueue1DB')
     DROP QUEUE InitiatorQueue1DB;

IF EXISTS (SELECT * FROM sys.service_contracts
           WHERE name =
           N'//VVDB/MSGGrp/SampleContract')
     DROP CONTRACT
     [//VVDB/MSGGrp/SampleContract];

IF EXISTS (SELECT * FROM sys.service_message_types
           WHERE name =
           N'//VVDB/MSGGrp/RequestMessage')
     DROP MESSAGE TYPE
     [//VVDB/MSGGrp/RequestMessage];

IF EXISTS (SELECT * FROM sys.service_message_types
           WHERE name =
           N'//VVDB/MSGGrp/ReplyMessage')
     DROP MESSAGE TYPE
     [//VVDB/MSGGrp/ReplyMessage];
GO