*&---------------------------------------------------------------------*
*& Report zlsws010104_pr_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlsws0104_pr_02.

INCLUDE zlsws010104_incl_01.

START-OF-SELECTION.


  DATA:
    lr_ixml     TYPE REF TO if_ixml,
    lr_doc      TYPE REF TO if_ixml_document,
    lr_element1 TYPE REF TO if_ixml_element,
    lr_element2 TYPE REF TO if_ixml_element,
    lr_sf       TYPE REF TO if_ixml_stream_factory,
    lr_ostream  TYPE REF TO if_ixml_ostream,
    lv_xml      TYPE string,
    lr_renderer TYPE REF TO if_ixml_renderer.


  """"""""""""""""""""""""""""""
  " neues Dokument erstellen

  lr_ixml = cl_ixml=>create( ).
  lr_doc = lr_ixml->create_document( ).


  """"""""""""""""""""""""""""""
  " XML Daten erzeugen

  lr_element1 = lr_doc->create_element( name = 'root' ).
  lr_element1->set_attribute( name = 'attr' value = 'value' ).
  lr_doc->append_child( lr_element1 ).
  lr_element2 = lr_doc->create_element( name = 'child' ).
  lr_element2->set_value( 'text' ).
  lr_element1->append_child( lr_element2 ).



  """"""""""""""""""""""""""""""
  " Rendern

  lr_sf = lr_ixml->create_stream_factory( ).
*  lr_ostream = lr_sf->create_ostream_xstring( lv_out ).
  lr_ostream = lr_sf->create_ostream_cstring( lv_xml  ).
  lr_renderer = lr_ixml->create_renderer(
  document = lr_doc
  ostream = lr_ostream ).
  lr_renderer->render( ).


  """"""""""""""""""""""""""""
  " Ausgabe

  lcl_help=>popup_xml( lv_xml ).
