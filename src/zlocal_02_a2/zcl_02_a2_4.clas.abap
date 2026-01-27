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

    " --- Konstanten ---
    CONSTANTS:
      c_country   TYPE land1           VALUE 'DE',
      c_city      TYPE string          VALUE 'Frankfurt/Main',
      c_airportid TYPE /dmo/airport_id VALUE 'FRA',
      c_carrierid TYPE /dmo/carrier_id VALUE 'LH'.

    " Type Definitionen für komplexe Strukturen
    TYPES: BEGIN OF ty_market_share,
             carrier_id   TYPE /dmo/carrier_id,
             carrier_name TYPE /dmo/carrier_name,
             flights      TYPE i,
             market_share TYPE p LENGTH 8 DECIMALS 2,
           END OF ty_market_share.

    TYPES: BEGIN OF ty_dominant,
             airport_id      TYPE /dmo/airport_id,
             airport_name    TYPE /dmo/airport_name,
             city            TYPE /dmo/city,
             country         TYPE land1,
             carrier_id      TYPE /dmo/carrier_id,
             carrier_name    TYPE /dmo/carrier_name,
             carrier_flights TYPE i,
             airport_total   TYPE i,
             market_share    TYPE p LENGTH 8 DECIMALS 2,
           END OF ty_dominant.

    TYPES: BEGIN OF ty_top_carrier_country,
             country      TYPE land1,
             carrier_id   TYPE /dmo/carrier_id,
             carrier_name TYPE /dmo/carrier_name,
             airports     TYPE i,
             flights      TYPE i,
           END OF ty_top_carrier_country.

    TYPES: BEGIN OF ty_monopoly,
             airport_id    TYPE /dmo/airport_id,
             airport_name  TYPE /dmo/airport_name,
             city          TYPE /dmo/city,
             country       TYPE land1,
             carrier_id    TYPE /dmo/carrier_id,
             carrier_name  TYPE /dmo/carrier_name,
             total_flights TYPE i,
           END OF ty_monopoly.

    TYPES: BEGIN OF ty_competition,
             competition_level  TYPE string,
             number_of_airports TYPE i,
           END OF ty_competition.


    out->write( '========================================' ).
    out->write( 'FLUGHAFEN & AIRLINE STATISTIKEN' ).
    out->write( '========================================' ).
    out->write( '' ).


    " ============================================================
    " TEIL A: FLUGHAFEN STATISTIKEN (ohne Carrier)
    " ============================================================

    out->write( 'TEIL A: FLUGHAFEN STATISTIKEN' ).
    out->write( '==============================' ).
    out->write( '' ).

    " STATISTIK A1: Spezifisches Land
    " ============================================================
    out->write( |A1. Statistik für Land: { c_country }| ).

    SELECT
      Country,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals
      FROM Z02_carrier_airport_union
      WHERE Country = @c_country
      GROUP BY Country
      INTO TABLE @DATA(lt_country_stats).

    IF sy-subrc = 0.
      out->write( data = lt_country_stats name = 'Ergebnis' ).
    ELSE.
      out->write( |Keine Daten gefunden| ).
    ENDIF.
    out->write( '---' ).


    " STATISTIK A2: Spezifische Stadt
    " ============================================================
    out->write( |A2. Statistik für Stadt: { c_city }| ).

    SELECT
      City,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals
      FROM Z02_carrier_airport_union
      WHERE upper( City ) = @( to_upper( c_city ) )
      GROUP BY City
      INTO TABLE @DATA(lt_city_stats).

    IF sy-subrc = 0.
      out->write( data = lt_city_stats name = 'Ergebnis' ).
    ELSE.
      out->write( |Keine Daten gefunden| ).
    ENDIF.
    out->write( '---' ).


    " STATISTIK A3: Spezifischer Flughafen
    " ============================================================
    out->write( |A3. Statistik für Flughafen: { c_airportid }| ).

    SELECT
      AirportId,
      AirportName,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals
      FROM Z02_carrier_airport_union
      WHERE AirportId = @c_airportid
      GROUP BY AirportId, AirportName
      INTO TABLE @DATA(lt_airport_stats).

    IF sy-subrc = 0.
      out->write( data = lt_airport_stats name = 'Ergebnis' ).
    ELSE.
      out->write( |Keine Daten gefunden| ).
    ENDIF.
    out->write( '---' ).


    " STATISTIK A4: TOP 10 Flughäfen
    " ============================================================
    out->write( 'A4. TOP 10 Flughäfen nach Gesamtverkehr' ).

    SELECT
      AirportId,
      AirportName,
      City,
      Country,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalTraffic
      FROM Z02_carrier_airport_union
      GROUP BY AirportId, AirportName, City, Country
      ORDER BY TotalTraffic DESCENDING
      INTO TABLE @DATA(lt_top_airports)
      UP TO 10 ROWS.

    out->write( data = lt_top_airports name = 'Top 10 Flughäfen' ).
    out->write( '---' ).


    " STATISTIK A5: Statistik pro Land
    " ============================================================
    out->write( 'A5. Statistik für alle Länder' ).

    SELECT
      Country,
      COUNT( DISTINCT AirportId ) AS NumberOfAirports,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalTraffic
      FROM Z02_carrier_airport_union
      GROUP BY Country
      ORDER BY TotalTraffic DESCENDING
      INTO TABLE @DATA(lt_all_countries).

    out->write( data = lt_all_countries name = 'Alle Länder' ).
    out->write( '---' ).


    " STATISTIK A6: TOP 20 Städte
    " ============================================================
    out->write( 'A6. TOP 20 Städte nach Verkehrsaufkommen' ).

    SELECT
      City,
      Country,
      COUNT( DISTINCT AirportId ) AS NumberOfAirports,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalTraffic
      FROM Z02_carrier_airport_union
      GROUP BY City, Country
      ORDER BY TotalTraffic DESCENDING
      INTO TABLE @DATA(lt_all_cities)
      UP TO 20 ROWS.

    out->write( data = lt_all_cities name = 'Top 20 Städte' ).
    out->write( '---' ).


    " STATISTIK A7: Nur Abflüge
    " ============================================================
    out->write( 'A7. Flughäfen mit nur Abflügen' ).

    SELECT
      AirportId,
      AirportName,
      City,
      Country,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals
      FROM Z02_carrier_airport_union
      GROUP BY AirportId, AirportName, City, Country
      HAVING SUM( Arrivals ) = 0 AND SUM( Departures ) > 0
      INTO TABLE @DATA(lt_departure_only).

    IF lt_departure_only IS NOT INITIAL.
      out->write( data = lt_departure_only name = 'Nur Abflüge' ).
    ELSE.
      out->write( 'Keine gefunden' ).
    ENDIF.
    out->write( '---' ).


    " STATISTIK A8: Nur Ankünfte
    " ============================================================
    out->write( 'A8. Flughäfen mit nur Ankünften' ).

    SELECT
      AirportId,
      AirportName,
      City,
      Country,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals
      FROM Z02_carrier_airport_union
      GROUP BY AirportId, AirportName, City, Country
      HAVING SUM( Departures ) = 0 AND SUM( Arrivals ) > 0
      INTO TABLE @DATA(lt_arrival_only).

    IF lt_arrival_only IS NOT INITIAL.
      out->write( data = lt_arrival_only name = 'Nur Ankünfte' ).
    ELSE.
      out->write( 'Keine gefunden' ).
    ENDIF.
    out->write( '---' ).


    " STATISTIK A9: Gesamtübersicht Flughäfen
    " ============================================================
    out->write( 'A9. Gesamtübersicht aller Flughäfen' ).

    SELECT
      AirportId,
      AirportName,
      City,
      Country,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals )   AS TotalArrivals,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalTraffic
      FROM Z02_carrier_airport_union
      GROUP BY AirportId, AirportName, City, Country
      ORDER BY Country, City, AirportId
      INTO TABLE @DATA(lt_all_airports).

    out->write( data = lt_all_airports name = 'Alle Flughäfen' ).
    out->write( '---' ).


    " STATISTIK A10: Globale Zusammenfassung
    " ============================================================
    out->write( 'A10. Globale Flughafen-Zusammenfassung' ).

    SELECT SINGLE
      COUNT( DISTINCT Country ) AS TotalCountries,
      COUNT( DISTINCT City ) AS TotalCities,
      COUNT( DISTINCT AirportId ) AS TotalAirports,
      SUM( Departures ) AS GlobalDepartures,
      SUM( Arrivals ) AS GlobalArrivals,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS GlobalTraffic
      FROM Z02_carrier_airport_union
      INTO @DATA(ls_global_stats).

    out->write( data = ls_global_stats name = 'Global' ).
    out->write( '---' ).


    " ============================================================
    " TEIL B: AIRLINE STATISTIKEN
    " ============================================================

    out->write( '' ).
    out->write( 'TEIL B: AIRLINE STATISTIKEN' ).
    out->write( '============================' ).
    out->write( '' ).


    " STATISTIK B1: Übersicht aller Airlines
    " ============================================================
    out->write( 'B1. Gesamtübersicht aller Airlines' ).

    SELECT
      CarrierId,
      CarrierName,
      COUNT( DISTINCT AirportId ) AS NumberOfAirportsServed,
      COUNT( DISTINCT Country ) AS NumberOfCountries,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals ) AS TotalArrivals,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalFlights
      FROM Z02_carrier_airport_union
      GROUP BY CarrierId, CarrierName
      ORDER BY TotalFlights DESCENDING
      INTO TABLE @DATA(lt_all_carriers).

    out->write( data = lt_all_carriers name = 'Alle Airlines' ).
    out->write( '---' ).


    " STATISTIK B2: Top 10 Airlines
    " ============================================================
    out->write( 'B2. Top 10 Airlines nach Fluganzahl' ).

    SELECT
      CarrierId,
      CarrierName,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalFlights,
      COUNT( DISTINCT AirportId ) AS AirportsServed
      FROM Z02_carrier_airport_union
      GROUP BY CarrierId, CarrierName
      ORDER BY TotalFlights DESCENDING
      INTO TABLE @DATA(lt_top_carriers)
      UP TO 10 ROWS.

    out->write( data = lt_top_carriers name = 'Top 10 Airlines' ).
    out->write( '---' ).


    " STATISTIK B3: Internationale Airlines
    " ============================================================
    out->write( 'B3. Airlines mit internationaler Präsenz' ).

    SELECT
      CarrierId,
      CarrierName,
      COUNT( DISTINCT Country ) AS CountriesServed,
      COUNT( DISTINCT City ) AS CitiesServed,
      COUNT( DISTINCT AirportId ) AS AirportsServed,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalFlights
      FROM Z02_carrier_airport_union
      GROUP BY CarrierId, CarrierName
      HAVING COUNT( DISTINCT Country ) > 1
      ORDER BY CountriesServed DESCENDING, TotalFlights DESCENDING
      INTO TABLE @DATA(lt_international_carriers).

    out->write( data = lt_international_carriers name = 'Internationale Airlines' ).
    out->write( '---' ).


    " STATISTIK B4: Airlines pro Land
    " ============================================================
    out->write( 'B4. Anzahl Airlines pro Land' ).

    SELECT
      Country,
      COUNT( DISTINCT CarrierId ) AS NumberOfCarriers,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalFlights
      FROM Z02_carrier_airport_union
      GROUP BY Country
      ORDER BY NumberOfCarriers DESCENDING
      INTO TABLE @DATA(lt_carriers_per_country).

    out->write( data = lt_carriers_per_country name = 'Airlines pro Land' ).
    out->write( '---' ).


    " STATISTIK B5: Marktanteil Top 5
    " ============================================================
    out->write( 'B5. Marktanteil der Top 5 Airlines' ).

    " Gesamtanzahl Flüge
    SELECT SINGLE
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalFlights
      FROM Z02_carrier_airport_union
      INTO @DATA(lv_total_flights).

    SELECT
      CarrierId,
      CarrierName,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS CarrierFlights
      FROM Z02_carrier_airport_union
      GROUP BY CarrierId, CarrierName
      ORDER BY CarrierFlights DESCENDING
      INTO TABLE @DATA(lt_top5_carriers)
      UP TO 5 ROWS.

    " Marktanteil berechnen
    DATA: lt_market_share TYPE TABLE OF ty_market_share.

    IF lv_total_flights > 0.
      LOOP AT lt_top5_carriers ASSIGNING FIELD-SYMBOL(<carrier>).
        APPEND VALUE #(
          carrier_id   = <carrier>-CarrierId
          carrier_name = <carrier>-CarrierName
          flights      = <carrier>-CarrierFlights
          market_share = ( <carrier>-CarrierFlights * 100 ) / lv_total_flights
        ) TO lt_market_share.
      ENDLOOP.
    ENDIF.

    out->write( data = lt_market_share name = 'Marktanteil Top 5 (%)' ).
    out->write( '---' ).


    " ============================================================
    " TEIL C: AIRLINE-FLUGHAFEN KOMBINATIONEN
    " ============================================================

    out->write( '' ).
    out->write( 'TEIL C: AIRLINE-FLUGHAFEN KOMBINATIONEN' ).
    out->write( '========================================' ).
    out->write( '' ).


    " STATISTIK C1: Top Kombinationen
    " ============================================================
    out->write( 'C1. Top 20 Airline-Flughafen Kombinationen' ).

    SELECT
      CarrierId,
      CarrierName,
      AirportId,
      AirportName,
      City,
      Country,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals ) AS TotalArrivals,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalFlights
      FROM Z02_carrier_airport_union
      GROUP BY CarrierId, CarrierName, AirportId, AirportName, City, Country
      ORDER BY TotalFlights DESCENDING
      INTO TABLE @DATA(lt_carrier_airport_combo)
      UP TO 20 ROWS.

    out->write( data = lt_carrier_airport_combo name = 'Top Kombinationen' ).
    out->write( '---' ).


    " STATISTIK C2: Airlines pro Flughafen
    " ============================================================
    out->write( 'C2. Airlines pro Flughafen (Top 20)' ).

    SELECT
      AirportId,
      AirportName,
      City,
      Country,
      COUNT( DISTINCT CarrierId ) AS NumberOfCarriers,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalFlights
      FROM Z02_carrier_airport_union
      GROUP BY AirportId, AirportName, City, Country
      ORDER BY NumberOfCarriers DESCENDING
      INTO TABLE @DATA(lt_carriers_per_airport)
      UP TO 20 ROWS.

    out->write( data = lt_carriers_per_airport name = 'Airlines pro Flughafen' ).
    out->write( '---' ).


    " STATISTIK C3: Dominante Airline pro Flughafen
    " ============================================================
    out->write( 'C3. Dominante Airline pro Flughafen' ).

    " Gesamtverkehr pro Flughafen
    SELECT
      AirportId,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS AirportTotal
      FROM Z02_carrier_airport_union
      GROUP BY AirportId
      INTO TABLE @DATA(lt_airport_totals).

    " Größte Airline pro Flughafen
    SELECT
      AirportId,
      AirportName,
      City,
      Country,
      CarrierId,
      CarrierName,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS CarrierFlights
      FROM Z02_carrier_airport_union
      GROUP BY AirportId, AirportName, City, Country, CarrierId, CarrierName
      ORDER BY AirportId, CarrierFlights DESCENDING
      INTO TABLE @DATA(lt_carrier_by_airport).

    " Nur dominante Airline pro Flughafen
    DATA: lt_dominant     TYPE TABLE OF ty_dominant,
          lv_last_airport TYPE /dmo/airport_id.

    LOOP AT lt_carrier_by_airport ASSIGNING FIELD-SYMBOL(<ca>).
      IF <ca>-AirportId <> lv_last_airport.
        READ TABLE lt_airport_totals
          ASSIGNING FIELD-SYMBOL(<total>)
          WITH KEY AirportId = <ca>-AirportId.

        IF sy-subrc = 0 AND <total>-AirportTotal > 0.
          APPEND VALUE #(
            airport_id      = <ca>-AirportId
            airport_name    = <ca>-AirportName
            city            = <ca>-City
            country         = <ca>-Country
            carrier_id      = <ca>-CarrierId
            carrier_name    = <ca>-CarrierName
            carrier_flights = <ca>-CarrierFlights
            airport_total   = <total>-AirportTotal
            market_share    = ( <ca>-CarrierFlights * 100 ) / <total>-AirportTotal
          ) TO lt_dominant.
        ENDIF.

        lv_last_airport = <ca>-AirportId.
      ENDIF.
    ENDLOOP.

    SORT lt_dominant BY market_share DESCENDING.

    out->write( data = lt_dominant name = 'Dominante Airlines' ).
    out->write( '---' ).


   " STATISTIK C4: Monopol-Flughäfen
" ============================================================
out->write( 'C4. Monopol-Flughäfen (nur eine Airline)' ).

" Schritt 1: Carrier pro Flughafen zählen
SELECT
  AirportId,
  COUNT( DISTINCT CarrierId ) AS CarrierCount
  FROM Z02_carrier_airport_union
  GROUP BY AirportId
  INTO TABLE @DATA(lt_carrier_counts).

" Schritt 2: Alle Flughafen-Carrier-Kombinationen holen
SELECT
  AirportId,
  AirportName,
  City,
  Country,
  CarrierId,
  CarrierName,
  Departures,
  Arrivals
  FROM Z02_carrier_airport_union
  INTO TABLE @DATA(lt_all_combinations).

" Schritt 3: Monopole identifizieren und Details aggregieren
DATA: lt_monopoly_details TYPE TABLE OF ty_monopoly.

LOOP AT lt_carrier_counts ASSIGNING FIELD-SYMBOL(<cc>)
  WHERE CarrierCount = 1.

  DATA(lv_airport_id) = <cc>-AirportId.
  DATA(lv_total_departures) = 0.
  DATA(lv_total_arrivals) = 0.
  DATA(lv_airport_name) = ''.
  DATA(lv_city) = ''.
  DATA(lv_country) = ''.
  DATA(lv_carrier_id) = ''.
  DATA(lv_carrier_name) = ''.

  " Alle Einträge für diesen Flughafen aggregieren
  LOOP AT lt_all_combinations ASSIGNING FIELD-SYMBOL(<comb>)
    WHERE AirportId = lv_airport_id.

    lv_total_departures = lv_total_departures + <comb>-Departures.
    lv_total_arrivals = lv_total_arrivals + <comb>-Arrivals.
    lv_airport_name = <comb>-AirportName.
    lv_city = <comb>-City.
    lv_country = <comb>-Country.
    lv_carrier_id = <comb>-CarrierId.
    lv_carrier_name = <comb>-CarrierName.

  ENDLOOP.

  " Monopol-Details hinzufügen
  APPEND VALUE #(
    airport_id    = lv_airport_id
    airport_name  = lv_airport_name
    city          = lv_city
    country       = lv_country
    carrier_id    = lv_carrier_id
    carrier_name  = lv_carrier_name
    total_flights = lv_total_departures + lv_total_arrivals
  ) TO lt_monopoly_details.

ENDLOOP.

IF lt_monopoly_details IS NOT INITIAL.
  SORT lt_monopoly_details BY total_flights DESCENDING.
  out->write( data = lt_monopoly_details name = 'Monopole' ).
ELSE.
  out->write( 'Keine Monopole gefunden' ).
ENDIF.
out->write( '---' ).


    " STATISTIK C5: Top Airline pro Land
    " ============================================================
    out->write( 'C5. Führende Airline pro Land' ).

    SELECT
      Country,
      CarrierId,
      CarrierName,
      COUNT( DISTINCT AirportId ) AS AirportsInCountry,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS FlightsInCountry
      FROM Z02_carrier_airport_union
      GROUP BY Country, CarrierId, CarrierName
      ORDER BY Country, FlightsInCountry DESCENDING
      INTO TABLE @DATA(lt_carrier_per_country_all).

    " Nur Top-Airline pro Land
    DATA: lt_top_per_country TYPE TABLE OF ty_top_carrier_country,
          lv_last_country    TYPE land1.

    LOOP AT lt_carrier_per_country_all ASSIGNING FIELD-SYMBOL(<cpc>).
      IF <cpc>-Country <> lv_last_country.
        APPEND VALUE #(
          country      = <cpc>-Country
          carrier_id   = <cpc>-CarrierId
          carrier_name = <cpc>-CarrierName
          airports     = <cpc>-AirportsInCountry
          flights      = <cpc>-FlightsInCountry
        ) TO lt_top_per_country.

        lv_last_country = <cpc>-Country.
      ENDIF.
    ENDLOOP.

    out->write( data = lt_top_per_country name = 'Top Airline pro Land' ).
    out->write( '---' ).


    " STATISTIK C6: Spezifische Airline
    " ============================================================
    out->write( |C6. Detailanalyse Airline: { c_carrierid }| ).

    SELECT
      Country,
      City,
      AirportId,
      AirportName,
      SUM( Departures ) AS Departures,
      SUM( Arrivals ) AS Arrivals,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalFlights
      FROM Z02_carrier_airport_union
      WHERE CarrierId = @c_carrierid
      GROUP BY Country, City, AirportId, AirportName
      ORDER BY TotalFlights DESCENDING
      INTO TABLE @DATA(lt_specific_carrier).

    IF sy-subrc = 0.
      out->write( data = lt_specific_carrier name = |Airline { c_carrierid }| ).
    ELSE.
      out->write( |Keine Daten für { c_carrierid } gefunden| ).
    ENDIF.
    out->write( '---' ).


    " STATISTIK C7: Wettbewerbsintensität
    " ============================================================
    out->write( 'C7. Wettbewerbsintensität (Verteilung)' ).

    " Schritt 1: Carrier pro Flughafen zählen
    SELECT
      AirportId,
      COUNT( DISTINCT CarrierId ) AS CarrierCount
      FROM Z02_carrier_airport_union
      GROUP BY AirportId
      INTO TABLE @DATA(lt_airport_carrier_count).

    " Schritt 2: Kategorisieren
    DATA: lt_competition TYPE TABLE OF ty_competition,
          lv_monopoly    TYPE i VALUE 0,
          lv_low         TYPE i VALUE 0,
          lv_medium      TYPE i VALUE 0,
          lv_high        TYPE i VALUE 0.

    LOOP AT lt_airport_carrier_count ASSIGNING FIELD-SYMBOL(<acc>).
      CASE <acc>-CarrierCount.
        WHEN 1.
          lv_monopoly = lv_monopoly + 1.
        WHEN 2 OR 3.
          lv_low = lv_low + 1.
        WHEN 4 OR 5 OR 6.
          lv_medium = lv_medium + 1.
        WHEN OTHERS.
          lv_high = lv_high + 1.
      ENDCASE.
    ENDLOOP.

    " Ergebnis-Tabelle aufbauen
    lt_competition = VALUE #(
      ( competition_level = 'Monopol'              number_of_airports = lv_monopoly )
      ( competition_level = 'Wenig Wettbewerb'     number_of_airports = lv_low )
      ( competition_level = 'Mittlerer Wettbewerb' number_of_airports = lv_medium )
      ( competition_level = 'Hoher Wettbewerb'     number_of_airports = lv_high )
    ).

    " Null-Einträge entfernen
    DELETE lt_competition WHERE number_of_airports = 0.

    out->write( data = lt_competition name = 'Wettbewerbsverteilung' ).
    out->write( '---' ).


    " STATISTIK C8: Globale Airline-Zusammenfassung
    " ============================================================
    out->write( 'C8. Globale Airline-Zusammenfassung' ).

    SELECT SINGLE
      COUNT( DISTINCT CarrierId ) AS TotalCarriers,
      COUNT( DISTINCT AirportId ) AS TotalAirports,
      COUNT( DISTINCT Country ) AS TotalCountries,
      SUM( Departures ) AS TotalDepartures,
      SUM( Arrivals ) AS TotalArrivals,
      ( SUM( Departures ) + SUM( Arrivals ) ) AS TotalFlights
      FROM Z02_carrier_airport_union
      INTO @DATA(ls_carrier_global).

    out->write( data = ls_carrier_global name = 'Global Airlines' ).
    out->write( '---' ).


    " ============================================================
    " Abschluss
    " ============================================================
    out->write( '' ).
    out->write( '========================================' ).
    out->write( 'Alle Statistiken erfolgreich erstellt!' ).
    out->write( '========================================' ).

  ENDMETHOD.
ENDCLASS.
