@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Flight'

//@Search.searchable: true

@Metadata.allowExtensions: true
define root view entity ZC_02_FlightTP
  provider contract transactional_query
  as projection on ZR_02_FlightTP

{
  key CarrierId,
//  @Search.defaultSearchElement: true
//      @Search.fuzzinessThreshold: 0.7
  key ConnectionId,
  
  key FlightDate,

      Price,
      CurrencyCode,
      PlaneTypeId,
      SeatsMax,
      SeatsOccupied,
      SeatOccupancyRate,
      SeatOccupancCiticality,
  /* Associations */    
      
  
  _Bookings : redirected to composition child ZC_02_BookingTP
}

where FlightDate >= $session.system_date
