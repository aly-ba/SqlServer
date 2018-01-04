
sp_reserve_http_namespace N'http://*:80/GenLed'

CREATE ENDPOINT genled 
STATE = STARTED
AS HTTP
(
  SITE='*',
  PATH='/GenLed',
  authentication = (integrated),
  ports = (clear)
)
FOR SOAP
(
WEBMETHOD
'http://tempUri.org/'.'byRoyalty'
(name='Pubs.dbo.ByRoyalty',
 schema=STANDARD ),

WSDL = DEFAULT,
BATCHES = ENABLED,
DATABASE = 'pubs',
NAMESPACE = 'urn:Accounting' 

)

exec byroyalty 50