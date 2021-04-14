REPORT ZLSWS_0904030101.

* Dateiname der Bilddatei zum hochladen
PARAMETERS: p_fname TYPE file_table-filename OBLIGATORY.
* Speicherpfad im MIME-Repository, muss vorhanden sein, andernfalls mit o_mime_rep->create_folder( ) erzeugen
PARAMETERS: p_mpath TYPE string DEFAULT '/SAP/PUBLIC/Test123.jpg' OBLIGATORY.

* wenn die F4-Hilfe für den Dateinamen aufgerufen wird
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fname.

  DATA: lv_rc TYPE i.
  DATA: it_files TYPE filetable.
  DATA: lv_action TYPE i.

* File-Tabelle leeren, da hier noch alte Einträge von vorherigen Aufrufen drin stehen können
  CLEAR it_files.

* FileOpen-Dialog aufrufen
  TRY.
      cl_gui_frontend_services=>file_open_dialog( EXPORTING
                                                    file_filter = |jpg (*.jpg)\|*.jpg\|{ cl_gui_frontend_services=>filetype_all }|
                                                  CHANGING
                                                    file_table  = it_files
                                                    rc          = lv_rc
                                                    user_action = lv_action ).

      IF lv_action = cl_gui_frontend_services=>action_ok.
* wenn Datei ausgewählt wurde
        IF lines( it_files ) > 0.
* ersten Tabelleneintrag lesen
          p_fname = it_files[ 1 ]-filename.
        ENDIF.
      ENDIF.

    CATCH cx_root INTO DATA(e_text).
      MESSAGE e_text->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
  ENDTRY.

START-OF-SELECTION.
  DATA: lv_filesize TYPE i.
  DATA: it_bin_data TYPE STANDARD TABLE OF raw255.

* Bild auf Appl. Server hochladen (binary)
  cl_gui_frontend_services=>gui_upload( EXPORTING
                                          filename = |{ p_fname }|
                                          filetype = 'BIN'
                                        IMPORTING
                                          filelength = lv_filesize
                                        CHANGING
                                          data_tab = it_bin_data ).

  DATA: lv_xstr TYPE xstring.

* RAW (binary) nach xstring
  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = lv_filesize
    IMPORTING
      buffer       = lv_xstr
    TABLES
      binary_tab   = it_bin_data
    EXCEPTIONS
      failed       = 1
      OTHERS       = 2.

* MIME-API holen
  DATA(o_mime_rep) = cl_mime_repository_api=>get_api( ).

* Bild im MIME-Repository speichern
* Objektkatalogeintrag wird erstellt, evtl. bestehende Dateien werden überschrieben
  o_mime_rep->put( i_url = p_mpath
                   i_content = lv_xstr
                   i_check_authority = abap_false ).
