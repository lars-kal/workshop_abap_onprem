*&---------------------------------------------------------------------*
*& Report zpr_ls_ws_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zpkal010201_pr_03.

start-of-selection.

  data(lv_matnr) = 'R-0001'.


  "Mit dem Release 7.40, SP5 und SP8, hat sich Open SQL an den SQL92-Standard angenähert
  "Mit 7.40, SP5 gibt es einen neuen SQL Parser im ABAP Kernel und somit auch eine neue SQL Syntax.
  "Aufgelistete Spaltennamen müssen durch Komma getrennt werden
  "Bei Hostvariablen muss ein @ vorangestellt werden

  "Inline deklaration
  "hostvraiablen
  "tabelle vorangestellt

  select from mard
    fields
    'free' as type,
    matnr as materia,
    labst as quantity
   where matnr = @lv_matnr
   into table @data(lt_db_stock1).


  select from mard
    fields
    'free' as type,
    matnr as materia,
    labst as quantity
  union all
    select from resb
    fields
     'rese' as type,
    matnr as materia,
    bdmng as quantity
   into table @data(lt_db_stock2).






  "union wird auf duplicate geprüft und diese nicht übernommen (= union distinct)
  "union all macht das nciht und ist daher schneller

  "https://blogs.sap.com/2015/11/09/abap-news-for-release-750-select-union/
  "https://help.sap.com/doc/abapdocu_750_index_htm/7.50/en-US/index.htm?file=abapunion_clause.htm


  "union
  select a as c1, b as c2, c as c3, d as c4
    from demo_join1
  union distinct
  select d as c1, e as c2, f as c3, g as c4
   from demo_join2
  union distinct
  select i as c1, j as c2, k as c3, l as c4
    from demo_join3
   into table @data(result_distinct).


  "union complex
  data carrid type sflight-carrid value 'AA'.

  "https://help.sap.com/doc/abapdocu_750_index_htm/7.50/en-US/index.htm?file=abapunion_clause.htm
  "first select reads all flight
  "second sums
  select ' ' as mark, carrid, connid, fldate, seatsocc
         from sflight
         where carrid = @( to_upper( carrid ) )
         union select 'X' as mark,
                      carrid,
                      connid,
                      cast( '00000000' as dats ) as fldate,
                      sum( seatsocc ) as seatsocc
                      from sflight
                      where carrid = @( to_upper( carrid ) )
                      group by carrid, connid
         order by carrid, connid, mark, fldate, seatsocc
         into table @data(result).









  select from likp
  fields
      vbeln as delivery,
      cast( @abap_false as char( 10 ) ) as shipment,
      cast( @abap_false as char( 10 ) ) as salesorder,
      cast( @abap_false as char( 10 ) ) as hu
   where vbeln = '0065600668'

  union select from vbfa "Transport lesen
  fields
      vbelv as delivery,
      vbeln as shipment,
      cast( @abap_false as char( 10 ) ) as salesorder,
      cast( @abap_false as char( 10 ) ) as hu
   where vbelv = '0065600668'
   and vbtyp_v = 'J'
   and vbtyp_n = '8'

  union select from vbfa "Kundenauftrag
  fields
    vbeln as delivery,
    cast( @abap_false as char( 10 ) ) as shipment,
    vbelv as salesorder,
    cast( @abap_false as char( 10 ) ) as hu
  where vbeln = '0065600668'
  and vbtyp_n = 'J'
  and vbtyp_v = 'C'

  union distinct ( select from vbfa "HUs
    fields
      vbeln as delivery,
      cast( @abap_false as char( 10 ) ) as shipment,
      cast( @abap_false as char( 10 ) ) as salesorder,
      vbeln as hu
      where vbelv = '0065600668'
      and vbtyp_n = 'X'
      and vbtyp_v = 'J' )
  into table @data(lt_tab00).



  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  types:
    begin of ty_s_result,
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

    end of ty_s_result.
  data lt_stock type standard table of ty_s_result. " with NON-UNIQUE key matnr werks lgort.

  break-point.


  lv_matnr = conv matnr( '000000000010009400' ).
*data lt_rel_matnr type STANDARD TABLE OF mara.
*insert value #( matnr = lv_matnr ) into table lt_rel_matnr.

*data lt_test type STANDARD TABLE OF zstc_T_gtt.
*lt_test = CORRESPONDING #( value mara_tab( ( matnr = lv_matnr ) ) ).

*INSERT zstc_t_gtt FROM TABLE @( VALUE #( ( matnr = lv_matnr ) ) ).

*INSERT zstc_t_gtt FROM (
*SELECT FROM marc FIELDS werks, matnr
* ).


  "Alle MARD Sätze für nicht-chargenpflichtiges Material
  select from mard
    inner join marc as marc on "nur nicht-chargenpflichtige
      marc~werks = mard~werks and
      marc~matnr = mard~matnr and
      marc~xchar = @abap_false
*  INNER JOIN zstc_t_gtt AS rel_matnr ON "einschränken auf relevante Materialien
*     rel_matnr~matnr = mard~matnr
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
**   INNER JOIN zstc_t_gtt AS rel_matnr ON
*     rel_matnr~matnr = mchb~matnr
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
*   INNER JOIN zstc_t_gtt AS rel_matnr ON
*     rel_matnr~matnr = resb~matnr
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
*   INNER JOIN zstc_t_gtt AS rel_matnr ON
*     rel_matnr~matnr = mslb~matnr
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
*   INNER JOIN zstc_t_gtt AS rel_matnr ON
*     rel_matnr~matnr = mspr~matnr
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
*     where
*       mchb~matnr = @lv_matnr
     into corresponding fields of table @lt_stock.
