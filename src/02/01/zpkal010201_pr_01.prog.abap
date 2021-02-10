report zre_stc_workshop_new_open_sql.


start-of-selection.

  "Mit dem Release 7.40, SP5 und SP8, hat sich Open SQL an den SQL92-Standard angenähert
  "Mit 7.40, SP5 gibt es einen neuen SQL Parser im ABAP Kernel und somit auch eine neue SQL Syntax.
  "Aufgelistete Spaltennamen müssen durch Komma getrennt werden
  "Bei Hostvariablen muss ein @ vorangestellt werden


  data lt_t100 type standard table of t100.

  "host variables @
  select *
  from t100
  into table @lt_t100
  up to 10 rows.

  "komma trennung
  select sprsl, arbgb
  from t100
  up to 10 rows
  into table @lt_t100.

  "datendefinition
  select *
  from t100
  up to 10 rows
  into table @data(lt_t100_new).

  "instead of select single mandt
  select single @abap_true
  from t100
  into @data(lv_is_entry_exists)
  where arbgb = '234'.

  if lv_is_entry_exists = abap_true.

  endif.

  select single @abap_true
  from usr01
  where bname = @( cl_abap_syst=>get_user_name( ) )
  into @data(lv_is_user_exist).


  "inner join improvements usr01~*
  select usr01~* , usr02~bname
  from usr01
  inner join usr02
  on usr02~bname = usr01~bname
  where usr01~bname = @( 'FRED' )
  into table @data(lt_test).


  "as befehl
  select id, char1 as char2
  from demo_expressions
  into table @data(lt_results).


  "mit CAST können im SQL nur eingebauten Dictionary-Typen verwendet werden
  select carrid,
         connid,
         cast( fldate as char ) as chardat " DATS als CHAR interpretieren
    from sflight
    where carrid = 'LH'
      into table @data(it_result).


  "case
  data(lv_else) = 'YYYY'.
  select id, char1, char2,
     case char1
       when 'aaaaa' then ( 'BBBBBB' )
       when 'xxxxx' then ( 'CCCCC' )
       else @lv_else
     end as text
  from demo_expressions
  into table @data(lt_results2).


  "length
  select carrid,
    length( connid ) as length
    from sflight
    into table @data(it_result3)
    up to 10 rows.



      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
