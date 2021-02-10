report zlsws0104_pr_03.

INCLUDE zlsws010104_incl_01.

START-OF-SELECTION.

  DATA:
    gv_xml_data TYPE string.


START-OF-SELECTION.

  """"""""""""""""""""""""""""
  " XML Daten erzeugen

  CONCATENATE
'<data>'
  '<Customer id="4711">'
  '<Name>'
  '<Last>Smith</Last>'
  '<First>John</First>'
  '</Name>'
  '<Address>'
  '<Street>123, Main St.</Street>'
  '<City>Exemellville</City>'
  '<ZIP>52062</ZIP>'
  '</Address>'
  '</Customer>'
  '<info>'
  '</info>'
'</data>'
      INTO gv_xml_data.


  DATA: lo_ixml_factory        TYPE REF TO if_ixml,
        lo_ixml_stream_factory TYPE REF TO if_ixml_stream_factory,
        lo_ixml_istream        TYPE REF TO if_ixml_istream,
        lo_ixml_document       TYPE REF TO if_ixml_document,
        lo_ixml_parser         TYPE REF TO if_ixml_parser,
        lv_str                 TYPE string,
        lv_node                TYPE REF TO if_ixml_node,
        lv_child               TYPE REF TO if_ixml_node,
        lv_iterator            TYPE REF TO if_ixml_node_iterator,
        lo_child               TYPE REF TO if_ixml_node_list,
        lo_iterator_children   TYPE REF TO if_ixml_node_iterator.

  BREAK-POINT.


  """"""""""""""""""""""""""""""""""""""""""""""""
  " XML Dokument erstellen


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


  """"""""""""""""""""""""""""""""""""""""""""""""
  " Bearbeiten mit Iterator

  lv_iterator  = lo_ixml_document->create_iterator( 1 ).

  lv_node = lv_iterator->get_next( ).

  WHILE NOT lv_node IS INITIAL.

    lv_str = lv_node->get_name( ).
    WRITE: / lv_str.

    IF lv_str = 'data'.
      lv_node->set_name( 'date_new' ).
      lo_child = lv_node->get_children( ).

      lo_iterator_children = lo_child->create_iterator( ).
      lv_child = lo_iterator_children->get_next(  ).

      WHILE NOT lv_child IS INITIAL.
        lv_str = lv_child->get_name( ).
        WRITE: / lv_str.

        lv_child = lo_iterator_children->get_next(  ).
      ENDWHILE.

    ENDIF.

    lv_node = lv_iterator->get_next( ).
  ENDWHILE.



  """"""""""""""""""""""""""""""""""""""""""""""""
  " Bearbeiten mit Filter

  DATA:
         lr_filter TYPE REF TO if_ixml_node_filter.



  lv_iterator = lo_ixml_document->create_iterator_filtered( lr_filter ).

  lv_node = lv_iterator->get_next( ).

  WHILE NOT lv_node IS INITIAL.

    lv_str = lv_node->get_name( ).
    WRITE: / lv_str.

    IF lv_str = 'date_new'.

      lo_child = lv_node->get_children( ).

      lr_filter = lo_ixml_document->create_filter_name_ns(
      name ='info' ).

      lo_iterator_children = lo_child->create_iterator_filtered( lr_filter ).
      lv_child = lo_iterator_children->get_next(  ).

      lv_str = lv_child->get_name( ).
      WRITE: / lv_str.


    ENDIF.

    lv_node = lv_iterator->get_next( ).
  ENDWHILE.


  """"""""""""""""""""""""""""""
  " Rendern Ausgabe

  DATA:
    lr_ixml     TYPE REF TO if_ixml,
    lr_sf       TYPE REF TO if_ixml_stream_factory,
    lr_ostream  TYPE REF TO if_ixml_ostream,
    lv_xml      TYPE string,
    lr_renderer TYPE REF TO if_ixml_renderer.

  lr_ixml = cl_ixml=>create( ).
  lr_sf = lr_ixml->create_stream_factory( ).
*  lr_ostream = lr_sf->create_ostream_xstring( lv_out ).
  lr_ostream = lr_sf->create_ostream_cstring( lv_xml  ).
  lr_renderer = lr_ixml->create_renderer(
  document = lo_ixml_document
  ostream = lr_ostream ).
  lr_renderer->render( ).


  """"""""""""""""""""""""""""
  " Ausgabe

  lcl_help=>popup_xml( lv_xml ).
