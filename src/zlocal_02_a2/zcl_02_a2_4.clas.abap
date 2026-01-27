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

    " --- 1. Hartcodierte Werte für die Abfragen ---
    CONSTANTS:
      c_country   TYPE land1           VALUE 'DE',
      c_city      TYPE string        VALUE 'HAVANA',
      c_airportid TYPE /dmo/airport_id VALUE 'FRA'.


    " --- Abfrage 1: Aggregation für ein bestimmtes LAND ('DE') ---
    out->write( |Suche Statistiken für Land: { c_country }...| ).

    SELECT
      Country,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals
      FROM Z02_departures_arrivals_union
      WHERE Country = @c_country  " Filter auf das Land
      GROUP BY Country
      INTO TABLE @DATA(lt_country_stats).

    IF sy-subrc = 0.
      out->write(
        EXPORTING
          data = lt_country_stats
          name = 'Ergebnis für Land'
      ).
    ELSE.
      out->write( |Keine Daten für Land '{ c_country }' gefunden.| ).
    ENDIF.
    out->write( '---' ).


    " --- Abfrage 2: Aggregation für eine bestimmte STADT ('Frankfurt') ---
    out->write( |Suche Statistiken für Stadt: { c_city }...| ).

    SELECT
      City,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals
      FROM Z02_departures_arrivals_union
      " Case-insensitiver Filter auf die Stadt
      WHERE upper( City ) = @( to_upper( c_city ) )
      GROUP BY City
      INTO TABLE @DATA(lt_city_stats).

    IF sy-subrc = 0.
      out->write(
        EXPORTING
          data = lt_city_stats
          name = 'Ergebnis für Stadt'
      ).
    ELSE.
      out->write( |Keine Daten für Stadt '{ c_city }' gefunden.| ).
    ENDIF.
    out->write( '---' ).


    " --- Abfrage 3: Aggregation für einen bestimmten FLUGHAFEN ('FRA') ---
    out->write( |Suche Statistiken für Flughafen: { c_airportid }...| ).

    SELECT
      AirportId,
      AirportName,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals
      FROM Z02_departures_arrivals_union
      WHERE AirportId = @c_airportid " Filter auf die Flughafen-ID
      GROUP BY AirportId, AirportName
      INTO TABLE @DATA(lt_airport_stats).

    IF sy-subrc = 0.
      out->write(
        EXPORTING
          data = lt_airport_stats
          name = 'Ergebnis für Flughafen'
      ).
    ELSE.
      out->write( |Keine Daten für Flughafen '{ c_airportid }' gefunden.| ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
