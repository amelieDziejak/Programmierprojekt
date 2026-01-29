CLASS zcl_02_a2_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_02_a2_3 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    out->write( |┌──────────────────────────────────────────────────────────────────┐| ).
    out->write( |│ LAST-MINUTE-ANGEBOTE (NÄCHSTE 300 TAGE)                          │| ).
    out->write( |├──────────────────────────────────────────────────────────────────┤| ).

    " 1. Datenabruf über die CDS-View
    SELECT *
      FROM z02_last_minute
      ORDER BY flight_date, price
      INTO TABLE @DATA(lt_offers).

    IF lt_offers IS INITIAL.

      out->write( |│ KEINE ANGEBOTE                                                   │| ).
      out->write( |├──────────────────────────────────────────────────────────────────┤| ).
      out->write( |│ Status: Keine passenden Last-Minute-Angebote gefunden.           │| ).
      out->write( |└──────────────────────────────────────────────────────────────────┘| ).

    ELSE.

      out->write( |│ Gefundene Angebote: { lines( lt_offers ) WIDTH = 45 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |└──────────────────────────────────────────────────────────────────┘| ).
      out->write( |  | ).



      LOOP AT lt_offers INTO DATA(ls_offer).

        " Hilfsvariablen
        DATA(lv_flight_date)     = |{ ls_offer-flight_date+6(2) }.{ ls_offer-flight_date+4(2) }.{ ls_offer-flight_date(4) }|.
        DATA(lv_departure_time) = |{ ls_offer-departuretime(2) }:{ ls_offer-departuretime+2(2) } Uhr|.
        DATA(lv_arrival_time)   = |{ ls_offer-arrivaltime(2) }:{ ls_offer-arrivaltime+2(2) } Uhr|.
        DATA(lv_price)          = |{ ls_offer-price CURRENCY = ls_offer-currencycode }|.

        out->write( |┌──────────────────────────────────────────────────────────────────┐| ).
        out->write( |│ LAST-MINUTE-FLUG                                                 │| ).
        out->write( |├──────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ FLUGGESELLSCHAFT                                                 │| ).
        out->write( |│ Airline:       { CONV string( ls_offer-CarrierName ) WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│ Carrier-ID:    { CONV string( ls_offer-Carrier_Id ) WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│ Verbindung:    { CONV string( ls_offer-Connection_Id ) WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |├──────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ Flugdatum:     { lv_flight_date     WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│ Preis:         { lv_price           WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│ Freie Plätze:  { ls_offer-availableseats WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |├──────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ ROUTE                                                            │| ).
        out->write( |│ Von:           { ls_offer-departureairportname WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│ Nach:          { ls_offer-destinationairportname WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |├──────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ ZEITEN                                                           │| ).
        out->write( |│ Abflug:        { lv_departure_time WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |│ Ankunft:       { lv_arrival_time   WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
        out->write( |└──────────────────────────────────────────────────────────────────┘| ).
        out->write( |  | ).

      ENDLOOP.

    ENDIF.

  ENDMETHOD.
ENDCLASS.

