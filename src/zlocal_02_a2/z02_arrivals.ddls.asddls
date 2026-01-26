@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'arrivals'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z02_arrivals as
  select from /dmo/flight as Flight
    join /dmo/connection as Connection
      on Flight.carrier_id = Connection.carrier_id
      and Flight.connection_id = Connection.connection_id
    join /dmo/airport as Airport
      on Connection.airport_to_id = Airport.airport_id
{
  Airport.country as Country,
  Airport.city         as City,
  Airport.airport_id   as AirportId,
  Airport.name         as AirportName,
  cast( 0 as abap.int4 ) as Departures,
  cast( 1 as abap.int4 ) as Arrivals
}
