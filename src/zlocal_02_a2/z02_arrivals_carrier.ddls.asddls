@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'arrivals with carrier'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z02_arrivals_carrier as
  select from /dmo/flight as Flight
    join /dmo/connection as Connection
      on Flight.carrier_id = Connection.carrier_id
      and Flight.connection_id = Connection.connection_id
    join /dmo/airport as Airport
      on Connection.airport_to_id = Airport.airport_id
    join /dmo/carrier as Carrier
      on Flight.carrier_id = Carrier.carrier_id
{
  Flight.carrier_id    as CarrierId,
  Carrier.name         as CarrierName,
  Airport.country      as Country,
  Airport.city         as City,
  Airport.airport_id   as AirportId,
  Airport.name         as AirportName,
  Flight.connection_id as ConnectionId,
  cast( 0 as abap.int4 ) as Departures,
  cast( 1 as abap.int4 ) as Arrivals
}
