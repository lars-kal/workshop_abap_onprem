*&---------------------------------------------------------------------*
*& Report ZLS090401_RE_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLS090401_RE_01.

parameters:
  pa_nr   type i default 1,  " Anzahl erwarteter Nachrichten
  pa_wait type i default 20. " Wartezeit in Sekunden
data:
  gr_consumer  type ref to if_amc_message_consumer,
  gt_messages  type table of string,
  gv_message   type string,
  gv_nr        type i, " Anzahl empfangener Nachrichten
  gr_amc_error type ref to cx_amc_error.
* Implementierungsklasse für die AMC-Empfängerschnittstelle
class lcl_amc_receiver definition
final
  create public.
  public section.
    interfaces if_amc_message_receiver_text.
endclass.
class lcl_amc_receiver implementation.
  method if_amc_message_receiver_text~receive.
* Nachricht in die globale interne Tabelle einfügen
    append i_message to gt_messages.
    add 1 to gv_nr.
  endmethod.
endclass.

start-of-selection.
  data: gr_receiver type ref to lcl_amc_receiver.
  try.
      gr_consumer =
        cl_amc_channel_manager=>create_message_consumer(
          i_application_id =  'ZLS_AMC_01'
          i_channel_id = '/test' ).
      create object gr_receiver.
      " Empfänger subskribieren
      gr_consumer->start_message_delivery(
        i_receiver = gr_receiver ).
    catch cx_amc_error into gr_amc_error.
      message gr_amc_error->get_text( ) type 'E'.
  endtry.
* So lange warten, bis alle Nachrichten empfangen wurden,
* jedoch nicht länger als die Wartezeit.
*
  wait for messaging channels until gv_nr >= pa_nr
    up to pa_wait seconds.
  if sy-subrc = 8.
    if  gv_nr = 0.
      write: 'Time-Out aufgetreten,',
             'keine Nachrichten empfangen.'.
    elseif gv_nr < pa_nr.
      write: 'Time-Out aufgetreten,',
             'nicht alle Nachrichten empfangen.'.
    endif.
  else.
    write: 'Alle Nachrichten empfangen.'.
  endif.
  loop at gt_messages into gv_message.
    "Liste der Nachrichten ausgeben
    write: / sy-tabix, gv_message.
  endloop.
