@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'last minute angebote'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z02_last_minute 
  as select from /dmo/flight as Flight

  join /dmo/carrier on Flight.carrier_id = /dmo/carrier.carrier_id

  join /dmo/connection on Flight.carrier_id    = /dmo/connection.carrier_id
                       and Flight.connection_id = /dmo/connection.connection_id

  join /dmo/airport as DepartureAirport   on /dmo/connection.airport_from_id = DepartureAirport.airport_id
  join /dmo/airport as DestinationAirport on /dmo/connection.airport_to_id = DestinationAirport.airport_id
{
     key Flight.carrier_id,
  key Flight.connection_id,
  key Flight.flight_date,

      // Berechnetes Feld für freie Plätze
      (Flight.seats_max - Flight.seats_occupied) as AvailableSeats,

      /dmo/carrier.name   as CarrierName,
      DepartureAirport.name     as DepartureAirportName,
      DestinationAirport.name   as DestinationAirportName,
      Flight.currency_code as CurrencyCode,
      @Semantics.amount.currencyCode : 'currencycode'
      Flight.price
}
// WHERE-Bedingung für die Last-Minute-Logik
where
      // Kriterium 1: Flug findet heute oder in den nächsten 3 Tagen statt
      Flight.flight_date >= $session.system_date
  and Flight.flight_date <= dats_add_days( $session.system_date, 300, 'FAIL' )

  // Kriterium 2: Es gibt noch freie Plätze
  and Flight.seats_occupied < Flight.seats_max
