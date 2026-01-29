@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User info'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z02_USER_INFO
  as select from /dmo/booking    as Booking

    join         /dmo/carrier    as Carrier            on Booking.carrier_id = Carrier.carrier_id
    join         /dmo/connection as Connection         on  Booking.connection_id = Connection.connection_id
                                                       and Booking.carrier_id    = Connection.carrier_id
    join         /dmo/customer   as Customer           on Booking.customer_id = Customer.customer_id
    join         /dmo/airport    as DepartureAirport   on Connection.airport_from_id = DepartureAirport.airport_id
    join         /dmo/airport    as DestinationAirport on Connection.airport_to_id = DestinationAirport.airport_id

{
      // Buchungsinformationen
  key Booking.booking_id         as BookingId,
      Booking.booking_date       as BookingDate,
      Booking.currency_code      as CurrencyCode,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      Booking.flight_price       as FlightPrice,


      // Kundeninformationen (komplett)
      Booking.customer_id        as CustomerId,
      Customer.first_name        as FirstName,
      Customer.last_name         as LastName,
      Customer.title             as Title,
      Customer.street            as Street,
      Customer.postal_code       as PostalCode,
      Customer.city              as City,
      Customer.country_code      as CountryCode,
      Customer.phone_number      as PhoneNumber,
      Customer.email_address     as EmailAddress,

      // Flugdaten
      Booking.flight_date        as FlightDate,
      Connection.departure_time  as DepartureTime,
      Connection.arrival_time    as ArrivalTime,
      Connection.distance        as Distance,
      Connection.distance_unit   as DistanceUnit,

      // Fluggesellschaft
      Booking.carrier_id         as CarrierId,
      Carrier.name               as CarrierName,
      Carrier.currency_code      as CarrierCurrency,

      // Verbindungsinformationen
      Connection.connection_id   as ConnectionId,
      Connection.airport_from_id as DepartureAirportId,
      Connection.airport_to_id   as DestinationAirportId,

      // Flughäfen
      DepartureAirport.name      as DepartureAirportName,
      DepartureAirport.city      as DepartureCity,
      DepartureAirport.country   as DepartureCountry,
      DestinationAirport.name    as DestinationAirportName,
      DestinationAirport.city    as DestinationCity,
      DestinationAirport.country as DestinationCountry
}
