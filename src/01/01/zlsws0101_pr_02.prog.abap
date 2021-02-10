*&---------------------------------------------------------------------*
*& Report ZLSWS0101_RE_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLSWS0101_PR_02.

*class hlp definition inheriting from zcl_utility_abap_2011.
*endclass.

types : tt_vbak type standard table of vbak with default key,
        tt_vbap type standard table of vbap with default key,
        tt_vbrp type standard table of vbrp with default key.


types : begin of mesh ty_mesh,
          so_header type tt_vbak
            association header_item to so_item on vbeln = vbeln,  "Association to  sales order (SO) item table
          so_item   type tt_vbap
            association so_billing to billing on vgbel = vbeln  "Association to billing table
            and    posnr = posnr,
          billing   type tt_vbrp,
        end of mesh ty_mesh.
data gt_mesh type ty_mesh.



select * from vbak
where vgbel ne @space
into table @data(gt_vbak)
up to 5 rows .
if sy-subrc is initial.
  select * from vbap
  for all entries in @gt_vbak
  where vbeln = @gt_vbak-vbeln
  into table @data(gt_vbap).
  if sy-subrc is initial.

    "only considering first line item
    delete adjacent duplicates from gt_vbap comparing vbeln.
    select * from vbrp
    for all entries in @gt_vbap
    where aubel = @gt_vbap-vbeln
    and posnr = @gt_vbap-posnr
    into table @data(gt_vbrp).
    if sy-subrc is initial.
      delete adjacent duplicates from gt_vbrp comparing vbeln.
    endif.
  endif.
endif.





data(gs_htoi) = gt_mesh-so_header\header_item[ gt_mesh-so_header[ 1 ] ].

gs_htoi =  gt_mesh-so_header\header_item[ gt_mesh-so_header[ vbeln = '0000000036' ] ].

data(gs_itob) =  gt_mesh-so_item\so_billing[ gt_mesh-so_item[ 3 ] ].

data(gs_btoi) =  gt_mesh-billing\^so_billing~so_item[ gt_mesh-billing[ vbeln = '0090000007' ] ].

data(gs_btoh) =  gt_mesh-billing\^so_billing~so_item[ gt_mesh-billing[ vbeln = '0090000007' ] ]\^header_item~so_header[ ].




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


*report zlktest3.



start-of-selection.

*  data(lt_bapi) = value bapirettab( ).

*  lt_bapi = value #( base lt_bapi ( hlp=>msg( type = 'E' )-s_msg  ) ).
*  insert hlp=>msg( type = 'E' )-s_msg into table lt_bapi.

* Direktes Befüllen einer Tabelle mit einer zweiten Zeile
*lt_symsg = VALUE #( BASE lt_symsg ( msgty = ‚E‘ msgid = ‚DEMO‘ msgno = ‚002‘ ) ).


  break-point.

*  select plnum
*     from plaf
*     into table @data(lt_plaf)
*     up to 10000 rows.

*TYPES: BEGIN OF ty_orte,
*         key_ort TYPE i,
*         ort     TYPE string,
*       END OF ty_orte.
*
* Personen
*TYPES: BEGIN OF ty_personen,
*         key_ort TYPE i,
*         name    TYPE string,
*         alter   TYPE i,
*       END OF ty_personen.
*
*TYPES: ty_it_orte TYPE SORTED TABLE OF ty_orte WITH UNIQUE KEY key_ort.
*TYPES: ty_it_personen TYPE SORTED TABLE OF ty_personen WITH NON-UNIQUE KEY key_ort.
*
** MESH mit Assoziation
*TYPES: BEGIN OF MESH ty_mesh,
*         orte     TYPE ty_it_orte ASSOCIATION orte_to_personen TO personen ON key_ort = key_ort,
*         personen TYPE ty_it_personen,
*       END OF MESH ty_mesh.
*
*DATA: it_mesh TYPE ty_mesh.
*
  break-point.

* Orte
  types: begin of ty_orte,
           key_ort type i,
           ort     type string,
         end of ty_orte.

* Personen
  types: begin of ty_personen,
           key_ort type i,
           name    type string,
           alter   type i,
         end of ty_personen.

  types: ty_it_orte type sorted table of ty_orte with unique key key_ort.
  types: ty_it_personen type sorted table of ty_personen with non-unique key key_ort.

* MESH mit Assoziation
  types: begin of mesh ty_mesh2,
           orte     type ty_it_orte association orte_to_personen to personen on key_ort = key_ort,
           personen type ty_it_personen,
         end of mesh ty_mesh2.

  data: it_mesh type ty_mesh2.

*INITIALIZATION.
* Daten einpflegen
  it_mesh-orte = value #( ( key_ort = 1 ort = 'FRA' )
                          ( key_ort = 2 ort = 'BER' )
                          ( key_ort = 3 ort = 'DRS' )
                          ( key_ort = 4 ort = 'MUN' )
                          ( key_ort = 5 ort = 'DUS' ) ).

  it_mesh-personen = value #( ( key_ort = 1 name = 'Udo'      alter = 35 )
                              ( key_ort = 4 name = 'Horst'    alter = 60 )
                              ( key_ort = 3 name = 'Inge'     alter = 70 )
                              ( key_ort = 1 name = 'Elfriede' alter = 85 )
                              ( key_ort = 5 name = 'Florian'  alter = 16 ) ).

  break-point.
  data(lv_p) = it_mesh-orte\orte_to_personen[ it_mesh-orte[ key_ort = 1 ] ].

  loop at it_mesh-orte\orte_to_personen[ it_mesh-orte[ key_ort = 1 ] ] into data(ls_result).
    lv_p = ls_result.
  endloop.



  write: / 'Orte:'.
  loop at it_mesh-orte assigning field-symbol(<o>).
    write: / <o>-key_ort, <o>-ort.
  endloop.

  uline.

  write: / 'Personen:'.
  loop at it_mesh-personen assigning field-symbol(<p>).
    write: / <p>-key_ort, <p>-name, <p>-alter.
  endloop.

  uline.

  try.
* Forward Association
      write: / 'Forward Association Ort->Person ( key = 1 )'.
*      DATA(lv_p) = it_mesh-orte\orte_to_personen[ it_mesh-orte[ key_ort = 1 ] ].
      write: / lv_p-key_ort, lv_p-name, lv_p-alter.
    catch cx_root.
  endtry.

  try.
* Inverse Assocition
      write: / 'Inverse Assocition Ort->Personen->Ort( key_ort = 3 )'.
      data(lv_o) = it_mesh-personen\^orte_to_personen~orte[ it_mesh-personen[ key_ort = 3 ] ] .
      write: / lv_o-key_ort, lv_o-ort.
    catch cx_root.
  endtry.
  break-point.
