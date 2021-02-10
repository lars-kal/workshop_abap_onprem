REPORT ZLSWS0102_PR_01.
*
*class lcl_app definition.
*
*  public section.
*
*    class-methods:
*      main.
*  protected section.
*
*    class-methods example_get_data.
*
*endclass.
*
*class lcl_app implementation.
*
*  method main.
*
*
*    data lo_help type ref to zcl_utility_abap_2011. " abap_test.
*    data lx_root type ref to cx_root.
*    lo_help = new #( ).
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Nachrichten Übergeben
*
*    break-point.
*
*
*    try. "normale Exception erzeugen
*
*        lo_help->x_raise('ERROR').
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    try. "t100 tEXTE
*
*        data ls_bapi type bapiret2.
*        data: sy            type syst,
*              lv_error_any  type xfeld,
*              lv_error_any2 type xfeld,
*              lv_error_any3 type xfeld,
*              lv_error_any4 type xfeld,
*              lv_error_any5 type xfeld.
*
*        "DE /ASU/GENERAL    004 Fehler beim Lesen der Datei &1
*        ls_bapi-id = '/ASU/GENERAL'.
*        ls_bapi-number = 004.
*        ls_bapi-message_v1 = 'DATEINAME'.
*
*        lo_help->x_raise( ls_bapi ).
*
*      catch cx_root into lx_root.
*        data(lv_dummy) = lx_root->get_text(  ).
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    try.  "Debugging T100
*
*        lo_help->x_raise( ls_bapi ).
*
*
*      catch cx_root into lx_root.
**        lo_help->gui( lx_root ).
*
*        lv_dummy = lx_root->get_text(  ).
*        "error handling
*
*    endtry.
*
*
*
*    try.  "Debugging Exception
*
*        lx_root = lo_help->x_raise( ls_bapi ).
*        raise exception lx_root.
*
*      catch cx_root into lx_root.
**        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*
*    try. "Log übergeben
*
*        data lt_bapi type bapiret2_tab.
*        insert ls_bapi into table lt_bapi.
*        insert ls_bapi into table lt_bapi.
*        insert ls_bapi into table lt_bapi.
*
*        "DE /ASU/GENERAL    004 Fehler beim Lesen der Datei &1
*        lo_help->x_raise( i_any = '004(/ASU/GENERAL)' i_add_t100 = lt_bapi ).
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    try. "stc log Objekt
*
*        data li_log type ref to /stc/if_msg_base.
*
*        create object li_log
*          type /stc/cl_msg_base_46c.
*
**        data(li_log) = cast /stc/if_msg_base( new /stc/cl_msg_base_46c(  ) ).
*
*        li_log->add(
*            iv_msgty = 'E'
*            iv_msgno = 004
*            iv_msgid = '/ASU/GENERAL'
*        ).
*
*        li_log->add(
*            iv_msgty = 'E'
*            iv_msgno = 004
*            iv_msgid = '/ASU/GENERAL'
*        ).
*
*        li_log->add(
*            iv_msgty = 'E'
*            iv_msgno = 004
*            iv_msgid = '/ASU/GENERAL'
*        ).
*
*
*        lo_help->x_raise( i_any = 'Fehlerfall' i_add_t100 = li_log ).
*
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    try. "Übergabe nach Fuba
*
*        data lt_return type standard table of bapiret2.
*        data ls_head type bapi_0035_header.
*
*        call function 'BAPI_0035_CREATE'
*          exporting
*            header_data = ls_head    " Header data for grant master creation
*          tables
*            return      = lt_return.    " Return Parameter
*        if abap_true = lo_help->check( t100_error = 'X' i_any = lt_return ).
*
*          lo_help->x_raise( i_any      = 'Fehler beim Erzeugen der Stammdaten'
*                            i_add_t100 = lt_return ).
*
*        endif.
*
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Zusatzdaten zu Exception hnizufügen
*
*
*    try. "JSON Daten übergeben
*
*        data ls_vbak type vbak.
*        data lx_root_vbak type ref to cx_root.
*
*        select single *
*           from vbak
*           into corresponding fields of ls_vbak.
*
*        lo_help->x_raise( i_any = 'Flugdaten können nicht weiterverarbeitet werden'
*                         i_ser_data = lo_help->get( json = 'X' i_any = ls_vbak )
*                        ).
*
*
*      catch cx_root into lx_root_vbak.
*        lo_help->gui( lx_root_vbak ).
*    endtry.
*
*
*
*    try. "Values übergeben
*
*        data lt_spfli type standard table of spfli.
*        data lv_airpfrom type spfli-airpfrom value 'BER'.
*        data lv_airpto type spfli-airpto value 'TXT'.
*
*        select  *
*        from spfli
*        into table lt_spfli
*        where airpfrom = lv_airpfrom
*        and   airpto   = lv_airpto.
*        if sy-subrc <> 0.
*          lo_help->x_raise( i_any = 'Flugdaten können nicht weiterverarbeitet werden'
*                          i_ser_value = lo_help->get( json_deep = 'X'
*                                                       i_any  = lv_airpfrom
*                                                       i_any2 = lv_airpto )
*                               ).
*        endif.
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Exceptions aufeinander abbilden
*
**    data lx_error type ref to cx_root.
*    data: lt_header type standard table of glex_thead.
*
*    break-point.
*
*    try. "Vorgänger
*
*        lx_root = lo_help->x_raise( 'Das ist ein Vorgängerfehlertext' ).
*
*        lo_help->x_raise( i_any = 'Das ist eine Kopfinformation'
*                          i_prev = lx_root ).
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*    try. "weitere Ebene
*
*        lo_help->x_raise( lx_root ).
*
*
*      catch cx_root into lx_root.
*        try.
*            lo_help->x_raise( i_any  = 'ACHTUNG IRGENDWAS HAT NICHT FUNKTIONIERT!!!!'
*                            i_prev = lx_root ).
*
*          catch cx_root into lx_root.
*            lo_help->gui( lx_root ).
*        endtry.
*    endtry.
*
*
*
*    try. "komplexe Exception
*
*        clear lt_return.
*
*        call function 'BAPI_0035_CREATE'
*          exporting
*            header_data = ls_head    " Header data for grant master creation
*          tables
*            return      = lt_return.    " Return Parameter
*        if abap_true = lo_help->check( t100_error = 'X' i_any = lt_return ).
*
*          lo_help->x_raise( i_any      = 'Fehler beim Erzeugen der Stammdaten'
*                            i_prev     = lo_help->x_raise(  i_any = 'Fehler bei Aufruf von BAPI_0035_CREATE'
*                                                            i_add_t100 = lt_return )
*                            ).
*
*        endif.
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*
*        try.
*
*            lo_help->x_raise( i_any = 'HTTP Create Request Failed'
*                              i_ser_data = lo_help->get( json = 'X' i_any = ls_vbak )
*                              i_prev = lx_root
*                              ).
*
*          catch cx_root into lx_root.
*            lo_help->gui( lx_root ).
*        endtry.
*    endtry.
*
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Infos auslesen
*
*    break-point.
*
*    lo_help->x_info(
*      exporting
*        ix_root      = lx_root
*      importing
*        et_add_t100  = data(lt_t100_head)
*        ev_guid      = data(lv_guid_head)
*        et_source    = data(lt_soure_head)
*        et_callstack = data(lt_callstack)
*        ev_val_print = data(lv_val_print_head)
*        es_bapiret   = data(ls_bapi_head)
*        e_add_serial = data(ls_serial_head)
*    ).
*
*    if lx_root->previous is bound.
*
*      lo_help->x_info(
*       exporting
*         ix_root      = lx_root->previous
*       importing
*         et_add_t100  = data(lt_t100_child)
*         ev_guid      = data(lv_guid_child)
*         et_source    = data(lt_soure_child)
*         et_callstack = data(lt_callstack_child)
*         ev_val_print = data(lv_val_print_child)
*         es_bapiret   = data(ls_bapi_child)
*         e_add_serial = data(ls_serial_child)
*     ).
*
*    endif.
*
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Andere Sachen machen
*
*    break-point.
*
*    "Exception abspeichern mit guid
*    lo_help->x_info(
*        exporting
*          ix_root      = lx_root
*        importing
*          ev_guid = data(lv_guid)
*      ).
*
*    lo_help->db_update(
*        all        = 'X'
*        i_key1    = lv_guid
*        commit    = abap_true
*        i_any     = lx_root
*    ).
*
*    clear lx_root.
*
*    lo_help->db_read(
*      exporting
*        all         = 'X'
*        i_key1      = lv_guid
*      importing
*        e_result    = lx_root
*    ).
*
*    lo_help->gui( lx_root ).
*
*    lo_help->x_info(
*      exporting
*        ix_root      = lx_root
*      importing
*        e_add_serial = data(lv_serial)
*    ).
*
*
*    clear ls_vbak.
*
*
*    lo_help->trans(
*      exporting
*        json_2              = 'X'
*        val               = lv_serial
*      importing
*        result           = ls_vbak
*    ).
*
*
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Kontextabhängige Exceptions
*
*    break-point.
*
*    try.
*
*        data lt_vbap type standard table of vbap.
*        data lv_posnr type posnr value '111'.
*        data lv_vbeln type vbeln value '333'.
*
*        select  *               ##SUBRC_OK
*        from vbap
*        into table lt_vbap
*        where vbeln = lv_vbeln
*        and   posnr = lv_posnr.
*
*        lo_help->x_raise_check(
*                     select = 'X'
*                     val = lv_vbeln i_val2 = lv_posnr ).
*
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    try.
*
*        clear lt_return.
*
*        call function 'BAPI_0035_CREATE' ##FM_SUBRC_OK
*          exporting
*            header_data = ls_head
*          tables
*            return      = lt_return.
*
*        lo_help->x_raise_check( function = 'X' i_check1 = lt_return ).
*
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    try.
*
*        data lt_log  type standard table of prott.
*        data ls_vbkok type vbkok.
**        data lv_vbeln type vbeln.
*
*        call function 'WS_DELIVERY_UPDATE_2'  ##FM_SUBRC_OK
*          exporting
*            vbkok_wa                  = ls_vbkok
*            delivery                  = lv_vbeln
*          importing
*            ef_error_any              = lv_error_any   " Checkbox
*            ef_error_in_item_deletion = lv_error_any   " Checkbox
*            ef_error_in_pod_update    = lv_error_any     " Checkbox
*            ef_error_in_interface     = lv_error_any    " Checkbox
*            ef_error_in_goods_issue   = lv_error_any     " Checkbox
*          tables
*            prot                      = lt_log  " Log
*          exceptions
*            error_message             = 1
*            others                    = 2.
*        lo_help->x_raise_check( function = 'X'
*                                val = lt_log
*                                i_flag   = lv_error_any ).
*
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    try.
*
*        clear lt_spfli.
*        lo_help->x_raise_check( not_initial = 'X' val = lt_spfli ).
*
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    try.
*
*        li_log = cast /stc/if_msg_base( new /stc/cl_msg_base_46c(  ) ).
*
*        li_log->add(
*            iv_msgty = 'E'
*            iv_msgno = 004
*            iv_msgid = '/ASU/GENERAL'
*        ).
*
*        lo_help->x_raise_check(  msg_not_error = 'X' i_check1 = li_log ).
*
*
*      catch cx_root into lx_root.
*        lo_help->gui( lx_root ).
*    endtry.
*
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Ablaufsteuerung
*
*    break-point.
*
*
*    try. "retry
*
*        data lv_tanum type tanum.
*
*        if lv_tanum is initial.
*          lo_help->x_raise( 'Transportauftrag ist nicht gültig' ).
*        endif.
*
*
*        data(lv_dummy3) = 'jetzt gehts nach retry'.
*
*
*      catch cx_root into lx_root.
*
*        if lv_tanum is initial.
*          lv_tanum = '123'.
*          retry. "nochmal
*        else.
*          lo_help->gui( lx_root ).
*        endif.
*
*    endtry.
*
*
*
*    try. "resume
*
*        clear lv_tanum.
*
*        if lv_tanum is initial.
*          raise resumable exception type cx_t100_msg.
*
*          data(lv_dummy5) = 'weiter gehts'.
*        endif.
*
*      catch before unwind cx_t100_msg into data(lx_msg).
*
*        if lv_tanum is initial.
*          "Ist egal, weiter gehts
*          resume.
*        else.
*          lo_help->gui( lx_msg ).
*        endif.
*
*    endtry.
*
*
*
*    try. "Arbeiten mit Error Codes
*
*        constants:
*          begin of cs_error_code,
*            input_initial  type string value '01',
*            no_data_found  type string value '02',
*            wrong_language type string value '03',
*          end of cs_error_code.
*
*        lo_help->x_raise( i_code = cs_error_code-no_data_found ).
*
*
*      catch cx_root into lx_root.
*        break-point. "Attribut zeigen
*
*        case lo_help->get( cx_code = 'X' val = lx_root ).
*
*          when cs_error_code-input_initial.
*            "do something
*
*          when cs_error_code-no_data_found.
**            lo_help->x_raise( i_any = 'Kein Ergebnis für Eingabe' i_prev = lx_root ).
*
*          when others.
**            lo_help->x_raise( i_any = 'Ein unbekannter Fehler ist aufgetreten' i_prev = lx_root ).
*        endcase.
*
*    endtry.
*
*
*
*    try. "retry / "resume "Error codes
*
*
*
*
*        example_get_data(  ).
*
*
*
*      catch before unwind cx_root into lx_root.
*        break-point.
*
*        case lo_help->get( cx_code = 'X' val = lx_root ).
*
*          when cs_error_code-no_data_found.
*            "neuer Versuch mit anderem Input
*            retry.
*
*          when cs_error_code-wrong_language.
*            "Ist egal, besser falsche Sprache als gar kein Text
*            resume.
*
*          when others.
*            "kA was schief gelaufen ist, propagieren Exception, Aufrufer muss sich drum kümmern
*            lo_help->x_raise( val = 'Ein unbekannter Fehler ist aufgetreten' i_prev = lx_root ).
*        endcase.
*
*    endtry.
*
*
*  endmethod.
*
*
*  method example_get_data.
*
*  endmethod.
*
*endclass.
*
*start-of-selection.
*  lcl_app=>main(  ).
