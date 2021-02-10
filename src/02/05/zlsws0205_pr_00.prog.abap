*&---------------------------------------------------------------------*
*& Report ZLSWS0205_PR_00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLSWS0205_PR_00.

DATA: gr_dg_main TYPE REF TO zcl_ls010205_main.

PARAMETERS: p_fdfr TYPE s_date.
PARAMETERS: p_fdto TYPE s_date.

START-OF-SELECTION.
  gr_dg_main = zcl_ls010205_main=>get_instance( ).
  TRY.
      gr_dg_main->generate_mass_data(
        EXPORTING
          iv_fldate_from            = p_fdfr
          iv_fldate_to              = p_fdto ).
    CATCH zcl_ls010205_exception.
  ENDTRY.
