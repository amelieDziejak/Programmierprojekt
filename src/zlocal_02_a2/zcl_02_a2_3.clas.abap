CLASS zcl_02_a2_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_02_a2_3 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    out->write( |Suche Last-Minute-Angebote für die nächsten 300 Tage...| ).
    out->write( '======================================================' ).

    " 1. Datenabruf über die CDS-View
    SELECT *
      FROM Z02_last_minute
      ORDER BY flight_date, price
      INTO TABLE @DATA(lt_offers).

    " 2. Ausgabe der gefundenen Angebote
    IF lt_offers IS INITIAL.
      out->write( 'Leider wurden keine passenden Last-Minute-Angebote gefunden.' ).
    ELSE.
      out->write( |Es wurden { lines( lt_offers ) } Angebote gefunden:| ).
      out->write( '' ).

      LOOP AT lt_offers INTO DATA(ls_offer).
        out->write( |> Flug von { ls_offer-departureairportname } nach { ls_offer-destinationairportname }| ).
        out->write( |  Airline: { ls_offer-carriername } ({ ls_offer-carrier_id }-{ ls_offer-connection_id })| ).
        out->write( |  Datum: { ls_offer-flight_date+6(2) }.{ ls_offer-flight_date+4(2) }.{ ls_offer-flight_date(4) }| ).
        out->write( |  Abflugzeit: { ls_offer-departuretime(2) }:{ ls_offer-departuretime+2(2) } Uhr| ).
        out->write( |  Ankunftszeit: { ls_offer-arrivaltime(2) }:{ ls_offer-arrivaltime+2(2) } Uhr| ).

        " HIER IST DIE KORRIGIERTE PREISFORMATIERUNG
        out->write( |  Preis: { ls_offer-price CURRENCY = ls_offer-currencycode }| ).

        out->write( |  Freie Plätze: { ls_offer-availableseats }| ).
        out->write( '------------------------------------------------------' ).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
