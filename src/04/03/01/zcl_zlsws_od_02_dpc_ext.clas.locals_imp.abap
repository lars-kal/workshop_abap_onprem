class lcl_help definition.

  public section.

    methods load_image
      exporting
          value(filesize) type string
          value(filename) type skwf_filnm
          value(mimetype) type string
           VALUE(result) type xstring.

endclass.

class lcl_help implementation.

  method load_image.


* Objekt-id des Mime-Objekts
data: lv_object_id type char32 value '005056BD12831EEBA7A39E7F5E1B16C8'.

  data: lv_desc type skwf_desc.
  data: lv_docname type skwf_urlp.
  data: lv_filename type string.
  data: lv_filesize type i.
  data: lv_mimetype type mr_mimtype.
  data: lv_langu type sy-langu.

  data: it_bin_data type sdokcntbins.                       " RAW1022

  data(lv_io) = value skwf_io( objtype = 'L' " Unbestimmt (= alle), F Verzeichnis, L Loio, P Phio, R Relation
                               class = 'M_IMAGE_L'
                               objid = lv_object_id ).

* Sprachvorgabe
  lv_langu = 'E'.

* MIME-Objekt laden
  cl_wb_mime_repository=>load_mime( exporting
                                      io              = lv_io
                                    importing
                                      docname         = lv_docname
                                      description     = lv_desc
                                      filename        = lv_filename
                                      filesize        = lv_filesize
                                      bin_data        = it_bin_data
                                      mimetype        = lv_mimetype
                                    changing
                                      language        = lv_langu ).

filesize = lv_filesize.
filename = lv_filename.
  mimetype = lv_mimetype.

  write: / lv_docname.
  write: / lv_desc.
  write: / lv_filename.
  write: / lv_filesize.
  write: / lv_mimetype.
  write: / lv_langu.

  data: lv_xstr_line type xstring.
  data: lv_xstr_result type xstring.

* RAW (binary) -> xstring
  call function 'SCMS_BINARY_TO_XSTRING'
    exporting
      input_length = lv_filesize
    importing
      buffer       = lv_xstr_result
    tables
      binary_tab   = it_bin_data
    exceptions
      failed       = 1
      others       = 2.

  if sy-subrc ne 0.
    message id sy-msgid type sy-msgty number sy-msgno with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

result = lv_xstr_result.
endmethod.

endclass.
