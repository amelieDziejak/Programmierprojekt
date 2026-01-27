@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Informationen je Carrier ID'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z02_carrier_infos
  as select from /dmo/flight     as Flight

    inner join   /dmo/connection as Connection       on  Flight.carrier_id    = Connection.carrier_id
                                                     and Flight.connection_id = Connection.connection_id

    inner join   /dmo/airport    as DepartureAirport on Connection.airport_from_id = DepartureAirport.airport_id

    inner join   /dmo/airport    as ArrivalAirport   on Connection.airport_to_id = ArrivalAirport.airport_id

    inner join   /dmo/carrier    as Carrier          on Flight.carrier_id = Carrier.carrier_id
{
  key Flight.carrier_id,
  key Flight.connection_id,
  key Flight.flight_date,

      Carrier.name             as CarrierName,
      Flight.carrier_id        as CarrierId,
      Flight.connection_id     as ConnectionId,
      Flight.flight_date       as FlightDate,
      
      -- NEU: Uhrzeiten hinzugefügt
      Connection.departure_time as DepartureTime,
      Connection.arrival_time   as ArrivalTime,

      DepartureAirport.name    as DepartureAirport,
      DepartureAirport.city    as DepartureCity,
      DepartureAirport.country as DepartureCountry,

      ArrivalAirport.name      as ArrivalAirport,
      ArrivalAirport.city      as ArrivalCity,
      ArrivalAirport.country   as ArrivalCountry,

      @Semantics.amount.currencyCode : 'CurrencyCode'
      Flight.price,
      Flight.currency_code     as CurrencyCode,
      Flight.seats_occupied,
      Flight.seats_max
}
