@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Restricted View of Flight'

define root view entity ZR_02_FlightTP
  as select from ZI_02_Flight

  composition [0..*] of ZR_02_BookingTP as _Bookings

{
  key CarrierId,
  key ConnectionId,
  key FlightDate,
      Price,
      CurrencyCode,
      PlaneTypeId,
      SeatsMax,
      SeatsOccupied,
      SeatOccupancyRate,

      _Bookings




}
