@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Restricted View of Booking'

define view entity ZR_02_BookingTP
  as select from ZI_02_Booking

  association to parent ZR_02_FlightTP as _Flight
    on  $projection.ConnectionId = _Flight.ConnectionId
    and $projection.FlightDate   = _Flight.FlightDate
    and $projection.CarrierId    = _Flight.CarrierId

{
  key TravelId,
  key BookingId,

      BookingDate,
      CustomerId,
      CarrierId,
      ConnectionId,
      FlightDate,
      FlightPrice,
      CurrencyCode,

      _Flight
}
