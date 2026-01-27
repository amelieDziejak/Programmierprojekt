@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Booking'

@Metadata.allowExtensions: true

@Search.searchable: true

define view entity ZC_02_BookingTP
  as projection on ZR_02_BookingTP
  

{
  key TravelId,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
  key BookingId,

      BookingDate,
      CustomerId,
      CarrierId,
      ConnectionId,
      FlightDate,
      FlightPrice,
      CurrencyCode,
      zz_status,
      /* Associations */


      _Flight : redirected to parent ZC_02_FlightTP
}
