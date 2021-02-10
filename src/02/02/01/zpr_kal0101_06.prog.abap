REPORT ZPR_KAL0101_06.

TRY.

    cl_salv_gui_table_ida=>create_for_cds_view( CONV #( 'ZCDS_LS_WS_13' )
         )->fullscreen(
         )->display( ).

  CATCH cx_root INTO DATA(e_txt).
    WRITE: / e_txt->get_text( ).
ENDTRY.
