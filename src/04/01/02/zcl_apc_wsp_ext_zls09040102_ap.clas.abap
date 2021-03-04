class zcl_apc_wsp_ext_zls09040102_ap definition
  public
  inheriting from cl_apc_wsp_ext_stateless_base
  final
  create public .

  public section.

    methods if_apc_wsp_extension~on_start
        redefinition .
    methods if_apc_wsp_extension~on_message
        redefinition .
  protected section.
  private section.
ENDCLASS.



CLASS ZCL_APC_WSP_EXT_ZLS09040102_AP IMPLEMENTATION.


  method if_apc_wsp_extension~on_message.



  endmethod.


  method if_apc_wsp_extension~on_start.

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
                  i_application_id =  'ZLS_AMC_01'
                  i_channel_id     = '/test' ).

      catch cx_apc_error into data(exc).
        message exc->get_text( ) type 'X'.
    endtry.




  endmethod.
ENDCLASS.
