@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Booking'

define view entity ZI_02_Booking
  as select from /dmo/booking as Booking
    left outer join z02_booking_ext as _Extension on  Booking.travel_id  = _Extension.travel_id
                                                  and Booking.booking_id = _Extension.booking_id
{
  key Booking.travel_id     as TravelId,
  key Booking.booking_id    as BookingId,

      Booking.booking_date  as BookingDate,
      Booking.customer_id   as CustomerId,
      Booking.carrier_id    as CarrierId,
      Booking.connection_id as ConnectionId,
      Booking.flight_date   as FlightDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      Booking.flight_price  as FlightPrice,

      Booking.currency_code as CurrencyCode,
      
      _Extension.zz_status  as zz_status
}
