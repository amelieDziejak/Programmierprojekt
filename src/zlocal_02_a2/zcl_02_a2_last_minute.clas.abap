CLASS zcl_02_a2_last_minute DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_02_a2_last_minute IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    out->write( |Suche Last-Minute-Angebote für die nächsten 3 Tage...| ).
    out->write( '======================================================' ).

    " 1. Datenabruf über die CDS-View
    " Die komplexe Logik ist vollständig in der View gekapselt.
    SELECT *
      FROM Z02_last_minute
      ORDER BY flight_date, price " Sortiert nach Datum und dann nach dem günstigsten Preis
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
        out->write( |  Datum: { ls_offer-flight_date }| ).
        out->write( |  Preis: { ls_offer-price } { ls_offer-currencycode }| ).
        out->write( |  Freie Plätze: { ls_offer-availableseats }| ).
        out->write( '------------------------------------------------------' ).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
