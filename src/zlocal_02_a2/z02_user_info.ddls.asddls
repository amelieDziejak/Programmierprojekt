@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User info'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z02_user_info
as select from /dmo/booking as Booking

  // Verknüpfungen für die Klarnamen
  join /dmo/carrier   as Carrier   on Booking.carrier_id = Carrier.carrier_id
  join /dmo/connection as Connection on Booking.connection_id = Connection.connection_id

  // Doppelte Verknüpfung zur Flughafentabelle, um beide Namen zu erhalten
  join /dmo/airport   as DepartureAirport   on Connection.airport_from_id = DepartureAirport.airport_id
  join /dmo/airport   as DestinationAirport on Connection.airport_to_id = DestinationAirport.airport_id

{
  key Booking.booking_id,
      Booking.customer_id,
      Booking.flight_date,
      Carrier.name               as CarrierName,
      Connection.connection_id,
      DepartureAirport.name      as DepartureAirportName,
      DestinationAirport.name    as DestinationAirportName
}
