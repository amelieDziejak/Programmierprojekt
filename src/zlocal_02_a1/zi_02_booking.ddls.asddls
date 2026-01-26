@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Interface View of Booking'

define view entity ZI_02_Booking
  as select from /dmo/booking

{
  key travel_id     as TravelId,
  key booking_id    as BookingId,

      booking_date  as BookingDate,
      customer_id   as CustomerId,
      carrier_id    as CarrierId,
      connection_id as ConnectionId,
      flight_date   as FlightDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price  as FlightPrice,

      currency_code as CurrencyCode
}
