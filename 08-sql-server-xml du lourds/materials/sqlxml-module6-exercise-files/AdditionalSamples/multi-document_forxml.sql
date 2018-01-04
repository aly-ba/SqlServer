-- To demonstarate how this can be done, I am going to use an example from the W3C XML Query Use Case Document - section 1.4.4.6. This example uses 2 XML source documents - items.xml (which contains XML data about items for sale in an auction) and bids.xml (which contains XML data about bids in an auction system). I create a simple table (AuctionData) with an XML data type column in it (xml_data) and insert these 2 instaces, each in it's own row of the database. The FOR XML query which is used to aggregate these instances together is the following:

select cast( xml_data as xml )
from AuctionData
for xml raw( '' ), elements, type

-- This FOR XML query returns a sequence of XML nodes comprising of all the top level <items> and <bids> elements. We now apply XQuery to this FOR XML query:

select
( select cast(xml_data as xml)
  from AuctionData
  for xml raw(''), elements, type ).query('
<result>
 {
  for $item in /items/item
  where $item/reserve_price[1] * 2 < max(/bids/bid[itemno[1] = $item/itemno]/bid_price)
  return
   <successful_item>
    { $item/itemno }
    { $item/description }
    { $item/reserve_price }
    <high_bid>{ max(/bids/bid[itemno[1] = $item/itemno]/bid_price) }</high_bid>
   </successful_item>
 }
</result>')

