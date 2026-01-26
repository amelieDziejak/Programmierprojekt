CLASS zcl_02_a2_carrier_info DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_02_a2_carrier_info IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " 1. Klassische Variablendeklaration
    DATA lv_search_term TYPE string.
    DATA lt_flights TYPE TABLE OF Z02_Carrier_infos. " Typsichere Deklaration der internen Tabelle

    " 2. Wertzuweisung für den Suchbegriff.
    "    Beide Werte werden nun korrekt funktionieren.
    lv_search_term = 'Lufthansa'.
    " lv_search_term = 'LH'.

    " 3. Suchbegriff für die Abfrage vorbereiten (Großschreibung)
    DATA(lv_search_term_upper) = to_upper( lv_search_term ).

    " ====================================================================
    " NEU: Logik zur Vermeidung des SAPSQL_DATA_LOSS Fehlers
    " Wir prüfen die Länge des Suchbegriffs.
    " ====================================================================

    " Wenn der Suchbegriff länger ist als das CarrierId-Feld (3 Zeichen),
    " kann es sich nur um einen Namen handeln. Wir suchen dann NUR im Namen.
    IF strlen( lv_search_term_upper ) > 3.

      DATA(lv_search_pattern) = '%' && lv_search_term_upper && '%'.

      SELECT *
        FROM Z02_Carrier_infos
        WHERE upper( CarrierName ) LIKE @lv_search_pattern
        ORDER BY CarrierName, FlightDate
        INTO TABLE @lt_flights.

    " Wenn der Suchbegriff kurz genug ist, könnte er ein Kürzel ODER
    " Teil eines Namens sein. Wir suchen in beiden Feldern.
    ELSE.

      DATA(lv_search_pattern_short) = '%' && lv_search_term_upper && '%'.

      SELECT *
        FROM Z02_Carrier_infos
        WHERE upper( CarrierName ) LIKE @lv_search_pattern_short
           OR upper( CarrierId )   = @lv_search_term_upper
        ORDER BY CarrierName, FlightDate
        INTO TABLE @lt_flights.

    ENDIF.


    " 4. Ergebnis ausgeben (unverändert)
    IF sy-subrc = 0 AND lt_flights IS NOT INITIAL.

      out->write( |Gefundene Flüge für den Suchbegriff '{ lv_search_term }':| ).
      out->write( '---' ).

      LOOP AT lt_flights INTO DATA(ls_flight).
        out->write(
          |  Fluggesellschaft: { ls_flight-CarrierName } ({ ls_flight-CarrierId }) - Connection-id: { ls_flight-ConnectionId } am { ls_flight-FlightDate }\n| &&
          |  Abflug:  { ls_flight-DepartureAirport } ({ ls_flight-DepartureCity }, { ls_flight-DepartureCountry })\n| &&
          |  Ankunft: { ls_flight-ArrivalAirport } ({ ls_flight-ArrivalCity }, { ls_flight-ArrivalCountry })\n| &&
          |  Preis:   { ls_flight-price } { ls_flight-CurrencyCode }\n| &&
          |  Auslastung: { ls_flight-seats_occupied } von { ls_flight-seats_max } Sitzen|
        ).
        out->write( '---' ).
      ENDLOOP.

    ELSE.
      out->write( |Keine Flüge für den Suchbegriff '{ lv_search_term }' gefunden.| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
