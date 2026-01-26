@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'statistiken'
@Metadata.ignorePropagatedAnnotations: true
  define view entity Z02_statistics as
  select from Z02_departures_arrivals_union
{
  key Country,
  key City,
  key AirportId,
      AirportName,
      sum(Departures) as TotalDepartures,
      sum(Arrivals) as TotalArrivals
}
group by
  Country,
  City,
  AirportId,
  AirportName
