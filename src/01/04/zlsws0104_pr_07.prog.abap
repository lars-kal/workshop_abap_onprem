*&---------------------------------------------------------------------*
*& Report zlsws010104_pr_07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlsws0104_pr_07.


include zlsws010104_incl_01.



START-OF-SELECTION.
*
* DATA:
*  gv_xml_data TYPE string,
*  gs_data     type zkal_s_xml_05.
*
*
*""""""""""""""""""""""""""""""""""""""""""""""
*" Beispieldaten aufbauen
*
*gs_data-werks = '1000'.
*gs_data-vkorg = '1010'.
*
*append 'ABCDEFG'      to gs_data-t_position.
*append 'testmaterial' to gs_data-t_position.
*
*
*
*
*  BREAK-POINT.
*
*
*  """"""""""""""""""""""""""""
*  " Transformation
*
*call TRANSFORMATION ZTR_KAL_TEST2
**  OPTIONS data_refs = 'heap-or-create'
*    SOURCE data =  gs_data
*    RESULT XML gv_xml_data.
*
*
*
*
*  """"""""""""""""""""""""""""
*  " XML Ausgabe
*
*lcl_help=>popup_xml( gv_xml_data ).
