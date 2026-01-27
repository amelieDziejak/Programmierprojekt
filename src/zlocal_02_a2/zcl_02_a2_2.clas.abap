CLASS zcl_02_a2_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_02_a2_2 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lv_search_term TYPE string.
    DATA lt_flights TYPE TABLE OF Z02_Carrier_infos.

    lv_search_term = 'Lufthansa'.
    DATA(lv_search_term_upper) = to_upper( lv_search_term ).

    IF strlen( lv_search_term_upper ) > 3.
      DATA(lv_search_pattern) = '%' && lv_search_term_upper && '%'.
      SELECT *
        FROM Z02_Carrier_infos
        WHERE upper( CarrierName ) LIKE @lv_search_pattern
        ORDER BY CarrierName, FlightDate
        INTO TABLE @lt_flights.
    ELSE.
      DATA(lv_search_pattern_short) = '%' && lv_search_term_upper && '%'.
      SELECT *
        FROM Z02_Carrier_infos
        WHERE upper( CarrierName ) LIKE @lv_search_pattern_short
           OR upper( CarrierId )   = @lv_search_term_upper
        ORDER BY CarrierName, FlightDate
        INTO TABLE @lt_flights.
    ENDIF.

    IF sy-subrc = 0 AND lt_flights IS NOT INITIAL.
      out->write( |Gefundene Flüge für den Suchbegriff '{ lv_search_term }':| ).
      out->write( '---' ).

      LOOP AT lt_flights INTO DATA(ls_flight).
        out->write(
          |  Fluggesellschaft: { ls_flight-CarrierName } ({ ls_flight-CarrierId }) - Connection-id: { ls_flight-ConnectionId } am { ls_flight-FlightDate+6(2) }.{ ls_flight-FlightDate+4(2) }.{ ls_flight-FlightDate(4) }\n| &&
          " HIER WURDEN UHRZEITEN UND FORMATIERUNG ERGÄNZT
          |  Abflug:  { ls_flight-DepartureAirport } ({ ls_flight-DepartureCity }) um { ls_flight-DepartureTime(2) }:{ ls_flight-DepartureTime+2(2) } Uhr\n| &&
          |  Ankunft: { ls_flight-ArrivalAirport } ({ ls_flight-ArrivalCity }) um { ls_flight-ArrivalTime(2) }:{ ls_flight-ArrivalTime+2(2) } Uhr\n| &&
          |  Preis:   { ls_flight-price } { ls_flight-CurrencyCode }\n| &&
          |  Auslastung: { ls_flight-seats_occupied } von { ls_flight-seats_max } Sitzen|
        ).
        out->write( '---' ).
      ENDLOOP.

    ELSE.
      out->write( |Keine Flüge für "{ lv_search_term }" in der Datenbank gefunden.| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
