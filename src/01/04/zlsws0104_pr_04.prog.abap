*&---------------------------------------------------------------------*
*& Report zlsws010104_pr_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlsws0104_pr_04.


include zlsws010104_incl_01.


START-OF-SELECTION.

DATA:
  BEGIN OF gs_vbak,
    werk  TYPE werks_d,
    vkorg TYPE vkorg,
    matnr TYPE matnr,
  END OF gs_vbak,

  gv_xml_data TYPE string.


""""""""""""""""""""""""""""
" Daten erzeugen

gs_vbak-werk = '1000'.
gs_vbak-vkorg = '1010'.
gs_vbak-matnr = 'Test'.


""""""""""""""""""""""""""""
" Identische Transformation

CALL TRANSFORMATION id
*OPTIONS data_refs = 'heap-or-create'
SOURCE test =  gs_vbak
RESULT XML gv_xml_data.


""""""""""""""""""""""""""""
" Debugger Optionen

BREAK-POINT.


""""""""""""""""""""""""""""
" Ausgabe

lcl_help=>popup_xml( gv_xml_data ).
