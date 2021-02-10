*&---------------------------------------------------------------------*
*& Report  ZKAL_TEST_UI5_PUSH_CHANNEL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zkal_test_ui5_push_channel.

PARAMETER:p_bar1 TYPE string,

                      p_bar2 TYPE string,

                      p_bar3 TYPE string.

DATA: lv_text TYPE string.

CLASS lcl_demo DEFINITION.

   PUBLIC SECTION.

     CLASS-METHODS main.

ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.

   METHOD main.

     TRY.

         CONCATENATE p_bar1 p_bar2 p_bar3 INTO lv_text SEPARATED BY '~'.

         CAST if_amc_message_producer_text(

                cl_amc_channel_manager=>create_message_producer(
                  i_application_id = 'ZKAL_MC_UI5_TEST' "ZAMC_TEST’
                  i_channel_id     = '/ping' )

           )->send( i_message = lv_text ) . "|Static text| ).


    message 'Event von Server gefeuert!' type 'I'.

       CATCH cx_amc_error INTO DATA(lref_text_exc).

         cl_demo_output=>display( lref_text_exc->get_text( ) ).

     ENDTRY.

   ENDMETHOD.

ENDCLASS.



START-OF-SELECTION.

   lcl_demo=>main( ).
