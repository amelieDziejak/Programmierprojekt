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
      
      division(SeatsOccupied, SeatsMax, 2) as SeatOccupancyRate,
      
      case 
        when division(SeatsOccupied, SeatsMax, 2) > 0.7 then 1
        when division(SeatsOccupied, SeatsMax, 2) > 0.4 then 2
        
        when division(SeatsOccupied, SeatsMax, 2) > 0    then 3
        else 0 
      end as SeatOccupancCiticality,
   

      _Bookings




}
