*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_SEL
*&---------------------------------------------------------------------*

TABLES: spfli.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*  PARAMETERS: p_carr TYPE s_carr_id.
  SELECT-OPTIONS: s_carr FOR spfli-carrid.
SELECTION-SCREEN END OF BLOCK b1.