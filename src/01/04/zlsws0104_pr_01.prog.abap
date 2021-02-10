report zlsws0104_pr_01.

DATA:
  ixml     TYPE REF TO if_ixml,
  factory  TYPE REF TO if_ixml_stream_factory,
  parser   TYPE REF TO if_ixml_parser,
  istream  TYPE REF TO if_ixml_istream,
  document TYPE REF TO if_ixml_document,
  xmldata  TYPE string.

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
'</data>'
      INTO gv_xml_data.



  """"""""""""""""""""""""""""
  " Debugger Funktionen

  BREAK-POINT.


  """"""""""""""""""""""""""""
  " XML Ausgabe

  DATA gv_xml_xstring TYPE xstring.

  "String nach xstring
  CALL FUNCTION 'J_3RT_CONV_STRING_TO_XSTRING'
    EXPORTING
      im_string  = gv_xml_data
    IMPORTING
      ex_xstring = gv_xml_xstring.

  "XML Daten anzeigen
  CALL FUNCTION 'DISPLAY_XML_STRING'
    EXPORTING
      xml_string      = gv_xml_xstring
    EXCEPTIONS
      no_xml_document = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    "error handling here
  ENDIF.
