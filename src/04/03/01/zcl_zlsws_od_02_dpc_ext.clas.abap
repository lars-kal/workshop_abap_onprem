class ZCL_ZLSWS_OD_02_DPC_EXT definition
  public
  inheriting from ZCL_ZLSWS_OD_02_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.

  methods FILESET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZLSWS_OD_02_DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM.
DATA: lv_file        TYPE zcl_zlsws_od_02_mpc=>ts_file.
  DATA: lv_stream      TYPE ty_s_media_resource.

* Welche Entität?
  CASE io_tech_request_context->get_entity_type_name( ).
    WHEN zcl_zlsws_od_02_mpc=>gc_file.
* Schlüssel ("FILEKEY") ermitteln
      io_tech_request_context->get_converted_keys( IMPORTING es_key_values = lv_file ).

* gewünschte Binärdaten anhand des Schlüssels aus SAP lesen
      DATA: it_bin_data TYPE STANDARD TABLE OF raw255.

  DATA: lv_filename TYPE skwf_filnm.

  new lcl_help( )->load_image(
    IMPORTING
      filesize = data(lv_size)
    filename = lv_filename
    result = lv_stream-value
    mimetype = lv_stream-mime_type
     ).
*      it_bin_data = ...

* Dateinamen ermitteln


*      lv_filename = ...

* Für die Umwandlung die Dateigröße der Binärdaten berechnen
*      DATA(lv_size) = lines( it_bin_data ).
*      DATA: lv_line LIKE LINE OF it_bin_data.
*      DATA(lv_length) = 0.
** für Unicode-Kompatibilität IN BYTE MODE
*      DESCRIBE FIELD lv_line LENGTH lv_length IN BYTE MODE.
*      lv_size = lv_size * lv_length.
*
** Binärdaten in xstring für die Rückgabe konvertieren
*      CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
*        EXPORTING
*          input_length = lv_size
*        IMPORTING
*          buffer       = lv_stream-value
*        TABLES
*          binary_tab   = it_bin_data
*        EXCEPTIONS
*          failed       = 1
*          OTHERS       = 2.

*      IF sy-subrc = 0.
* MIME-Typen der Datei ermitteln und an das Frontend übergeben
        DATA: lv_mimetype TYPE skwf_mime.

* aus Dateinamen den MIME-Typen ermitteln
        CALL FUNCTION 'SKWF_MIMETYPE_OF_FILE_GET'
          EXPORTING
            filename = lv_filename
          IMPORTING
            mimetype = lv_mimetype.

        lv_stream-mime_type = lv_mimetype.
*
** HTTP-Header-Infos setzen (Dateiname usw.)
        DATA(lv_lheader) = VALUE ihttpnvp( name  = 'Content-Disposition'
                                           value = |inline; filename="{ escape( val = lv_filename format = cl_abap_format=>e_url ) }";| ). " Datei im Tab inline (Plugin) öffnen
*                                           value = |outline; filename="{ escape( val = lv_filename format = cl_abap_format=>e_url ) }";| ). " Datei zum direkten Herunterladen / Öffnen anbieten

        set_header( is_header = lv_lheader ).

* alle Daten zum Frontend schicken
        me->copy_data_to_ref( EXPORTING is_data = lv_stream
                              CHANGING cr_data  = er_stream ).
*      ENDIF.

    WHEN OTHERS.
* andere Entitäten standardmäßig behandeln
      super->/iwbep/if_mgw_appl_srv_runtime~get_stream(
        EXPORTING
          iv_entity_name          = iv_entity_name
          iv_entity_set_name      = iv_entity_set_name
          iv_source_name          = iv_source_name
          it_key_tab              = it_key_tab
          it_navigation_path      = it_navigation_path
          io_tech_request_context = io_tech_request_context
          IMPORTING
            er_stream             = er_stream
            es_response_context   = es_response_context ).
  ENDCASE.
ENDMETHOD.


  method FILESET_GET_ENTITY.

er_entity-ident = '001'.




  endmethod.
ENDCLASS.
