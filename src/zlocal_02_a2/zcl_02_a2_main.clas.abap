CLASS zcl_02_A2_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_02_A2_main IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    " 1. Eingabeparameter: Kunden-ID (hier fest codiert)
    DATA(lv_customer_id) = '1'.

    out->write( |Fluginformationen für Kunde: { lv_customer_id }| ).
    out->write( '-------------------------------------------' ).

    " 2. Datenbeschaffung über die CDS-View Z02_user_info
    SELECT *
      FROM Z02_user_info
      WHERE customer_id = @lv_customer_id
      INTO TABLE @DATA(lt_user_flights).

    " 3. Ausgabe der Ergebnisse
    IF sy-subrc = 0.
      out->write( |Es wurden { lines( lt_user_flights ) } Flüge gefunden:| ).
      out->write( '' ).

      LOOP AT lt_user_flights INTO DATA(ls_flight).
        out->write( |> Buchungs-Nr.: { ls_flight-booking_id }| ).
        out->write( |  Flugdatum: { ls_flight-flight_date }| ).
        out->write( |  Airline: { ls_flight-carriername }| ).
        out->write( |  Von: { ls_flight-departureairportname }| ).
        out->write( |  Nach: { ls_flight-destinationairportname }| ).
        out->write( '-------------------------------------------' ).
      ENDLOOP.
    ELSE.
      out->write( 'Für den angegebenen Kunden wurden keine Flüge gefunden.' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
