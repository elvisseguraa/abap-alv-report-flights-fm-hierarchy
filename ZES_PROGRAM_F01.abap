*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT * UP TO 20  INTO TABLE gtd_header
    FROM spfli
    WHERE carrid IN s_carr.
  IF sy-subrc EQ 0.

    SELECT * INTO TABLE gtd_detail
      FROM sflight FOR ALL ENTRIES IN gtd_header
      WHERE carrid = gtd_header-carrid.
      
  ENDIF.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcat_standard USING p_program_name     TYPE sy-repid
                                   p_internal_tabname TYPE slis_tabname
                                   p_structure_name   TYPE dd02l-tabname
                             CHANGING pt_fieldcat     TYPE slis_t_fieldcat_alv.


  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = p_program_name
      i_internal_tabname     = p_internal_tabname
      i_structure_name       = p_structure_name
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_INCLNAME             =
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    CHANGING
      ct_fieldcat            = pt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE 'Error en fieldcat merge.' TYPE 'S'.
  ENDIF.


ENDFORM.                    " BUILD_FIELDCAT


FORM build_fieldcat .

  PERFORM build_fieldcat_standard USING sy-repid 'GTD_HEADER' 'SPFLI'
                                  CHANGING gtd_fieldcat.

  PERFORM build_fieldcat_standard USING sy-repid 'GTD_DETAIL' 'SFLIGHT'
                                  CHANGING gtd_fieldcat.

*  CLEAR: gwa_fieldcat.
*  gwa_fieldcat-fieldname = 'CARRID'.
*  gwa_fieldcat-seltext_l = 'Airline Code'.
*  gwa_fieldcat-key       = 'X'. "Columna clave
*  APPEND gwa_fieldcat TO gtd_fieldcat.
*
*  CLEAR: gwa_fieldcat.
*  gwa_fieldcat-fieldname = 'CONNID'.
*  gwa_fieldcat-seltext_l = 'Flight Number'.
*  gwa_fieldcat-key       = 'X'.
*  APPEND gwa_fieldcat TO gtd_fieldcat.
*
*  CLEAR: gwa_fieldcat.
*  gwa_fieldcat-fieldname = 'CITYFROM'.
*  gwa_fieldcat-seltext_l = 'Departure city'.
*  gwa_fieldcat-outputlen = 20.
*  APPEND gwa_fieldcat TO gtd_fieldcat.
*
*  CLEAR: gwa_fieldcat.
*  gwa_fieldcat-fieldname = 'CITYTO'.
*  gwa_fieldcat-seltext_l = 'Arrival city'.
*  gwa_fieldcat-outputlen = 20.
*  APPEND gwa_fieldcat TO gtd_fieldcat.

ENDFORM.                    " BUILD_FIELDCAT

*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_layout .

  CLEAR: gwa_layout.
  gwa_layout-zebra = 'X'.

ENDFORM.                    " BUILD_LAYOUT

FORM user_command USING p_ucomm    LIKE sy-ucomm
                        p_selfield TYPE slis_selfield.

  IF p_ucomm EQ '&INF'.
    MESSAGE 'Detalles del vuelo' TYPE'I'.
  ENDIF.

ENDFORM.

FORM set_pf_status USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'STATUS_0100'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADD_EVENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM add_events .

  CLEAR: gwa_events.
  gwa_events-name = 'TOP_OF_PAGE'.
  gwa_events-form = 'TOP_OF_PAGE'.
  APPEND gwa_events TO gtd_events.

  CLEAR: gwa_events.
  gwa_events-name = 'PF_STATUS_SET'.
  gwa_events-form = 'SET_PF_STATUS'.
  APPEND gwa_events TO gtd_events.

  CLEAR: gwa_events.
  gwa_events-name = 'USER_COMMAND'.
  gwa_events-form = 'USER_COMMAND'.
  APPEND gwa_events TO gtd_events.

ENDFORM.                    " ADD_EVENTS

FORM top_of_page.

  WRITE: / 'Hour:', sy-uzeit ENVIRONMENT TIME FORMAT,
  / 'User:', sy-uname.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_HIER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv_hier .

  DATA: gwa_keyinfo TYPE slis_keyinfo_alv.

  CLEAR: gwa_keyinfo.

  gwa_keyinfo-header01 = 'MANDT'.
  gwa_keyinfo-header02 = 'CARRID'.
  gwa_keyinfo-header03 = 'CONNID'.

  gwa_keyinfo-item01 = 'MANDT'.
  gwa_keyinfo-item02 = 'CARRID'.
  gwa_keyinfo-item03 = 'CONNID'.

  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET       = ' '
*     I_CALLBACK_USER_COMMAND        = ' '
*     IS_LAYOUT          =
      it_fieldcat        = gtd_fieldcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_SCREEN_START_COLUMN          = 0
*     I_SCREEN_START_LINE            = 0
*     I_SCREEN_END_COLUMN            = 0
*     I_SCREEN_END_LINE  = 0
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
      it_events          = gtd_events
*     IT_EVENT_EXIT      =
      i_tabname_header   = 'GTD_HEADER'
      i_tabname_item     = 'GTD_DETAIL'
*     I_STRUCTURE_NAME_HEADER        =
*     I_STRUCTURE_NAME_ITEM          =
      is_keyinfo         = gwa_keyinfo
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_BYPASSING_BUFFER =
*     I_BUFFER_ACTIVE    =
*     IR_SALV_HIERSEQ_ADAPTER        =
*     IT_EXCEPT_QINFO    =
*     I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER        =
*     ES_EXIT_CAUSED_BY_USER         =
    TABLES
      t_outtab_header    = gtd_header
      t_outtab_item      = gtd_detail
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE 'Error.' TYPE 'S'.
  ENDIF.


ENDFORM.                    " DISPLAY_ALV_HIER