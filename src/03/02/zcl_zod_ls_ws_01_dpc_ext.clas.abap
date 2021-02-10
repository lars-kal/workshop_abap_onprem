class ZCL_ZOD_LS_WS_01_DPC_EXT definition
  public
  inheriting from ZCL_ZOD_LS_WS_01_DPC
  create public .

public section.
protected section.

  methods SPFLISET_GET_ENTITY
    redefinition .
  methods SPFLISET_GET_ENTITYSET
    redefinition .
  methods SPFLISET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZOD_LS_WS_01_DPC_EXT IMPLEMENTATION.


  method spfliset_get_entity.


    data: ls_entity like er_entity.

    io_tech_request_context->get_converted_keys(
    importing
       es_key_values = ls_entity ).

    select single *
      from spfli
      into corresponding fields of er_entity
      where
        carrid = ls_entity-carrid and
        connid = ls_entity-connid.




    if sy-subrc <> 0.

      raise exception type /iwbep/cx_mgw_busi_exception
        exporting
*         textid  =
*         previous               =
*         message_container      =
*         http_status_code       = GCS_HTTP_STATUS_CODES-BAD_REQUEST
*         http_header_parameters =
*         sap_note_id            =
*         entity_type            =
          message = 'keine Einträge gefunden'
*         message_unlimited      =
*         filter_param           =
        .

    endif.

  endmethod.


  method spfliset_get_entityset.

    select from spfli
      fields
      *
      into table @data(lt_spfli)
      up to 10 rows.

    et_entityset = CORRESPONDING #( lt_spfli ).

  endmethod.


  method spfliset_update_entity.


    data: ls_entity type spfli.

    data lv_test type string.

    io_data_provider->read_entry_data( importing es_data = ls_entity ).

    update spfli
      set   cityfrom = ls_entity-cityfrom
      where
        connid    = ls_entity-connid and
        carrid    = ls_entity-carrid.

    if sy-subrc = 0.
      commit work and wait.
    endif.


    if sy-subrc <> 0.

*mo_context->get_message_container( )->add_messages_from_bapi(
*it_bapi_messages = lt_return iv_determine_leading_msg = /iwbep/if_message_container=>
*gcs_leading_msg_search_option- first ).

    endif.

  endmethod.
ENDCLASS.
