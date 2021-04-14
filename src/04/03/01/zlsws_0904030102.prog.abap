REPORT ZLSWS_0904030102.

* Objekt-ID des Mime-Objekts
DATA: lv_object_id TYPE char32 VALUE '005056BD12831EEBA7A39E7F5E1B16C8'.

DATA: lv_desc TYPE skwf_desc.
DATA: lv_docname TYPE skwf_urlp.
DATA: lv_filename TYPE string.
DATA: lv_filesize TYPE i.
DATA: lv_mimetype TYPE mr_mimtype.
DATA: lv_langu TYPE sy-langu.

DATA: it_bin_data TYPE sdokcntbins. " RAW1022

DATA(lv_io) = VALUE skwf_io( objtype = 'L' " Unbestimmt (= alle), F Verzeichnis, L Loio, P Phio, R Relation
                             class = 'M_IMAGE_L'
                             objid = lv_object_id ).

* Sprachvorgabe
lv_langu = 'E'.

* MIME-Objekt laden
cl_wb_mime_repository=>load_mime( EXPORTING
                                    io              = lv_io
                                  IMPORTING
                                    docname         = lv_docname
                                    description     = lv_desc
                                    filename        = lv_filename
                                    filesize        = lv_filesize
                                    bin_data        = it_bin_data
                                    mimetype        = lv_mimetype
                                  CHANGING
                                    language        = lv_langu ).

WRITE: / lv_docname.
WRITE: / lv_desc.
WRITE: / lv_filename.
WRITE: / lv_filesize.
WRITE: / lv_mimetype.
WRITE: / lv_langu.

DATA: lv_xstr_line TYPE xstring.
DATA: lv_xstr_result TYPE xstring.

* RAW (binary) -> xstring
CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
  EXPORTING
    input_length = lv_filesize
  IMPORTING
    buffer       = lv_xstr_result
  TABLES
    binary_tab   = it_bin_data
  EXCEPTIONS
    failed       = 1
    OTHERS       = 2.

IF sy-subrc NE 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
