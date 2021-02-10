


CLASS lcl_help DEFINITION.

  PUBLIC SECTION.

    class-METHODS:
      popup_xml
        IMPORTING
          iv_xml TYPE any,


     conv_xstring_to_string
        IMPORTING
          iv_input         TYPE xstring
        RETURNING
          VALUE(rv_result) TYPE string
        RAISING
          cx_t100_msg,

    conv_string_to_xstring
        IMPORTING
          iv_input         TYPE string
        RETURNING
          VALUE(rv_result) TYPE xstring
        RAISING
          cx_t100_msg.


ENDCLASS.


CLASS lcl_help IMPLEMENTATION.

  METHOD popup_xml.

    DATA:
            lv_xml TYPE string.

    lv_xml = iv_xml.

    DATA lv_xml_xstring TYPE xstring.

  lv_xml_xstring = conv_string_to_xstring( lv_xml ).

    "XML Daten anzeigen
    CALL FUNCTION 'DISPLAY_XML_STRING'
      EXPORTING
        xml_string      = lv_xml_xstring
      EXCEPTIONS
        no_xml_document = 1
        OTHERS          = 2.


    """" geht nur bei neuen Systemen
*    cl_abap_browser=>show_xml(
*        EXPORTING xml_string = lv_xml
*            size       = cl_abap_browser=>xlarge ).

  ENDMETHOD.                    "popup_xml

  METHOD conv_string_to_xstring.

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = iv_input
*       MIMETYPE       = ' '
*       ENCODING       =
      IMPORTING
        buffer = rv_result
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
*    mo_help->so_check_a_raise->after_function(  is_sy = sy ).

  ENDMETHOD.

  METHOD conv_xstring_to_string.

*     Xstring -> String

    DATA: lv_length TYPE i,
          lt_binary TYPE STANDARD TABLE OF x255.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = iv_input
      IMPORTING
        output_length = lv_length
      TABLES
        binary_tab    = lt_binary.

    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
      EXPORTING
        input_length = lv_length
      IMPORTING
        text_buffer  = rv_result
      TABLES
        binary_tab   = lt_binary
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
*    mo_help->so_check_a_raise->after_function(  is_sy = sy ).


  ENDMETHOD.

  endclass.
