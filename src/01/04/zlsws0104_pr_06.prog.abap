*&---------------------------------------------------------------------*
*& Report zlsws010104_pr_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlsws0104_pr_06.

INCLUDE zlsws010104_incl_01.


CLASS lcl_my_class DEFINITION.


  PUBLIC SECTION.

    INTERFACES:
      if_serializable_object.

    DATA:
      BEGIN OF gs_vbak,
        werk  TYPE werks_d,
        vkorg TYPE vkorg,
        matnr TYPE matnr,
      END OF gs_vbak.


    METHODS:
      set_data.

ENDCLASS.

CLASS lcl_my_class IMPLEMENTATION.

  METHOD set_data.

    gs_vbak-werk = '1000'.
    gs_vbak-vkorg = '1010'.
    gs_vbak-matnr = 'Test'.

  ENDMETHOD.


ENDCLASS.

START-OF-SELECTION.

  DATA:
    lo_data      TYPE REF TO lcl_my_class,
    lo_data_copy TYPE REF TO lcl_my_class,
    lv_xml_data  TYPE string.


  CREATE OBJECT lo_data.


  lo_data->set_data(  ).


  CALL TRANSFORMATION id
    OPTIONS data_refs = 'heap-or-create'
    SOURCE test = lo_data
    RESULT XML lv_xml_data.



  "kann jetzt auf persistent abgespeichert werden etc



  CALL TRANSFORMATION id
  SOURCE XML lv_xml_data
  RESULT test = lo_data_copy.


  BREAK-POINT.
