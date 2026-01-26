CLASS lhc_Flight DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Flight RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Flight RESULT result.

ENDCLASS.

CLASS lhc_Flight IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

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
  ENDMETHOD.

  METHOD setBookingDate.
  ENDMETHOD.

  METHOD setFlightData.
  ENDMETHOD.

  METHOD updateSeatsOccupied.
  ENDMETHOD.

  METHOD validateConnection.
  ENDMETHOD.

  METHOD validateCustomer.
  ENDMETHOD.

ENDCLASS.
