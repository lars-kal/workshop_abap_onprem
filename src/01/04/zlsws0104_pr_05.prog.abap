*&---------------------------------------------------------------------*
*& Report zlsws010104_pr_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlsws0104_pr_05.

INCLUDE zlsws010104_incl_01.


START-OF-SELECTION.

  DATA:
    BEGIN OF gs_vbak,
      werk  TYPE werks_d,
      vkorg TYPE vkorg,
      matnr TYPE matnr,
    END OF gs_vbak,

    gv_xml_data TYPE string.
*
*
*""""""""""""""""""""""""""""
*" Daten erzeugen

  gs_vbak-werk = '1000'.
  gs_vbak-vkorg = '1010'.
  gs_vbak-matnr = 'Test'.



 BREAK-POINT.

*""""""""""""""""""""""""""""
*" Identische Transformation

  CALL TRANSFORMATION id
  SOURCE test =  gs_vbak
  RESULT XML gv_xml_data.



  """"""""""""""""""""""""""""
  " IXML Library rendern

* begin of XML parsen
  DATA: lo_ixml_factory        TYPE REF TO if_ixml,
        lo_ixml_stream_factory TYPE REF TO if_ixml_stream_factory,
        lo_ixml_istream        TYPE REF TO if_ixml_istream,
        lo_ixml_document       TYPE REF TO if_ixml_document,
        lo_ixml_parser         TYPE REF TO if_ixml_parser,
        lv_str                 TYPE string,
        lv_node                TYPE REF TO if_ixml_node,
        lv_node_root           TYPE REF TO if_ixml_node,
        lv_node_data           TYPE REF TO if_ixml_node,
        lv_iterator            TYPE REF TO if_ixml_node_iterator.


  " create new iXML factory
  lo_ixml_factory = cl_ixml=>create( ).

  " create new stream factory
  lo_ixml_stream_factory = lo_ixml_factory->create_stream_factory( ).

  "st_import-import_data
  lo_ixml_istream = lo_ixml_stream_factory->create_istream_cstring( gv_xml_data ).
*  lo_ixml_istream = lo_ixml_stream_factory->create_istream_xstring( l_data ).

  " create new document
  lo_ixml_document = lo_ixml_factory->create_document( ).

  " connect all with a parser
  lo_ixml_parser = lo_ixml_factory->create_parser( stream_factory = lo_ixml_stream_factory
                                                   istream  = lo_ixml_istream
                                                   document = lo_ixml_document ).


  lo_ixml_parser->parse( ).


  """"""""""""""""""""""""""""
  " XML Anpassen

  lv_iterator  = lo_ixml_document->create_iterator( 1 ).

  lv_node = lv_iterator->get_next( ).

  WHILE NOT lv_node IS INITIAL.

    lv_str = lv_node->get_name( ).
    WRITE: / lv_str.


    IF lv_str = 'abap'.
      lv_node_root = lv_node.

      lv_node =  lv_node->get_first_child( ).
      lv_node =  lv_node->get_first_child( ).
      lv_node->set_name( 'DATA' ).
      lv_node_data = lv_node->clone(  ).
*      lv_node->remove_node(  ).

    ENDIF.

    lv_node = lv_iterator->get_next( ).
  ENDWHILE.


  """"""""""""""""""""""""""""""
  " neues Dokument erstellen


  DATA:
    lr_ixml     TYPE REF TO if_ixml,
    lr_doc      TYPE REF TO if_ixml_document,
    lr_element1 TYPE REF TO if_ixml_element,
    lr_sf       TYPE REF TO if_ixml_stream_factory,
    lr_ostream  TYPE REF TO if_ixml_ostream,
    lv_xml      TYPE string,
    lr_renderer TYPE REF TO if_ixml_renderer.


  lr_ixml = cl_ixml=>create( ).
  lr_doc = lr_ixml->create_document( ).


  """"""""""""""""""""""""""""""
  " XML Daten erzeugen


  lr_element1 = lr_doc->create_element( name = 'root' ).
  lr_doc->append_child( lr_element1 ).
  lv_node_data->set_name(  'DATA' ).
  lr_element1->append_child( lv_node_data ).



  """""""""""""""""""""""""""""""""""
  " Rendern


  lr_ixml = cl_ixml=>create( ).
  lr_sf = lr_ixml->create_stream_factory( ).
*  lr_ostream = lr_sf->create_ostream_xstring( lv_out ).
  lr_ostream = lr_sf->create_ostream_cstring( lv_xml  ).
  lr_renderer = lr_ixml->create_renderer(
  document = lr_doc
  ostream = lr_ostream ).
  lr_renderer->render( ).


  """"""""""""""""""""""""""""
  " Ausgabe

*  lv_xml = lcl_help=>conv_xstring_to_string( lv_out  ).
  lcl_help=>popup_xml( lv_xml ).
