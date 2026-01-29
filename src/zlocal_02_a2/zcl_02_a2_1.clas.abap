CLASS zcl_02_a2_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS get_country_name
      IMPORTING
        iv_country_code        TYPE land1
      RETURNING
        VALUE(rv_country_name) TYPE string.

ENDCLASS.


CLASS zcl_02_a2_1 IMPLEMENTATION.

  METHOD get_country_name.
    SELECT SINGLE CountryName
      FROM I_CountryText
      WHERE Country = @iv_country_code
        AND Language = @sy-langu
      INTO @DATA(lv_country_name).

    IF sy-subrc = 0.
      rv_country_name = lv_country_name.
    ELSE.
      rv_country_name = iv_country_code.
    ENDIF.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    DATA(lv_search_input) = '1'.
    DATA lt_customer_ids TYPE TABLE OF /dmo/customer_id WITH EMPTY KEY.

    IF contains( val = lv_search_input pcre = `^\d+$` ).
      out->write( |Suche Flüge für Kunden-ID: { lv_search_input }...| ).
      out->write( '---------------------------------------------------' ).
      APPEND lv_search_input TO lt_customer_ids.

    ELSE.
      out->write( |Suche Flüge für Kunden mit dem Namen '{ lv_search_input }'...| ).
      out->write( '---------------------------------------------------' ).

      DATA(lv_search_pattern) = '%' && to_upper( lv_search_input ) && '%'.

      SELECT DISTINCT CustomerId,
                      FirstName,
                      LastName
        FROM z02_user_info
        WHERE concat_with_space( upper( FirstName ), upper( LastName ), 1 ) LIKE @lv_search_pattern
           OR upper( LastName ) LIKE @lv_search_pattern
           OR upper( FirstName ) LIKE @lv_search_pattern
        INTO TABLE @DATA(lt_customer_details).

      IF lines( lt_customer_details ) > 1.
        out->write( |⚠️  WARNUNG: Es wurden { lines( lt_customer_details ) } unterschiedliche Kunden gefunden!| ).
        out->write( |Die Suchanfrage '{ lv_search_input }' ist nicht eindeutig.| ).
        out->write( '' ).
        out->write( 'Gefundene Kunden:' ).

        LOOP AT lt_customer_details INTO DATA(ls_detail).
          out->write( |  - Kunden-ID { ls_detail-CustomerId }: { ls_detail-FirstName } { ls_detail-LastName }| ).
        ENDLOOP.

        out->write( '' ).
        out->write( '❌ ABBRUCH: Bitte geben Sie eine eindeutige Suchanfrage ein (z.B. vollständiger Name oder Kunden-ID).' ).
        RETURN.
      ENDIF.

      LOOP AT lt_customer_details INTO ls_detail.
        APPEND ls_detail-CustomerId TO lt_customer_ids.
      ENDLOOP.

      IF lines( lt_customer_ids ) = 1.
        out->write( |✓ Eindeutiger Kunde gefunden: { lt_customer_details[ 1 ]-FirstName } { lt_customer_details[ 1 ]-LastName } (ID: { lt_customer_details[ 1 ]-CustomerId })| ).
        out->write( '' ).
      ENDIF.
    ENDIF.

    IF lt_customer_ids IS INITIAL.
      out->write( |❌ Keine passenden Kunden für die Suche nach '{ lv_search_input }' gefunden.| ).
      RETURN.
    ENDIF.

    SELECT *
      FROM z02_user_info
      FOR ALL ENTRIES IN @lt_customer_ids
      WHERE CustomerId = @lt_customer_ids-table_line
      INTO TABLE @DATA(lt_user_flights).

    IF lt_user_flights IS NOT INITIAL.

      DATA(ls_first_flight) = lt_user_flights[ 1 ].

      out->write( |═══════════════════════════════════════════════════| ).
      out->write( |            KUNDENINFORMATIONEN                    | ).
      out->write( |═══════════════════════════════════════════════════| ).
      out->write( |Kunden-ID:     { ls_first_flight-CustomerId }| ).
      out->write( |Anrede:        { ls_first_flight-Title }| ).
      out->write( |Name:          { ls_first_flight-FirstName } { ls_first_flight-LastName }| ).
      out->write( |Adresse:       { ls_first_flight-Street }| ).
      out->write( |               { ls_first_flight-PostalCode } { ls_first_flight-City }| ).
      out->write( |Land:          { ls_first_flight-CountryCode }| ).
      out->write( |Telefon:       { ls_first_flight-PhoneNumber }| ).
      out->write( |E-Mail:        { ls_first_flight-EmailAddress }| ).
      out->write( |═══════════════════════════════════════════════════| ).
      out->write( '' ).

      out->write( |Es wurden insgesamt { lines( lt_user_flights ) } Flüge gefunden:| ).
      out->write( '' ).

      LOOP AT lt_user_flights INTO DATA(ls_flight).

        DATA(lv_booking_date) = |{ ls_flight-BookingDate+6(2) }.{ ls_flight-BookingDate+4(2) }.{ ls_flight-BookingDate(4) }|.
        DATA(lv_flight_date) = |{ ls_flight-FlightDate+6(2) }.{ ls_flight-FlightDate+4(2) }.{ ls_flight-FlightDate(4) }|.
        DATA(lv_departure_time) = |{ ls_flight-DepartureTime(2) }:{ ls_flight-DepartureTime+2(2) } Uhr|.
        DATA(lv_arrival_time) = |{ ls_flight-ArrivalTime(2) }:{ ls_flight-ArrivalTime+2(2) } Uhr|.
        DATA(lv_flight_price) = |{ ls_flight-FlightPrice } { ls_flight-CurrencyCode }|.
        DATA(lv_distance) = |{ ls_flight-Distance } { ls_flight-DistanceUnit }|.
        DATA(lv_destination_location) = |{ ls_flight-DestinationCity }, { ls_flight-DestinationCountry } ({ get_country_name( ls_flight-DestinationCountry ) })|.
        DATA(lv_departure_location) = |{ ls_flight-DepartureCity }, { ls_flight-DepartureCountry } ({ get_country_name( ls_flight-DepartureCountry ) })|.

        out->write( |┌────────────────────────────────────────────────────────────────────┐| ).
        out->write( |│ Buchungs-Nr.: { ls_flight-BookingId WIDTH = 53 }│| ).
        out->write( |├────────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ BUCHUNGSDETAILS                                                    │| ).
        out->write( |│ Buchungsdatum: { lv_booking_date WIDTH = 52 }│| ).
        out->write( |│ Flugpreis:     { lv_flight_price WIDTH = 52 }│| ).
        out->write( |├────────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ FLUGDATEN                                                          │| ).
        out->write( |│ Flugdatum:     { lv_flight_date WIDTH = 52 }│| ).
        out->write( |│ Abflugzeit:    { lv_departure_time WIDTH = 52 }│| ).
        out->write( |│ Ankunftszeit:  { lv_arrival_time WIDTH = 52 }│| ).
        out->write( |├────────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ FLUGGESELLSCHAFT                                                   │| ).
        out->write( |│ Airline:       { ls_flight-CarrierName WIDTH = 52 }│| ).
        out->write( |│ Carrier-ID:    { ls_flight-CarrierId WIDTH = 52 }│| ).
        out->write( |│ Verbindung:    { ls_flight-ConnectionId WIDTH = 52 }│| ).
        out->write( |├────────────────────────────────────────────────────────────────────┤| ).
        out->write( |│ ROUTE                                                              │| ).
        out->write( |│ Von:           { ls_flight-DepartureAirportName WIDTH = 52 }│| ).
        out->write( |│                { lv_departure_location WIDTH = 52 }│| ).
        out->write( |│ Nach:          { ls_flight-DestinationAirportName WIDTH = 52 }│| ).
        out->write( |│                { lv_destination_location WIDTH = 52 }│| ).
        out->write( |│ Entfernung:    { lv_distance WIDTH = 52 }│| ).
        out->write( |└────────────────────────────────────────────────────────────────────┘| ).
        out->write( |  | ).
        out->write( |======================================================================| ).
        out->write( |  | ).

      ENDLOOP.

    ELSE.
      out->write( |ℹ️  Für den gefundenen Kunden wurden keine Flüge gebucht.| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
