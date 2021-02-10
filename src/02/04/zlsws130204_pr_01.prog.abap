*&---------------------------------------------------------------------*
*& Report ZRE_KAL0101_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLSWS130204_PR_01.


data(lv_matnr) = conv matnr( '000000000010009400' ).
data lt_rel_matnr type STANDARD TABLE OF mara.
insert value #( matnr = lv_matnr ) into table lt_rel_matnr.

select matnr from mara
  into CORRESPONDING FIELDS OF table lt_rel_matnr.

types:
   begin of ty_S_result,
     matnr type marc-matnr,
     werks type marc-werks,

     lgort type lgort_d,
     charg type charg_d,
     sobkz type sobkz,

     rsnum type resb-rsnum, "Reservierungen
     rspos type resb-rspos, "Reservierungen
     rsart type resb-rsart, "Reservierungen
     lifnr type mslb-lifnr, "Sonerbestand beim Lieferanten
     pspnr type mspr-pspnr, "Projektbestand

     labst type labst,
     umlme type umlme,
     insme type insme,
     einme type einme,
     speme type speme,
     retme type retme,

  end of ty_S_result.
data lt_stock type STANDARD TABLE OF ty_S_result. " with NON-UNIQUE key matnr werks lgort.

break-point.

"Alle MARD Sätze für nicht-chargenpflichtiges Material
  select from mard
    inner join marc as marc on "nur nicht-chargenpflichtige
      marc~werks = mard~werks and
      marc~matnr = mard~matnr and
      marc~xchar = @abap_false
    inner join @lt_rel_matnr as rel_matnr on "einschränken auf relevante Materialien
       rel_matnr~matnr = mard~matnr
    fields
       mard~*
*     where
*       mchb~matnr = @lv_matnr
    APPENDING CORRESPONDING FIELDS OF TABLE @lt_stock.

 "Alle mchb Sätze für chargenpflichtiges Material
    select from mchb
     inner join marc as marc on "nur chargenpflichtige
       marc~werks = mchb~werks and
       marc~matnr = mchb~matnr and
       marc~xchar = @abap_true
     inner join @lt_rel_matnr as rel_matnr on
       rel_matnr~matnr = mchb~matnr
     fields
       mchb~*,
       mchb~clabs as labst,
       mchb~cumlm as umlme,
       mchb~cinsm as insme,
       mchb~ceinm as einme,
       mchb~cretm as retme
*     where
*       mchb~matnr = @lv_matnr
  APPENDING CORRESPONDING FIELDS OF table @lt_stock.

      break-point.

 "Alle Reservierungen / Sekundärbedarfe
    select from resb
     inner join @lt_rel_matnr as rel_matnr on
       rel_matnr~matnr = resb~matnr
     fields
      resb~*,
      resb~bdmng as labst
*     where
*       mchb~matnr = @lv_matnr
   APPENDING CORRESPONDING FIELDS OF table @lt_stock.


    "Sonderbestände beim Lieferanten
    select from mslb
     inner join @lt_rel_matnr as rel_matnr on
       rel_matnr~matnr = mslb~matnr
     fields
      mslb~*,
      mslb~lblab as labst
*     where
*       mchb~matnr = @lv_matnr
   APPENDING CORRESPONDING FIELDS OF table @lt_stock.


    "Projektbestand
    select from mspr
     inner join @lt_rel_matnr as rel_matnr on
       rel_matnr~matnr = mspr~matnr
     fields
      mspr~*,
      mspr~prlab as labst
*     where
*       mchb~matnr = @lv_matnr
   APPENDING CORRESPONDING FIELDS OF table @lt_stock.




"Wenn keine Chargen angezeigt werden
"chargen zusammenfassen
      select from @lt_stock as stock
       fields
        matnr,
        werks,
        lgort,
*        stock~*,
        sum( labst ) as labst
        group by matnr, werks, lgort
     into CORRESPONDING FIELDS OF table @lt_stock.


* data(lt_result) = value #( filter #( lt_result where matnr = lv_matnr ) ).

   break-point.
