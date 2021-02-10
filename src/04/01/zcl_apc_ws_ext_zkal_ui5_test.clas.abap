class zcl_apc_ws_ext_zkal_ui5_test definition
  public
  inheriting from cl_apc_ws_ext_stateless_base
  final
  create public .

  public section.

    methods if_apc_ws_extension~on_message
        redefinition .
    methods if_apc_ws_extension~on_start
        redefinition .
  protected section.
  private section.
endclass.



class zcl_apc_ws_ext_zkal_ui5_test implementation.


  method if_apc_ws_extension~on_message.


    try.

        data(lv_msg) = i_message->get_text( ).

        cast if_amc_message_producer_text(

              cl_amc_channel_manager=>create_message_producer(
                i_application_id = 'ZKAL_MC_UI5_TEST' "‘ZAMC_TEST
                i_channel_id     = '/ping' )

                )->send( i_message =  lv_msg ) ##NO_TEXT.

      catch cx_amc_error cx_apc_error into data(lref_exc).

        data(lv_error) =  lref_exc->get_text( ).
        " TYPE 'X'.

    endtry.

  endmethod.


  method if_apc_ws_extension~on_start.

    data: lt_form_fields type tihttpnvp.
    data: lt_head_fields type tihttpnvp.
    data: lt_cookie      type tihttpcki.

    try.

        data(lo_req) = i_context->get_initial_request( ).
        lo_req->get_form_fields(
          changing
            c_fields             = lt_form_fields ).
        lo_req->get_header_fields(
          changing
            c_fields     = lt_head_fields ).
        lo_req->get_cookies(
          changing
            c_cookies    = lt_cookie
        ).
*        CATCH cx_apc_error.    "

        i_context->get_binding_manager( )->bind_amc_message_consumer(
                  i_application_id =  'ZKAL_MC_UI5_TEST'
                  i_channel_id     = '/ping' ).

      catch cx_apc_error into data(exc).
        message exc->get_text( ) type 'X'.
    endtry.

  endmethod.
endclass.
