CLASS zcl_02_a2_4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_02_a2_4 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    CONSTANTS:
      c_country   TYPE land1           VALUE 'DE',
      c_city      TYPE string          VALUE 'Frankfurt/Main',
      c_airportid TYPE /dmo/airport_id VALUE 'FRA'.

    DATA lv_carrier_id TYPE /dmo/carrier_id VALUE 'LH'.


    out->write( `════════════════════════════════════════════════════════════════════` ).
    out->write( `         FLUGHAFEN STATISTIKEN - ÜBERSICHT` ).

    DATA(lv_airline_text) = COND string( WHEN lv_carrier_id IS INITIAL
                                          THEN 'Alle Airlines'
                                          ELSE |Nur Airline: { lv_carrier_id }| ).
    out->write( |         Filter: { lv_airline_text } | ).
    out->write( `════════════════════════════════════════════════════════════════════` ).
    out->write( `` ).

    TYPES:
      BEGIN OF ty_country_stats,
        country          TYPE land1,
        departures       TYPE i,
        arrivals         TYPE i,
        abfluege_gesamt  TYPE i,
        ankuenfte_gesamt TYPE i,
      END OF ty_country_stats,
      tt_country_stats TYPE STANDARD TABLE OF ty_country_stats WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_city_stats,
        city             TYPE string,
        departures       TYPE i,
        arrivals         TYPE i,
        abfluege_gesamt  TYPE i,
        ankuenfte_gesamt TYPE i,
      END OF ty_city_stats,
      tt_city_stats TYPE STANDARD TABLE OF ty_city_stats WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_airport_stats,
        airportid        TYPE /dmo/airport_id,
        airportname      TYPE /dmo/airport_name,
        departures       TYPE i,
        arrivals         TYPE i,
        abfluege_gesamt  TYPE i,
        ankuenfte_gesamt TYPE i,
      END OF ty_airport_stats,
      tt_airport_stats TYPE STANDARD TABLE OF ty_airport_stats WITH EMPTY KEY.

    " <<< KORREKTUR: Interne Tabellen mit den neuen, passenden Typen deklarieren.
    DATA lt_country_stats TYPE tt_country_stats.
    DATA lt_city_stats    TYPE tt_city_stats.
    DATA lt_airport_stats TYPE tt_airport_stats.


    IF lv_carrier_id IS NOT INITIAL.
      " FALL 1: Es wird nach einer spezifischen Airline gefiltert.
      SELECT Country,
             SUM( CASE WHEN CarrierId = @lv_carrier_id THEN Departures ELSE 0 END ) AS Departures,
             SUM( CASE WHEN CarrierId = @lv_carrier_id THEN Arrivals ELSE 0 END )   AS Arrivals,
             SUM( Departures ) AS Abfluege_Gesamt,
             SUM( Arrivals )   AS Ankuenfte_Gesamt
        FROM z02_carrier_airport_union
        WHERE Country = @c_country
        GROUP BY Country
        INTO TABLE @lt_country_stats.

      SELECT City,
             SUM( CASE WHEN CarrierId = @lv_carrier_id THEN Departures ELSE 0 END ) AS Departures,
             SUM( CASE WHEN CarrierId = @lv_carrier_id THEN Arrivals ELSE 0 END )   AS Arrivals,
             SUM( Departures ) AS Abfluege_Gesamt,
             SUM( Arrivals )   AS Ankuenfte_Gesamt
        FROM z02_carrier_airport_union
        WHERE upper( City ) = @( to_upper( c_city ) )
        GROUP BY City
        INTO TABLE @lt_city_stats.

      SELECT AirportId,
             AirportName,
             SUM( CASE WHEN CarrierId = @lv_carrier_id THEN Departures ELSE 0 END ) AS Departures,
             SUM( CASE WHEN CarrierId = @lv_carrier_id THEN Arrivals ELSE 0 END )   AS Arrivals,
             SUM( Departures ) AS Abfluege_Gesamt,
             SUM( Arrivals )   AS Ankuenfte_Gesamt
        FROM z02_carrier_airport_union
        WHERE AirportId = @c_airportid
        GROUP BY AirportId, AirportName
        INTO TABLE @lt_airport_stats.






    ELSE.
      " FALL 2: Es wird NICHT nach einer Airline gefiltert.
      SELECT Country,
             SUM( Departures ) AS Departures,
             SUM( Arrivals )   AS Arrivals,
             SUM( Departures ) AS Abfluege_Gesamt,
             SUM( Arrivals )   AS Ankuenfte_Gesamt
        FROM z02_carrier_airport_union
        WHERE Country = @c_country
        GROUP BY Country
        INTO TABLE @lt_country_stats.

      SELECT City,
             SUM( Departures ) AS Departures,
             SUM( Arrivals )   AS Arrivals,
             SUM( Departures ) AS Abfluege_Gesamt,
             SUM( Arrivals )   AS Ankuenfte_Gesamt
        FROM z02_carrier_airport_union
        WHERE upper( City ) = @( to_upper( c_city ) )
        GROUP BY City
        INTO TABLE @lt_city_stats.

      SELECT AirportId,
             AirportName,
             SUM( Departures ) AS Departures,
             SUM( Arrivals )   AS Arrivals,
             SUM( Departures ) AS Abfluege_Gesamt,
             SUM( Arrivals )   AS Ankuenfte_Gesamt
        FROM z02_carrier_airport_union
        WHERE AirportId = @c_airportid
        GROUP BY AirportId, AirportName
        INTO TABLE @lt_airport_stats.

    ENDIF.



    LOOP AT lt_country_stats ASSIGNING FIELD-SYMBOL(<ls_country>).
      DATA(lv_gesamt_filt)  = <ls_country>-departures + <ls_country>-arrivals.
      DATA(lv_gesamt_total) = <ls_country>-abfluege_gesamt + <ls_country>-ankuenfte_gesamt.

      DATA(lv_abfluege_str) = COND string( WHEN lv_carrier_id IS NOT INITIAL THEN |{ <ls_country>-departures } ({ <ls_country>-abfluege_gesamt })| ELSE |{ <ls_country>-abfluege_gesamt }| ).
      DATA(lv_ankuenfte_str) = COND string( WHEN lv_carrier_id IS NOT INITIAL THEN |{ <ls_country>-arrivals } ({ <ls_country>-ankuenfte_gesamt })| ELSE |{ <ls_country>-ankuenfte_gesamt }| ).
      DATA(lv_gesamt_str) = COND string( WHEN lv_carrier_id IS NOT INITIAL THEN |{ lv_gesamt_filt } ({ lv_gesamt_total })| ELSE |{ lv_gesamt_total }| ).

      out->write( `┌──────────────────────────────────────────────────────────────────┐` ).
      out->write( `│ A1: STATISTIK FÜR LAND                                           │` ).
      out->write( `├──────────────────────────────────────────────────────────────────┤` ).
      out->write( |│ Land:          { <ls_country>-Country WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( `├──────────────────────────────────────────────────────────────────┤` ).
      out->write( |│ Abflüge:       { lv_abfluege_str WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |│ Ankünfte:      { lv_ankuenfte_str WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |│ GESAMT:        { lv_gesamt_str WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( `└──────────────────────────────────────────────────────────────────┘` ).
      out->write( `` ).
    ENDLOOP.

    " A2: Stadt
    LOOP AT lt_city_stats ASSIGNING FIELD-SYMBOL(<ls_city>).
      DATA(lv_c_gesamt_filt)  = <ls_city>-departures + <ls_city>-arrivals.
      DATA(lv_c_gesamt_total) = <ls_city>-abfluege_gesamt + <ls_city>-ankuenfte_gesamt.

      DATA(lv_c_abfluege_str) = COND string( WHEN lv_carrier_id IS NOT INITIAL THEN |{ <ls_city>-departures } ({ <ls_city>-abfluege_gesamt })| ELSE |{ <ls_city>-abfluege_gesamt }| ).
      DATA(lv_c_ankuenfte_str) = COND string( WHEN lv_carrier_id IS NOT INITIAL THEN |{ <ls_city>-arrivals } ({ <ls_city>-ankuenfte_gesamt })| ELSE |{ <ls_city>-ankuenfte_gesamt }| ).
      DATA(lv_c_gesamt_str) = COND string( WHEN lv_carrier_id IS NOT INITIAL THEN |{ lv_c_gesamt_filt } ({ lv_c_gesamt_total })| ELSE |{ lv_c_gesamt_total }| ).

      out->write( `┌──────────────────────────────────────────────────────────────────┐` ).
      out->write( `│ A2: STATISTIK FÜR STADT                                          │` ).
      out->write( `├──────────────────────────────────────────────────────────────────┤` ).
      out->write( |│ Stadt:         { <ls_city>-City WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( `├──────────────────────────────────────────────────────────────────┤` ).
      out->write( |│ Abflüge:       { lv_c_abfluege_str WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |│ Ankünfte:      { lv_c_ankuenfte_str WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |│ GESAMT:        { lv_c_gesamt_str WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( `└──────────────────────────────────────────────────────────────────┘` ).
      out->write( `` ).
    ENDLOOP.

    " A3: Flughafen
    LOOP AT lt_airport_stats ASSIGNING FIELD-SYMBOL(<ls_airport>).
      DATA(lv_a_gesamt_filt)  = <ls_airport>-departures + <ls_airport>-arrivals.
      DATA(lv_a_gesamt_total) = <ls_airport>-abfluege_gesamt + <ls_airport>-ankuenfte_gesamt.

      DATA(lv_a_abfluege_str) = COND string( WHEN lv_carrier_id IS NOT INITIAL THEN |{ <ls_airport>-departures } ({ <ls_airport>-abfluege_gesamt })| ELSE |{ <ls_airport>-abfluege_gesamt }| ).
      DATA(lv_a_ankuenfte_str) = COND string( WHEN lv_carrier_id IS NOT INITIAL THEN |{ <ls_airport>-arrivals } ({ <ls_airport>-ankuenfte_gesamt })| ELSE |{ <ls_airport>-ankuenfte_gesamt }| ).
      DATA(lv_a_gesamt_str) = COND string( WHEN lv_carrier_id IS NOT INITIAL THEN |{ lv_a_gesamt_filt } ({ lv_a_gesamt_total })| ELSE |{ lv_a_gesamt_total }| ).

      out->write( `┌──────────────────────────────────────────────────────────────────┐` ).
      out->write( `│ A3: STATISTIK FÜR FLUGHAFEN                                      │` ).
      out->write( `├──────────────────────────────────────────────────────────────────┤` ).
      out->write( |│ Flughafen-ID:  { <ls_airport>-AirportId WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |│ Name:          { <ls_airport>-AirportName WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( `├──────────────────────────────────────────────────────────────────┤` ).
      out->write( |│ Abflüge:       { lv_a_abfluege_str WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |│ Ankünfte:      { lv_a_ankuenfte_str WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( |│ GESAMT:        { lv_a_gesamt_str WIDTH = 50 PAD = ' ' ALIGN = LEFT }│| ).
      out->write( `└──────────────────────────────────────────────────────────────────┘` ).
      out->write( `` ).
    ENDLOOP.


    out->write( `════════════════════════════════════════════════════════════════════` ).
    out->write( `  Report erfolgreich erstellt` ).
    out->write( `════════════════════════════════════════════════════════════════════` ).

  ENDMETHOD.

ENDCLASS.
