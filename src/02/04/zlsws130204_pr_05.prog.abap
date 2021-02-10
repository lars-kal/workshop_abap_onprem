*&---------------------------------------------------------------------*
*& Report ZPR_KAL0101_08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlsws130204_pr_05.

start-of-selection.

  break-point.

  "classic way
  "direkter datenbankzugriff
  "datenbanktabellen sind nicht kryptisch (vbeln,posnr usw)
  select
    vbak~vbeln,
    vbak~vbtyp,
    vbap~posnr,
    vbap~matnr,
    vbap~zmeng
    from vbak
     join vbap
        on vbak~vbeln = vbap~vbeln
    into table @data(lt_vbak_vbap)
  where auart = 'TA'.


  "EWM weg
  "kein direkter zugriff auf datenbank
  "datenbank kryptisch, guid usw
  "technische optimierung, keine konsumentenoptimierung
  "zugriff über API
  "API ist auf applikaitonsserver (klassen und fubas)
  "Zugriff über Rangetabellen
  data(lo_stock) = new /scwm/cl_mon_stock( iv_lgnum = 'EWML' ).

  data(lt_r_lgtyp) = value /scwm/tt_lgtyp_r(
     ( sign = 'I' option = 'EQ' low = '0080' )
      ).

  lo_stock->get_physical_stock(
    exporting
       it_lgtyp_r       = lt_r_lgtyp
*           it_lgpla_r       = CORRESPONDING #( ms_sel-so_egpla )
*           it_matnr_r       = VALUE #( FOR ls_row IN it_material ( sign = 'I' option = 'EQ' low = ls_row-matnr ) )
*           it_charg_r       = CORRESPONDING #( ms_sel-so_charg )
*           it_serid_r       = CORRESPONDING #( ms_sel-so_sernr )
    importing
      et_stock_mon     = data(lt_stock) "ct_stock
      ev_error         = data(lv_error) ).



  "VDM weg
  "kein direkter zugriff auf datenbank
  "datenbank kryptisch, guid usws
  "technische optimierung, keine konsumentenoptimierung
  "zugriff über API
  "API ist auf Datenbank (Core data services - VDM)
  "VDM für Konsumenten optimiert
  "Zugriff über ABAP SQL
  select from i_salesorder
  fields
   salesorder,
    \_item-salesorderitem,
     \_item\_partner[ partnerfunction = 'WE' ]-customer
    where salesorder = '0000000004'
  into table @data(lt_result).
