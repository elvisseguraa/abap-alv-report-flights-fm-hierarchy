*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_MAI
*&---------------------------------------------------------------------*
START-OF-SELECTION.

PERFORM get_data.
PERFORM build_fieldcat.
PERFORM build_layout.
PERFORM add_events.
PERFORM display_alv_hier.

END-OF-SELECTION.