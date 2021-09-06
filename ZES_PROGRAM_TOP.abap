*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS slis.

TYPES:
  BEGIN OF gty_flights,
    carrid   TYPE s_carr_id,
    connid   TYPE s_conn_id,
    cityfrom TYPE s_from_cit,
    cityto   TYPE s_to_city,
  END OF gty_flights.

DATA: gtd_flights  TYPE TABLE OF gty_flights,
      gtd_fieldcat TYPE slis_t_fieldcat_alv,
      gwa_fieldcat TYPE slis_fieldcat_alv,
      gwa_layout   TYPE slis_layout_alv,
      gtd_events   TYPE slis_t_event,
      gwa_events   TYPE slis_alv_event.

DATA: gtd_header TYPE TABLE OF spfli,
      gtd_detail TYPE TABLE OF sflight.