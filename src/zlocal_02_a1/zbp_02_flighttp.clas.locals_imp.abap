" 1. DEFINITIONEN
CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS setFlightData FOR DETERMINE ON MODIFY IMPORTING keys FOR Booking~setFlightData.
    METHODS updateSeatsOccupied FOR DETERMINE ON MODIFY IMPORTING keys FOR Booking~updateSeatsOccupied.
    METHODS validateConnection FOR VALIDATE ON SAVE IMPORTING keys FOR Booking~validateConnection.
    METHODS validateCustomer FOR VALIDATE ON SAVE IMPORTING keys FOR Booking~validateCustomer.
ENDCLASS.

CLASS lhc_Flight DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Flight RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Flight RESULT result.
ENDCLASS.

" ---
" 2. IMPLEMENTIERUNGEN
CLASS lhc_Flight IMPLEMENTATION.
  METHOD get_instance_authorizations.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      APPEND VALUE #( %tky = <key>-%tky
                      %update = if_abap_behv=>auth-allowed
                      %delete = if_abap_behv=>auth-allowed ) TO result.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_global_authorizations.
  " 1. Berechtigung für Create
  IF requested_authorizations-%create = if_abap_behv=>mk-on.
    result-%create = if_abap_behv=>auth-allowed.
  ENDIF.

  " 2. Berechtigung für die Assoziation (Booking erstellen über Flight)
  " In deiner BDEF heißt die Assoziation _Bookings
  IF requested_authorizations-%assoc-_Bookings = if_abap_behv=>mk-on.
    result-%assoc-_Bookings = if_abap_behv=>auth-allowed.
  ENDIF.
ENDMETHOD.
ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.
  METHOD updateSeatsOccupied.
    " Deine Logik
  ENDMETHOD.

  METHOD validateConnection.
    " Deine Logik
  ENDMETHOD.

  METHOD validateCustomer.
    " Deine Logik
  ENDMETHOD.

  METHOD setFlightData.
    " Deine Logik
  ENDMETHOD.
ENDCLASS.
