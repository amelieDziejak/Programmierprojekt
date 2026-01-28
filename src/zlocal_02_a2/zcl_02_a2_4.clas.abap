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

    " ══════════════════════════════════════════════════════════════
    " KONSTANTEN
    " ══════════════════════════════════════════════════════════════
    CONSTANTS:
      c_country   TYPE land1           VALUE 'DE',
      c_city      TYPE string          VALUE 'Frankfurt/Main',
      c_airportid TYPE /dmo/airport_id VALUE 'FRA',
      c_carrierid TYPE /dmo/carrier_id VALUE 'LH'.

    " ══════════════════════════════════════════════════════════════
    " TYPE DEFINITIONEN
    " ══════════════════════════════════════════════════════════════
    TYPES: BEGIN OF ty_market_share,
             rang         TYPE i,
             carrier_id   TYPE /dmo/carrier_id,
             carrier_name TYPE /dmo/carrier_name,
             flights      TYPE i,
             market_share TYPE p LENGTH 5 DECIMALS 1,
           END OF ty_market_share.

    TYPES: BEGIN OF ty_dominant,
             airport_id   TYPE /dmo/airport_id,
             airport_name TYPE /dmo/airport_name,
             city         TYPE /dmo/city,
             carrier_id   TYPE /dmo/carrier_id,
             carrier_name TYPE /dmo/carrier_name,
             flights      TYPE i,
             total        TYPE i,
             share_pct    TYPE p LENGTH 5 DECIMALS 1,
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


    " ══════════════════════════════════════════════════════════════
    " HEADER
    " ══════════════════════════════════════════════════════════════
    out->write( `════════════════════════════════════════════════════════════════════` ).
    out->write( `         FLUGHAFEN & AIRLINE STATISTIKEN - ÜBERSICHT` ).
    out->write( `════════════════════════════════════════════════════════════════════` ).
    out->write( `` ).


    " ╔════════════════════════════════════════════════════════════╗
    " ║  TEIL A: FLUGHAFEN STATISTIKEN                             ║
    " ╚════════════════════════════════════════════════════════════╝

    out->write( `────────────────────────────────────────────────────────────────────` ).
    out->write( `  TEIL A: FLUGHAFEN STATISTIKEN` ).
    out->write( `────────────────────────────────────────────────────────────────────` ).
    out->write( `` ).


    " A1: Spezifisches Land
    out->write( |>>> A1: Statistik für Land { c_country }| ).
    out->write( `` ).

    SELECT Country,
           SUM( Departures ) AS Abfluege,
           SUM( Arrivals )   AS Ankuenfte,
           SUM( Departures ) + SUM( Arrivals ) AS Gesamt
      FROM z02_carrier_airport_union
      WHERE Country = @c_country
      GROUP BY Country
      INTO TABLE @DATA(lt_country_stats).

    out->write( data = lt_country_stats ).
    out->write( `` ).


    " A2: Spezifische Stadt
    out->write( |>>> A2: Statistik für Stadt { c_city }| ).
    out->write( `` ).

    SELECT City,
           SUM( Departures ) AS Abfluege,
           SUM( Arrivals )   AS Ankuenfte,
           SUM( Departures ) + SUM( Arrivals ) AS Gesamt
      FROM z02_carrier_airport_union
      WHERE upper( City ) = @( to_upper( c_city ) )
      GROUP BY City
      INTO TABLE @DATA(lt_city_stats).

    out->write( data = lt_city_stats ).
    out->write( `` ).


    " A3: Spezifischer Flughafen
    out->write( |>>> A3: Statistik für Flughafen { c_airportid }| ).
    out->write( `` ).

    SELECT AirportId   AS ID,
           AirportName AS Name,
           SUM( Departures ) AS Abfluege,
           SUM( Arrivals )   AS Ankuenfte,
           SUM( Departures ) + SUM( Arrivals ) AS Gesamt
      FROM z02_carrier_airport_union
      WHERE AirportId = @c_airportid
      GROUP BY AirportId, AirportName
      INTO TABLE @DATA(lt_airport_stats).

    out->write( data = lt_airport_stats ).
    out->write( `` ).


    " A4: TOP 9 Flughäfen (alle vorhandenen)
    out->write( `>>> A4: Alle Flughäfen nach Gesamtverkehr (Ranking)` ).
    out->write( `` ).

    SELECT AirportId   AS ID,
           AirportName AS Flughafen,
           City        AS Stadt,
           Country     AS Land,
           SUM( Departures ) AS Abfluege,
           SUM( Arrivals )   AS Ankuenfte,
           SUM( Departures ) + SUM( Arrivals ) AS Gesamt
      FROM z02_carrier_airport_union
      GROUP BY AirportId, AirportName, City, Country
      ORDER BY Gesamt DESCENDING
      INTO TABLE @DATA(lt_top_airports).

    out->write( data = lt_top_airports ).
    out->write( `` ).


    " A5: Statistik pro Land
    out->write( `>>> A5: Länderübersicht` ).
    out->write( `` ).

    SELECT Country AS Land,
           COUNT( DISTINCT AirportId ) AS Flughaefen,
           SUM( Departures ) AS Abfluege,
           SUM( Arrivals )   AS Ankuenfte,
           SUM( Departures ) + SUM( Arrivals ) AS Gesamt
      FROM z02_carrier_airport_union
      GROUP BY Country
      ORDER BY Gesamt DESCENDING
      INTO TABLE @DATA(lt_all_countries).

    out->write( data = lt_all_countries ).
    out->write( `` ).


    " A6: Städte-Ranking
    out->write( `>>> A6: Städte-Ranking nach Verkehrsaufkommen` ).
    out->write( `` ).

    SELECT City    AS Stadt,
           Country AS Land,
           SUM( Departures ) AS Abfluege,
           SUM( Arrivals )   AS Ankuenfte,
           SUM( Departures ) + SUM( Arrivals ) AS Gesamt
      FROM z02_carrier_airport_union
      GROUP BY City, Country
      ORDER BY Gesamt DESCENDING
      INTO TABLE @DATA(lt_all_cities).

    out->write( data = lt_all_cities ).
    out->write( `` ).


    " A7: Globale Zusammenfassung
    out->write( `>>> A7: Globale Zusammenfassung` ).
    out->write( `` ).

    SELECT SINGLE
           COUNT( DISTINCT Country )   AS Laender,
           COUNT( DISTINCT City )      AS Staedte,
           COUNT( DISTINCT AirportId ) AS Flughaefen,
           SUM( Departures )           AS Abfluege,
           SUM( Arrivals )             AS Ankuenfte,
           SUM( Departures ) + SUM( Arrivals ) AS Gesamt
      FROM z02_carrier_airport_union
      INTO @DATA(ls_global_airport).

    out->write( |    Länder:     { ls_global_airport-Laender }| ).
    out->write( |    Städte:     { ls_global_airport-Staedte }| ).
    out->write( |    Flughäfen:  { ls_global_airport-Flughaefen }| ).
    out->write( |    --------------------------------| ).
    out->write( |    Abflüge:    { ls_global_airport-Abfluege }| ).
    out->write( |    Ankünfte:   { ls_global_airport-Ankuenfte }| ).
    out->write( |    GESAMT:     { ls_global_airport-Gesamt }| ).
    out->write( `` ).
    out->write( `` ).


    " ╔════════════════════════════════════════════════════════════╗
    " ║  TEIL B: AIRLINE STATISTIKEN                               ║
    " ╚════════════════════════════════════════════════════════════╝

    out->write( `────────────────────────────────────────────────────────────────────` ).
    out->write( `  TEIL B: AIRLINE STATISTIKEN` ).
    out->write( `────────────────────────────────────────────────────────────────────` ).
    out->write( `` ).


    " B1: Übersicht aller Airlines
    out->write( `>>> B1: Airline-Ranking nach Fluganzahl` ).
    out->write( `` ).

    SELECT CarrierId   AS ID,
           CarrierName AS Airline,
           COUNT( DISTINCT AirportId ) AS Flughaefen,
           COUNT( DISTINCT Country )   AS Laender,
           SUM( Departures ) AS Abfluege,
           SUM( Arrivals )   AS Ankuenfte,
           SUM( Departures ) + SUM( Arrivals ) AS Gesamt
      FROM z02_carrier_airport_union
      GROUP BY CarrierId, CarrierName
      ORDER BY Gesamt DESCENDING
      INTO TABLE @DATA(lt_all_carriers).

    out->write( data = lt_all_carriers ).
    out->write( `` ).


    " B2: Internationale Präsenz
    out->write( `>>> B2: Internationale Präsenz (alle Airlines bedienen >1 Land)` ).
    out->write( `` ).

    SELECT CarrierId   AS ID,
           CarrierName AS Airline,
           COUNT( DISTINCT Country )   AS Laender,
           COUNT( DISTINCT City )      AS Staedte,
           COUNT( DISTINCT AirportId ) AS Flughaefen,
           SUM( Departures ) + SUM( Arrivals ) AS Fluege
      FROM z02_carrier_airport_union
      GROUP BY CarrierId, CarrierName
      ORDER BY Laender DESCENDING, Fluege DESCENDING
      INTO TABLE @DATA(lt_international).

    out->write( data = lt_international ).
    out->write( `` ).


    " B3: Airlines pro Land
    out->write( `>>> B3: Wettbewerb pro Land (Anzahl Airlines)` ).
    out->write( `` ).

    SELECT Country AS Land,
           COUNT( DISTINCT CarrierId ) AS Airlines,
           SUM( Departures ) + SUM( Arrivals ) AS Fluege
      FROM z02_carrier_airport_union
      GROUP BY Country
      ORDER BY Airlines DESCENDING
      INTO TABLE @DATA(lt_carriers_country).

    out->write( data = lt_carriers_country ).
    out->write( `` ).


    " B4: Marktanteil
    out->write( `>>> B4: Marktanteile der Airlines` ).
    out->write( `` ).

    SELECT SINGLE SUM( Departures ) + SUM( Arrivals ) AS total
      FROM z02_carrier_airport_union
      INTO @DATA(lv_total_flights).

    SELECT CarrierId,
           CarrierName,
           SUM( Departures ) + SUM( Arrivals ) AS flights
      FROM z02_carrier_airport_union
      GROUP BY CarrierId, CarrierName
      ORDER BY flights DESCENDING
      INTO TABLE @DATA(lt_carrier_flights).

    DATA: lt_market TYPE TABLE OF ty_market_share,
          lv_rang   TYPE i VALUE 0.

    LOOP AT lt_carrier_flights ASSIGNING FIELD-SYMBOL(<cf>).
      lv_rang = lv_rang + 1.
      APPEND VALUE #(
        rang         = lv_rang
        carrier_id   = <cf>-CarrierId
        carrier_name = <cf>-CarrierName
        flights      = <cf>-flights
        market_share = COND #( WHEN lv_total_flights > 0
                               THEN ( <cf>-flights * 100 ) / lv_total_flights
                               ELSE 0 )
      ) TO lt_market.
    ENDLOOP.

    out->write( |    Gesamtflüge im System: { lv_total_flights }| ).
    out->write( `` ).
    out->write( data = lt_market ).
    out->write( `` ).
    out->write( `` ).


    " ╔════════════════════════════════════════════════════════════╗
    " ║  TEIL C: AIRLINE-FLUGHAFEN ANALYSEN                        ║
    " ╚════════════════════════════════════════════════════════════╝

    out->write( `────────────────────────────────────────────────────────────────────` ).
    out->write( `  TEIL C: AIRLINE-FLUGHAFEN ANALYSEN` ).
    out->write( `────────────────────────────────────────────────────────────────────` ).
    out->write( `` ).


    " C1: Top Kombinationen
    out->write( `>>> C1: Stärkste Airline-Flughafen Verbindungen` ).
    out->write( `` ).

    SELECT CarrierId   AS Airline,
           AirportId   AS Airport,
           City        AS Stadt,
           SUM( Departures ) AS Abfl,
           SUM( Arrivals )   AS Ank,
           SUM( Departures ) + SUM( Arrivals ) AS Gesamt
      FROM z02_carrier_airport_union
      GROUP BY CarrierId, AirportId, City
      ORDER BY Gesamt DESCENDING
      INTO TABLE @DATA(lt_combo)
      UP TO 15 ROWS.

    out->write( data = lt_combo ).
    out->write( `` ).


    " C2: Wettbewerb pro Flughafen
    out->write( `>>> C2: Wettbewerbsintensität pro Flughafen` ).
    out->write( `` ).

    SELECT AirportId   AS ID,
           AirportName AS Flughafen,
           City        AS Stadt,
           COUNT( DISTINCT CarrierId ) AS Airlines,
           SUM( Departures ) + SUM( Arrivals ) AS Fluege
      FROM z02_carrier_airport_union
      GROUP BY AirportId, AirportName, City
      ORDER BY Airlines DESCENDING
      INTO TABLE @DATA(lt_competition).

    out->write( data = lt_competition ).
    out->write( `` ).


    " C3: Dominante Airline pro Flughafen
    out->write( `>>> C3: Marktführer pro Flughafen` ).
    out->write( `` ).

    " Airport-Totals
    SELECT AirportId,
           SUM( Departures ) + SUM( Arrivals ) AS total
      FROM z02_carrier_airport_union
      GROUP BY AirportId
      INTO TABLE @DATA(lt_apt_totals).

    " Carrier pro Airport
    SELECT AirportId,
           AirportName,
           City,
           CarrierId,
           CarrierName,
           SUM( Departures ) + SUM( Arrivals ) AS flights
      FROM z02_carrier_airport_union
      GROUP BY AirportId, AirportName, City, CarrierId, CarrierName
      ORDER BY AirportId, flights DESCENDING
      INTO TABLE @DATA(lt_carrier_apt).

    DATA: lt_dominant     TYPE TABLE OF ty_dominant,
          lv_last_airport TYPE /dmo/airport_id.

    LOOP AT lt_carrier_apt ASSIGNING FIELD-SYMBOL(<ca>).
      IF <ca>-AirportId <> lv_last_airport.
        READ TABLE lt_apt_totals ASSIGNING FIELD-SYMBOL(<tot>)
          WITH KEY AirportId = <ca>-AirportId.
        IF sy-subrc = 0 AND <tot>-total > 0.
          APPEND VALUE #(
            airport_id   = <ca>-AirportId
            airport_name = <ca>-AirportName
            city         = <ca>-City
            carrier_id   = <ca>-CarrierId
            carrier_name = <ca>-CarrierName
            flights      = <ca>-flights
            total        = <tot>-total
            share_pct    = ( <ca>-flights * 100 ) / <tot>-total
          ) TO lt_dominant.
        ENDIF.
        lv_last_airport = <ca>-AirportId.
      ENDIF.
    ENDLOOP.

    SORT lt_dominant BY share_pct DESCENDING.
    out->write( data = lt_dominant ).
    out->write( `` ).


    " C4: Monopol-Flughäfen
    out->write( `>>> C4: Monopol-Flughäfen (nur 1 Airline)` ).
    out->write( `` ).

    SELECT AirportId,
           COUNT( DISTINCT CarrierId ) AS cnt
      FROM z02_carrier_airport_union
      GROUP BY AirportId
      HAVING COUNT( DISTINCT CarrierId ) = 1
      INTO TABLE @DATA(lt_mono_ids).

    IF lt_mono_ids IS NOT INITIAL.
      SELECT AirportId   AS ID,
             AirportName AS Flughafen,
             City        AS Stadt,
             Country     AS Land,
             CarrierId   AS Airline,
             CarrierName AS Airline_Name,
             SUM( Departures ) + SUM( Arrivals ) AS Fluege
        FROM z02_carrier_airport_union
        WHERE AirportId IN ( SELECT AirportId FROM @lt_mono_ids AS mono )
        GROUP BY AirportId, AirportName, City, Country, CarrierId, CarrierName
        ORDER BY Fluege DESCENDING
        INTO TABLE @DATA(lt_monopolies).

      out->write( |    Anzahl: { lines( lt_monopolies ) } Flughäfen| ).
      out->write( `` ).
      out->write( data = lt_monopolies ).
    ENDIF.
    out->write( `` ).


    " C5: Marktführer pro Land
    out->write( `>>> C5: Marktführer pro Land` ).
    out->write( `` ).

    SELECT Country,
           CarrierId,
           CarrierName,
           COUNT( DISTINCT AirportId ) AS airports,
           SUM( Departures ) + SUM( Arrivals ) AS flights
      FROM z02_carrier_airport_union
      GROUP BY Country, CarrierId, CarrierName
      ORDER BY Country, flights DESCENDING
      INTO TABLE @DATA(lt_country_carrier).

    DATA: lt_leader      TYPE TABLE OF ty_top_carrier_country,
          lv_last_ctry   TYPE land1.

    LOOP AT lt_country_carrier ASSIGNING FIELD-SYMBOL(<cc>).
      IF <cc>-Country <> lv_last_ctry.
        APPEND VALUE #(
          country      = <cc>-Country
          carrier_id   = <cc>-CarrierId
          carrier_name = <cc>-CarrierName
          airports     = <cc>-airports
          flights      = <cc>-flights
        ) TO lt_leader.
        lv_last_ctry = <cc>-Country.
      ENDIF.
    ENDLOOP.

    out->write( data = lt_leader ).
    out->write( `` ).


    " C6: Detail-Analyse einer Airline
    out->write( |>>> C6: Detail-Analyse { c_carrierid } (Lufthansa)| ).
    out->write( `` ).

    SELECT Country     AS Land,
           City        AS Stadt,
           AirportId   AS Airport,
           AirportName AS Flughafen,
           SUM( Departures ) AS Abfl,
           SUM( Arrivals )   AS Ank,
           SUM( Departures ) + SUM( Arrivals ) AS Gesamt
      FROM z02_carrier_airport_union
      WHERE CarrierId = @c_carrierid
      GROUP BY Country, City, AirportId, AirportName
      ORDER BY Gesamt DESCENDING
      INTO TABLE @DATA(lt_lh_detail).

    out->write( data = lt_lh_detail ).
    out->write( `` ).


    " C7: Wettbewerbsanalyse (Verteilung)
    out->write( `>>> C7: Wettbewerbsanalyse - Verteilung` ).
    out->write( `` ).

    SELECT AirportId,
           COUNT( DISTINCT CarrierId ) AS cnt
      FROM z02_carrier_airport_union
      GROUP BY AirportId
      INTO TABLE @DATA(lt_apt_cnt).

    DATA: lv_mono   TYPE i VALUE 0,
          lv_wenig  TYPE i VALUE 0,
          lv_mittel TYPE i VALUE 0.

    LOOP AT lt_apt_cnt ASSIGNING FIELD-SYMBOL(<ac>).
      CASE <ac>-cnt.
        WHEN 1.     lv_mono   = lv_mono   + 1.
        WHEN 2 OR 3. lv_wenig  = lv_wenig  + 1.
        WHEN OTHERS. lv_mittel = lv_mittel + 1.
      ENDCASE.
    ENDLOOP.

    out->write( |    Monopol (1 Airline):        { lv_mono } Flughäfen| ).
    out->write( |    Wenig Wettbewerb (2-3):     { lv_wenig } Flughäfen| ).
    out->write( |    Mehr Wettbewerb (>3):       { lv_mittel } Flughäfen| ).
    out->write( |    ----------------------------------------| ).
    out->write( |    GESAMT:                     { lines( lt_apt_cnt ) } Flughäfen| ).
    out->write( `` ).
    out->write( `` ).


    " ══════════════════════════════════════════════════════════════
    " GLOBALE ZUSAMMENFASSUNG
    " ══════════════════════════════════════════════════════════════
    out->write( `────────────────────────────────────────────────────────────────────` ).
    out->write( `  GESAMTÜBERSICHT` ).
    out->write( `────────────────────────────────────────────────────────────────────` ).
    out->write( `` ).

    SELECT SINGLE
           COUNT( DISTINCT CarrierId )  AS airlines,
           COUNT( DISTINCT AirportId )  AS airports,
           COUNT( DISTINCT Country )    AS countries,
           COUNT( DISTINCT City )       AS cities,
           SUM( Departures )            AS departures,
           SUM( Arrivals )              AS arrivals,
           SUM( Departures ) + SUM( Arrivals ) AS total
      FROM z02_carrier_airport_union
      INTO @DATA(ls_summary).

    out->write( |    Airlines:      { ls_summary-airlines }| ).
    out->write( |    Flughäfen:     { ls_summary-airports }| ).
    out->write( |    Länder:        { ls_summary-countries }| ).
    out->write( |    Städte:        { ls_summary-cities }| ).
    out->write( |    ----------------------------------------| ).
    out->write( |    Abflüge:       { ls_summary-departures }| ).
    out->write( |    Ankünfte:      { ls_summary-arrivals }| ).
    out->write( |    ========================================| ).
    out->write( |    TOTAL FLÜGE:   { ls_summary-total }| ).
    out->write( `` ).
    out->write( `` ).
    out->write( `════════════════════════════════════════════════════════════════════` ).
    out->write( `  Statistik-Report erfolgreich erstellt` ).
    out->write( `════════════════════════════════════════════════════════════════════` ).

  ENDMETHOD.

ENDCLASS.
