*&---------------------------------------------------------------------*
*& Report ZLS090401_RE_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLS090401_RE_02.


parameters:
  pa_msg type string lower case default 'Hallo, Welt!'.
data:
  gr_producer_text type ref to if_amc_message_producer_text,
  gr_amc_error     type ref to cx_amc_error.

start-of-selection.
  try.
      " Nachrichtenproduzent anlegen
      gr_producer_text ?=
        cl_amc_channel_manager=>create_message_producer(
          i_application_id =  'ZLS_AMC_01'
          i_channel_id = '/test'
      ).
      " Textnachricht verschicken
      gr_producer_text->send( i_message = pa_msg ).
    catch cx_amc_error into gr_amc_error.
      message gr_amc_error->get_text( ) type 'E'.
  endtry.
