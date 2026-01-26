@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'union'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z02_departures_arrivals_union as
  select from Z02_departures
  {
    Country,
    City,
    AirportId,
    AirportName,
    Departures,
    Arrivals
  }
  union all
  select from Z02_arrivals
  {
    Country,
    City,
    AirportId,
    AirportName,
    Departures,
    Arrivals
  }
