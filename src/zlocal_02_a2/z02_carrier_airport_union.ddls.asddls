@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'union with carrier'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z02_carrier_airport_union as
  select from Z02_departures_carrier
  {
    CarrierId,
    CarrierName,
    Country,
    City,
    AirportId,
    AirportName,
    ConnectionId,
    Departures,
    Arrivals
  }
  union all
  select from Z02_arrivals_carrier
  {
    CarrierId,
    CarrierName,
    Country,
    City,
    AirportId,
    AirportName,
    ConnectionId,
    Departures,
    Arrivals
  }
