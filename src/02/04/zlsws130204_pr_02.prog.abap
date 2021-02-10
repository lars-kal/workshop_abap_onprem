report zlsws130204_pr_02.

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


data(lv_matnr) = conv matnr( '000000000010009400' ).

"Alle MARD Sätze für nicht-chargenpflichtiges Material
  with
    +rel_matnr as (

    select from marc
    fields werks, matnr
    where matnr = @lv_matnr

    ),
    +stock as (

  select from mard
    inner join marc as marc on "nur nicht-chargenpflichtige
      marc~werks = mard~werks and
      marc~matnr = mard~matnr and
      marc~xchar = @abap_false
    inner join +rel_matnr as rel_matnr on "einschränken auf relevante Materialien
       rel_matnr~matnr = mard~matnr
    fields
      mard~werks,
      mard~lgort,
      mard~matnr,

     cast( '0000000000' as numc( 10 ) ) as rsnum,
     cast( '0000000000' as numc( 4 ) ) as rspos,
     cast( ' ' as char( 1 ) ) as rsart,
     '          ' as lifnr,
     cast( '00000000' as numc( 8 ) ) as pspnr,

       mard~labst,
       mard~umlme,
       mard~insme,
       mard~einme,
       mard~retme

*     where
*       mchb~matnr = @lv_matnr
    union all
    select from mchb
     inner join marc as marc on "nur chargenpflichtige
       marc~werks = mchb~werks and
       marc~matnr = mchb~matnr and
       marc~xchar = @abap_true
     inner join +rel_matnr as rel_matnr on
       rel_matnr~matnr = mchb~matnr
     fields
       mchb~werks,
       mchb~lgort,
       mchb~matnr,

      cast( '0000000000' as numc( 10 ) ) as rsnum,
      cast( '0000' as numc( 4 ) ) as rspos,
      cast( ' ' as char( 1 ) ) as rsart,
  '          ' as lifnr,
    cast( '00000000' as numc( 8 ) ) as pspnr,

       mchb~clabs as labst,
       mchb~cumlm as umlme,
       mchb~cinsm as insme,
       mchb~ceinm as einme,
       mchb~cretm as retme
*     where
*       mchb~matnr = @lv_matnr
    union all
    select from resb
     inner join +rel_matnr as rel_matnr on
       rel_matnr~matnr = resb~matnr
     fields
       resb~werks,
       resb~lgort,
       resb~matnr,

       resb~rsnum as rsnum,
resb~rspos,
resb~rsart,
  '          ' as lifnr,
    cast( '00000000' as numc( 8 ) ) as pspnr,

       resb~bdmng as labst,
       cast( 0 as quan( 13 , 3 ) ) as umlme,
       cast( 0 as quan( 13 , 3 ) ) as  insme,
       cast( 0 as quan( 13 , 3 ) ) as  einme,
       cast( 0 as quan( 13 , 3 ) ) as  retme
*     where
*       mchb~matnr = @lv_matnr
    union all
    select from mslb
     inner join +rel_matnr as rel_matnr on
       rel_matnr~matnr = mslb~matnr
     fields
       mslb~werks,
       '    ' as lgort,
       mslb~matnr,

      cast( '0000000000' as numc( 10 ) ) as rsnum,
      cast( '0000' as numc( 4 ) ) as rspos,
      cast( ' ' as char( 1 ) ) as rsart,
      mslb~lifnr,
      cast( '00000000' as numc( 8 ) ) as pspnr,

       mslb~lblab as labst,
       cast( 0 as quan( 13 , 3 ) ) as umlme,
       cast( 0 as quan( 13 , 3 ) ) as  insme,
       cast( 0 as quan( 13 , 3 ) ) as  einme,
       cast( 0 as quan( 13 , 3 ) ) as  retme
    union all
    select from mspr
     inner join +rel_matnr as rel_matnr on
       rel_matnr~matnr = mspr~matnr
     fields
      mspr~werks,
       '    ' as lgort,
       mspr~matnr,

      cast( '0000000000' as numc( 10 ) ) as rsnum,
      cast( '0000' as numc( 4 ) ) as rspos,
      cast( ' ' as char( 1 ) ) as rsart,
      '          ' as lifnr,
        mspr~pspnr,

           mspr~prlab as labst,
       cast( 0 as quan( 13 , 3 ) ) as umlme,
       cast( 0 as quan( 13 , 3 ) ) as  insme,
       cast( 0 as quan( 13 , 3 ) ) as  einme,
       cast( 0 as quan( 13 , 3 ) ) as  retme
       )

     select from +stock
        fields *
        into CORRESPONDING FIELDS OF table @lt_stock.



*delete from ZSTC_T_GTT.

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
