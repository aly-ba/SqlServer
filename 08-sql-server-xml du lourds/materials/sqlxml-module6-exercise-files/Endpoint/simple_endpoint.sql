

sp_reserve_http_namespace N'http://*:80/somepath'

drop endpoint bobep

create endpoint bobep
state = started
as http
(
  site = '*',
  path = '/somepath',
  authentication = (integrated),
  ports = (clear)
)

for soap

(
  webmethod 'http://somens'.'localname'
    (name = 'pubs.dbo.byroyalty', schema = standard),
  wsdl = default,
  batches = enabled,
  database = 'pubs',
  namespace = 'http://ws_ns'
)