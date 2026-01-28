CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateBookingId FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateBookingId.

    METHODS setBookingDate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~setBookingDate.

    METHODS setFlightData FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~setFlightData.

    METHODS updateSeatsOccupied FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~updateSeatsOccupied.

    METHODS validateConnection FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateConnection.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateCustomer.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD calculateBookingId.
    READ ENTITIES OF ZR_02_FlightTP IN LOCAL MODE
      ENTITY Booking BY \_Flight
        FIELDS ( CarrierId ConnectionId FlightDate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(flights).

    LOOP AT flights INTO DATA(flight).
      READ ENTITIES OF ZR_02_FlightTP IN LOCAL MODE
        ENTITY Flight BY \_Bookings
          FIELDS ( BookingId )
          WITH VALUE #( ( %tky = flight-%tky ) )
        RESULT DATA(bookings).

      DATA(max_booking_id) = REDUCE /dmo/booking_id( INIT max = 0
                                                     FOR  log_row IN bookings
                                                     NEXT max = COND #( WHEN log_row-BookingId > max
                                                                        THEN log_row-BookingId ELSE max ) ).

      LOOP AT bookings INTO DATA(booking) WHERE BookingId IS INITIAL.
        max_booking_id += 1.
        MODIFY ENTITIES OF ZR_02_FlightTP IN LOCAL MODE
          ENTITY Booking
            UPDATE FIELDS ( BookingId )
            WITH VALUE #( ( %tky      = booking-%tky
                            BookingId = max_booking_id ) ).
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD setBookingDate.
    MODIFY ENTITIES OF ZR_02_FlightTP IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( BookingDate )
        WITH VALUE #( FOR key IN keys (
          %tky        = key-%tky
          BookingDate = cl_abap_context_info=>get_system_date( )
        ) ).
  ENDMETHOD.

  METHOD setFlightData.
    READ ENTITIES OF ZR_02_FlightTP IN LOCAL MODE
      ENTITY Booking BY \_Flight
        FIELDS ( CarrierId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(flights).

    LOOP AT flights INTO DATA(flight).
      MODIFY ENTITIES OF ZR_02_FlightTP IN LOCAL MODE
        ENTITY Booking
          UPDATE FIELDS ( CarrierId )
          WITH VALUE #( FOR key IN keys (
            %tky      = key-%tky
            CarrierId = flight-CarrierId
          ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD updateSeatsOccupied.
    READ ENTITIES OF ZR_02_FlightTP IN LOCAL MODE
      ENTITY Booking BY \_Flight
        FIELDS ( CarrierId ConnectionId FlightDate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(flights).

    LOOP AT flights INTO DATA(flight).
      SELECT COUNT( * ) FROM /dmo/booking
        WHERE carrier_id    = @flight-CarrierId
          AND connection_id = @flight-ConnectionId
          AND flight_date   = @flight-FlightDate
        INTO @DATA(booked_seats).

      MODIFY ENTITIES OF ZR_02_FlightTP IN LOCAL MODE
        ENTITY Flight
          UPDATE FIELDS ( SeatsOccupied )
          WITH VALUE #( ( %tky          = flight-%tky
                          SeatsOccupied = booked_seats ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD validateConnection.
    " Implementierung der Prüfung von ConnectionId und FlightDate
  ENDMETHOD.

  METHOD validateCustomer.
    " Implementierung der Prüfung ob CustomerId existiert
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Flight DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Flight RESULT result.
ENDCLASS.

CLASS lhc_Flight IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.
ENDCLASS.
