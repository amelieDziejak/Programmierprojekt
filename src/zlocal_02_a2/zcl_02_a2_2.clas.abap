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
    DATA lt_flights     TYPE TABLE OF z02_carrier_infos.

    lv_search_term = 'Lufthansa'.
    DATA(lv_search_term_upper) = to_upper( lv_search_term ).

    IF strlen( lv_search_term_upper ) > 3.
      DATA(lv_search_pattern) = '%' && lv_search_term_upper && '%'.
      SELECT *
        FROM z02_carrier_infos
        WHERE upper( carriername ) LIKE @lv_search_pattern
        ORDER BY carriername, flightdate
        INTO TABLE @lt_flights.
    ELSE.
      DATA(lv_search_pattern_short) = '%' && lv_search_term_upper && '%'.
      SELECT *
        FROM z02_carrier_infos
        WHERE upper( carriername ) LIKE @lv_search_pattern_short
           OR upper( carrierid )   = @lv_search_term_upper
        ORDER BY carriername, flightdate
        INTO TABLE @lt_flights.
    ENDIF.

    IF sy-subrc = 0 AND lt_flights IS NOT INITIAL.
DATA(ls_first_flight) = lt_flights[ 1 ].
      out->write( |┌──────────────────────────────────────────────────────────────────┐| ).
      out->write( |│ FLUGSUCHERGEBNISSE                                               │| ).
      out->write( |├──────────────────────────────────────────────────────────────────┤| ).
      out->write( |│ Suchbegriff:   { lv_search_term WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |│ Treffer:       { lines( lt_flights ) WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |├──────────────────────────────────────────────────────────────────┤| ).
      out->write( |│ FLUGGESELLSCHAFT                                                 │| ).
      out->write( |├──────────────────────────────────────────────────────────────────┤| ).
      out->write( |│ Airline:     { ls_first_flight-carriername WIDTH = 52 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |│ Carrier-ID:  { ls_first_flight-carrierid   WIDTH = 52 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |└──────────────────────────────────────────────────────────────────┘| ).
      out->write( |  | ).

      LOOP AT lt_flights INTO DATA(ls_flight).

        " Hilfsvariablen
        DATA(lv_flight_date)     = |{ ls_flight-flightdate+6(2) }.{ ls_flight-flightdate+4(2) }.{ ls_flight-flightdate(4) }|.
        DATA(lv_departure_time) = |{ ls_flight-departuretime(2) }:{ ls_flight-departuretime+2(2) } Uhr|.
        DATA(lv_arrival_time)   = |{ ls_flight-arrivaltime(2) }:{ ls_flight-arrivaltime+2(2) } Uhr|.
        DATA(lv_price)          = |{ ls_flight-price } { ls_flight-currencycode }|.
        DATA(lv_seats)          = |{ ls_flight-seats_occupied } / { ls_flight-seats_max } belegt|.

        out->write( |┌──────────────────────────────────────────────────────────────────┐| ).
        out->write( |│ FLUGDETAILS                                                      │| ).
        out->write( |├──────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ Verbindung:    { ls_flight-connectionid WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |├──────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ FLUGDATEN                                                        │| ).
        out->write( |│ Flugdatum:     { lv_flight_date     WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│ Abflugzeit:    { lv_departure_time  WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│ Ankunftszeit:  { lv_arrival_time    WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |├──────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ ROUTE                                                            │| ).
        out->write( |│ Von:           { ls_flight-departureairport WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│                { ls_flight-departurecity    WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│ Nach:          { ls_flight-arrivalairport   WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│                { ls_flight-arrivalcity      WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |├──────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ PREIS & VERFÜGBARKEIT                                            │| ).
        out->write( |│ Preis:         { lv_price WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│ Sitzplätze:    { lv_seats WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |└──────────────────────────────────────────────────────────────────┘| ).
        out->write( |  | ).

      ENDLOOP.

    ELSE.

      out->write( |┌───────────────────────────────────────────────────────────────┐| ).
      out->write( |│ KEINE ERGEBNISSE                                              │| ).
      out->write( |├──────────────────────────────────────────────────────────────┤| ).
      out->write( |│ Suchbegriff: { lv_search_term WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |│ Status:      Keine Flüge in der Datenbank gefunden.           │| ).
      out->write( |└──────────────────────────────────────────────────────────────┘| ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
