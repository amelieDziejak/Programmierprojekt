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

    " 1. Definieren Sie die ID der Fluggesellschaft.
    CONSTANTS c_carrier_id TYPE /dmo/carrier_id VALUE 'AA'.

    " 2. Abfrage auf Ihre CDS-View, das Ergebnis wird in eine interne Tabelle geladen.
    SELECT *
      FROM Z02_Carrier_infos
      WHERE CarrierId = @c_carrier_id
      ORDER BY FlightDate
      INTO TABLE @DATA(lt_flights).


    " 3. Prüfen, ob Flüge gefunden wurden.
    IF sy-subrc = 0 AND lt_flights IS NOT INITIAL.

      out->write( |Gefundene Flüge für Airline '{ c_carrier_id }':| ).
      out->write( '---' ). " Trennlinie für die Übersichtlichkeit

      " 4. Schleife (LOOP) durch jeden einzelnen Flug in der Ergebnistabelle.
      LOOP AT lt_flights INTO DATA(ls_flight).

        " Für jeden Flug wird ein formatierter Textblock erstellt und ausgegeben.
        " \n sorgt für einen Zeilenumbruch innerhalb des Textes.
        out->write(
          |Flug: { ls_flight-CarrierId }-{ ls_flight-ConnectionId } am { ls_flight-FlightDate }\n| &&
          |  Abflug:  { ls_flight-DepartureAirport } ({ ls_flight-DepartureCity }, { ls_flight-DepartureCountry })\n| &&
          |  Ankunft: { ls_flight-ArrivalAirport } ({ ls_flight-ArrivalCity }, { ls_flight-ArrivalCountry })\n| &&
          |  Preis:   { ls_flight-price } { ls_flight-CurrencyCode }\n| &&
          |  Auslastung: { ls_flight-seats_occupied } von { ls_flight-seats_max } Sitzen|
        ).

        " Eine weitere Trennlinie zwischen den einzelnen Flügen.
        out->write( '---' ).

      ENDLOOP.

    ELSE.
      out->write( |Keine Flüge für die Airline '{ c_carrier_id }' gefunden.| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
