*&---------------------------------------------------------------------*
*& Report ZLSWS0101_RE_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLSWS0101_PR_01.


interface li_example_fail_ignore.

  methods method_test1.
  methods method_test2 default fail.
  methods method_test3 default ignore.

endinterface.

class lcl_marc_proxy definition.
  public section.
    methods constructor importing iv_plant type werks_d.
    methods exists importing iv_matnr       type matnr
                   returning value(rv_flag) type boole_d.
  private section.
    types: begin of ts_hit,
             matnr type matnr,
             found type flag,
           end of ts_hit.
    types tt_hit type sorted table of ts_hit with unique key matnr.

    data mv_werks type werks_d.
    data mt_hit type tt_hit.

    methods fetch importing iv_matnr        type matnr
                  returning value(rv_found) type boole_d.
endclass.

class lcl_marc_proxy implementation.

  method constructor.
    mv_werks = iv_plant.
  endmethod.

  method fetch.
    select single matnr from marc into @data(lv_matnr)     " Existence check
      where matnr = @iv_matnr
        and werks = @mv_werks.
    rv_found = xsdbool( sy-subrc eq 0 ).
    insert value #( matnr = iv_matnr
                    found = rv_found ) into table mt_hit.
  endmethod.

  method exists. "  existence check with chache

    rv_flag = value #( mt_hit[ matnr = iv_matnr ]-found default fetch( iv_matnr ) ).

  endmethod.

endclass.

class lcx_example definition inheriting from cx_static_check.

  public section.
    interfaces if_t100_dyn_msg.

endclass.

class lcl_example definition.
  public section.

    class-methods is_value_in_range
      importing
                iv_dummy      type string
      returning value(result) type abap_bool.


    methods
      do_something
        returning
          value(result) type ref to lcl_example.

    methods
      do_something_else
        returning
          value(result) type ref to lcl_example.

endclass.

class lcl_example implementation.

  method is_value_in_range.

  endmethod.

  method do_something.

    result = me.

  endmethod.

  method do_something_else.

    result = me.

  endmethod.

endclass.

class lcx_example implementation.

endclass.

class lcl_new_abap_syntax definition.

  public section.

    class-methods main.
    class-methods sql_power.

  protected section.

    class-methods value.
    class-methods conv.
    class-methods let_and_reduce.
    class-methods internal_tables.
    class-methods conditions.
    class-methods type_boxed.
    class-methods exceptions.
    class-methods internal_tables_corresponding.
    class-methods internal_tables_secondary_key.
    class-methods other_features.
    class-methods enum.
    class-methods string.
    class-methods string_functions.
    class-methods string_embedded_expressions.
    class-methods sql_common_table_expression.
    class-methods classes.
    class-methods good_examples.


endclass.

class lcl_new_abap_syntax implementation.



  method let_and_reduce.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " let
*    lv_text = COND #( WHEN 1 = 0 THEN 'Never true'
*                      WHEN 1 = 1 THEN 'always true'
*                      ELSE 'never reached' ).

    "switch instead of case
    data(lv_text) = cond string( let date = sy-datum in
               when date = '01012020'  then 'ABC'
               when date = '01022020'  then 'EDG'
                else 'GHJ' ).



    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " reduce

    "sum 1 to 10
    data(lv_test) =  reduce i( init s = 0
                          for  i = 1 until i > 10
                          next s = s + i ) .

    "typen reduzieren

    data it_komv type sorted table of komv with non-unique key primary_key components knumv. "key_kposn COMPONENTS knumv kposn.

    "auf einen typ reduzieren
    data(lv_netwr) = reduce netwr( init val type netwr
                                    for wa in
                                    filter #( it_komv
                                              using key primary_key
                                              where knumv eq conv #( '123456') )
                                    next val = val + wa-kwert ).


  endmethod.

  method string.

    data(lv_string) = `das ist ein string`.
    data(lv_char)   = 'Das ist ein character der laenge 34'.


    data(lv_stringtable) = value string_table(
                                         ( conv string( 'Zeile 1' ) )
                                         ( `Zeile 2` )
                                         ( `Zeile 3` )
                                         ( `Zeile 4` )
                                    ).

    data(lv_text) = concat_lines_of( lv_stringtable ).


    lv_text = 'Das' && 'ist' && 'ein' && 'Satz'.

    "very new abap 7.53
*    lv_string    = 'Das'.
*    lv_string  &&= 'ist'.
*    lv_string  &&= 'ein'.
*    lv_string  &&= 'Satz'.

    lv_text = |Das ist ein Satz|.
    lv_text = |'Das ist ein Satz in Anführungszeichen'|.

    "Werte
    lv_text = |Das ist der Wert einer Variable: { lv_string }|.
    lv_text = |My IP address = { cl_gui_frontend_services=>get_ip_address( ) }|.



  endmethod.

  method conditions.

    data(lv_day) = 'Monday'.

    data(lv_text)  = switch #( lv_day when 'Monday' then 'The week begins' ).
    data(lv_text2) = switch string( lv_day when 'Monday' then 'The week begins' ).


    "switch instead of case
    data(lv_text3) = switch string( lv_day
                              when 'Monday'   then 'The week begins'
                              when 'Wednsday' then 'Middle of the week'
                              when 'Fiday'    then 'Weekend'
                                              else 'no Idea' ).


    "cond instead of if/else -> more complex switch
    lv_text = cond #( when 1 = 0 then 'Never true'
                      when 1 = 1 then 'always true'
                      else 'never reached' ).


    "= abap_true is not needed
    if lcl_example=>is_value_in_range( 'Dummy' ).

    endif.


    "function xsdbool can be used
    data(lv_is_string_length_greater_0) = xsdbool( strlen( 'abc' ) > 0 ).
    " and is shorteh than
    "if
    "..
    "else.
    "..
    "endif

    "use the function i conditions
    if xsdbool( 1 = 1 ) = abap_true.

    endif.




* erzeugt Char der Länge 1
* logischer Ausdruck wahr   -> 'X'
* logischer Ausdruck falsch -> ' '

**    * erzeugt String der Länge 1
** logischer Ausdruck wahr   -> 'X'
** logischer Ausdruck falsch -> ' '
*    DATA(lv_bc) = boolc( strlen( 'abc' ) > 0 ).


  endmethod.

  method internal_tables.


    types:
      begin of ty_test,
        id   type n length 2,
        name type string,
      end of ty_test.

    types ty_t_test type standard table of ty_test with empty key. "NON-UNIQUE KEY name.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " read table

    data(accounts2) = value ty_t_test( ( id = 5  name = 'Klaus' )
                                       ( id = 6 name = 'Peter' ) ).
    try.

        data(ls_row) = accounts2[ 1 ].
        ls_row       = accounts2[ 2 ].

        "works like: read table ... into data(...)
        ls_row = accounts2[ name = 'Peter' ].

        "works like: read table ... assigning field-symbol( ... )
        accounts2[ name = 'Peter' ]-name = 'Klaus'.

        "works like: read table ... reference into data( ... )
        data(lr_row) = ref ty_test( accounts2[ name = 'Klaus' ] ).
        lr_row->name = 'Peter'.


      catch cx_sy_itab_line_not_found.
    endtry.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " line_exists( table )

    ls_row = accounts2[ name = 'Peter' ].

    try.

        ls_row = accounts2[ name = 'Fritz' ].

      catch cx_sy_itab_line_not_found into data(lx_no_line_exists).

    endtry.


    "no exception when
    if line_exists( accounts2[ name = 'Fritz' ] ).

    else.
      "do something else
    endif.

    "or
    ls_row = value #( accounts2[ name = 'Fritz' ] default accounts2[ name = 'Peter' ] ).


    "index of a row
    data(lv_index_peter) = line_index( accounts2[ name = 'Peter' ] ).


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " chainings

    types:
      begin of struc1,
        col1 type i,
        col2 type i,
      end of struc1,
      itab1 type table of struc1 with empty key,
      itab2 type table of itab1 with empty key,
      begin of struc2,
        col1 type i,
        col2 type itab2,
      end of struc2,
      itab3 type table of struc2 with empty key.

    data(itab) = value itab3(
       ( col1 = 1  col2 = value itab2(
                           ( value itab1(
                               ( col1 = 2 col2 = 3 )
                               ( col1 = 4 col2 = 5 ) ) )
                           ( value itab1(
                               ( col1 = 6 col2 = 7 )
                               ( col1 = 8 col2 = 9 ) ) ) ) )
       ( col1 = 10 col2 = value itab2(
                           ( value itab1(
                               ( col1 = 11 col2 = 12 )
                               ( col1 = 13 col2 = 14 ) ) )
                           ( value itab1(
                               ( col1 = 15 col2 = 16 )
                               ( col1 = 17 col2 = 18 ) ) ) ) ) ).

    read table itab     into data(wa1) index 2.
    read table wa1-col2 into data(wa2) index 1.
    read table wa2      into data(wa3) index 2.
    data(num1) = wa3-col1.

    "Reading the column with value 13 with chained table expressions
    data(num2) = itab[ 2 ]-col2[ 1 ][ 2 ]-col1.



    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " for ... in ... iteration

    types ty_t_test_sorted type sorted table of ty_test with non-unique key name.

    data(accounts) = value ty_t_test_sorted( ( id = 5 name = 'Klaus' )
                                             ( id = 6 name = 'Peter' ) ).


    data result_old type string_table.
    loop at accounts into data(ls_account).
      insert ls_account-name into table result_old.
    endloop.

    data(lt_result_new) = value string_table( for row in accounts (
                                                                     row-name ) ).

    data(lt_result_new2) = value string_table( for row in accounts where ( name = 'Klaus' ) (
                                                                    row-name ) ).





    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " filter

    "1 single value
    data lt_filtered_old type ty_t_test.
    loop at accounts into data(ls_account2) where name = `Klaus`.
      insert ls_account2 into table lt_filtered_old.
    endloop.

    data(table_filtered) = filter #( accounts where name = `Klaus` ).

    "exclude values
    table_filtered = filter #( accounts except where name = `Klaus`  ).



    "filter with other table
    select *
           from scarr
           into table @data(carriers).

    data filter_tab type sorted table of scarr-carrid
                     with unique key table_line.
    filter_tab = value #( ( 'AA ' ) ( 'LH ' ) ( 'UA ' ) ).

    data(lt_result) = filter #( carriers in filter_tab where carrid = table_line ) .

    cl_demo_output=>display( lt_result ).


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " grouping

    "Process data on defined groups using the new features with the loop statement extension group by ... and loop at group.

    loop at accounts into data(account) group by account-id.

      " once per group before group ...

      loop at group account into data(account_group).
        break-point.
        " for each group member ...

      endloop.

      " once per group after group ...
      break-point.

    endloop.



  endmethod.

  method enum.

*https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenenumerated_types_usage.htm
*https://github.com/SAP/styleguides/blob/master/clean-abap/sub-sections/Enumerations.md

    "very new 7.53
*    TYPES:
*      BEGIN OF ENUM planet STRUCTURE planets,
*        mercury,
*        venus,
*        earth,
*        mars,
*        jupiter,
*        saturn,
*        uranus,
*        neptune,
*      END OF ENUM planet STRUCTURE planets.
*
*    DATA planet1 TYPE planet.
*
*    planet1 = planets-earth.
**    planet2 = conv #( 'test' ). "error
*
*    IF planet2 = planets-earth.
*
*    ENDIF.


  endmethod.

  method exceptions.


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " 3 ways to raise an exception

    try.
        raise exception type lcx_example.
      catch cx_root.
    endtry.


    try.
        "7.52
*        RAISE EXCEPTION NEW lcx_example( ).
      catch cx_root.
    endtry.


    try.
        data(lv_dummy) = cond #( when 1 = 0 then 'Dummy'
                                            else throw lcx_example(  ) ).
      catch cx_root.
    endtry.


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " retry

    try.

        "retry block, again again again
        break-point.

        raise exception type lcx_example.


      catch cx_root.
        retry.
    endtry.


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " resume

    try.

        raise resumable exception type lcx_example.

        "logic after resume

      catch before unwind cx_root into data(lx_resume).
        resume.
    endtry.


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " cleanup

    try.
        try.

            raise exception type lcx_example.


          cleanup into data(lx_cleanup).

        endtry.

      catch cx_root into data(lx_root2).

    endtry.


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " message if_t100_dyn_message

    try.

        raise exception type lcx_example
          message id sy-msgid
          type sy-msgty
          number sy-msgno
          with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.


        "7,52 -> short version
*        RAISE EXCEPTION TYPE lcx_example USING MESSAGE.


      catch lcx_example into data(lx_example).
        data(lv_msg) = lx_example->get_text( ).
        data(lv_msg_type) = lx_example->if_t100_dyn_msg~msgty. "Typ Übergabe möglich
    endtry.



  endmethod.

  method internal_tables_corresponding.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " corresponding

    types : begin of lty_demo1,
              col1 type c length 5,
              col2 type c length 5,
            end of lty_demo1,

            begin of lty_demo2,
              col1 type c length 5,
              col2 type c length 5,
              col3 type c length 5,
            end of lty_demo2.

    types ty_t_demo1 type standard table of lty_demo1 with empty key.

    data: itab1 type standard table of lty_demo1,
          itab2 type standard table of lty_demo2.

    itab1 = value #( ( col1 = 'A' col2 = 'B' )
                     ( col1 = 'P' col2 = 'Q' )
                     ( col1 = 'N' col2 = 'P' )
                   ).

    itab2 = corresponding #( itab1 mapping col3 = col2 except col2 ).

    data(itab3) = corresponding ty_t_demo1( itab1 mapping col1 = col1 except col2  ).


    "for two internal tables
    clear itab1.
    move-corresponding itab3 to itab1.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " CL_ABAP_CORRESPONDING

    "https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-US/abencl_abap_corresponding.htm

*DATA:
*  BEGIN OF struct1,
*    a1 TYPE string VALUE 'a1',
*    a2 TYPE string VALUE 'a2',
*    a3 TYPE string VALUE 'a3',
*    a4 TYPE string VALUE 'a4',
*    a5 TYPE string VALUE 'a5',
*  END OF struct1,
*  BEGIN OF struct2,
*    b1 TYPE string VALUE 'b1',
*    b2 TYPE string VALUE 'b2',
*    b3 TYPE string VALUE 'b3',
*    a4 TYPE string VALUE 'b4',
*    a5 TYPE string VALUE 'b5',
*  END OF struct2.
*
*DATA(mapper) =
*  cl_abap_corresponding=>create(
*    source            = struct1
*    destination       = struct2
*    mapping           = VALUE cl_abap_corresponding=>mapping_table(
*      ( level = 0 kind = 1 srcname = 'a1' dstname = 'b3' )
*      ( level = 0 kind = 1 srcname = 'a3' dstname = 'b1' )
*      ( level = 0 kind = 3 ) ) ).
*
*mapper->execute( EXPORTING source      = struct1
*                 CHANGING  destination = struct2 ).
*
*cl_demo_output=>display( struct2 ).

  endmethod.

  method other_features.

    "Time Resolution in WAIT UP TO
    wait up to '1' seconds.
    wait up to '0.1' seconds.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " exact losless operator
    "  exception beispiel

    try.



        data(exact_result) = exact #( 3 * ( 1 / 3 ) ).






      catch cx_sy_conversion_rounding into data(exc).
        data(rounded_result) = exc->value.

      catch cx_root.

    endtry.



  endmethod.

    method sql_power.



*modify spfli from table @(
*VALUE #( ( MANDT ='010' CARRID ='AA' CONNID ='0017' COUNTRYFR ='US' CITYFROM ='NEW YORK' AIRPFROM ='JFK' COUNTRYTO ='US' CITYTO ='SAN FRANCISCO' AIRPTO ='SFO' FLTIME ='361' DEPTIME ='110000' ARRTIME ='140100' DISTANCE ='2572.0000' DISTID ='MI' FLTYPE =''
*PERIOD ='0'  )
* ( MANDT ='010' CARRID ='AA' CONNID ='0064' COUNTRYFR ='US' CITYFROM ='SAN FRANCISCO' AIRPFROM ='SFO' COUNTRYTO ='US' CITYTO ='NEW YORK' AIRPTO ='JFK' FLTIME ='321' DEPTIME ='090000' ARRTIME ='172100' DISTANCE ='2572.0000' DISTID ='MI' FLTYPE ='' PERIOD
*='0'  )
* ( MANDT ='010' CARRID ='AZ' CONNID ='0555' COUNTRYFR ='IT' CITYFROM ='ROME' AIRPFROM ='FCO' COUNTRYTO ='DE' CITYTO ='FRANKFURT' AIRPTO ='FRA' FLTIME ='125' DEPTIME ='190000' ARRTIME ='210500' DISTANCE ='845.0000' DISTID ='MI' FLTYPE ='' PERIOD ='0'  )
* ( MANDT ='010' CARRID ='AZ' CONNID ='0788' COUNTRYFR ='IT' CITYFROM ='ROME' AIRPFROM ='FCO' COUNTRYTO ='JP' CITYTO ='TOKYO' AIRPTO ='TYO' FLTIME ='775' DEPTIME ='120000' ARRTIME ='085500' DISTANCE ='6130.0000' DISTID ='MI' FLTYPE ='' PERIOD ='1'  )
* ( MANDT ='010' CARRID ='AZ' CONNID ='0789' COUNTRYFR ='JP' CITYFROM ='TOKYO' AIRPFROM ='TYO' COUNTRYTO ='IT' CITYTO ='ROME' AIRPTO ='FCO' FLTIME ='940' DEPTIME ='114500' ARRTIME ='192500' DISTANCE ='6130.0000' DISTID ='MI' FLTYPE ='' PERIOD ='0'  )
* ( MANDT ='010' CARRID ='AZ' CONNID ='0790' COUNTRYFR ='IT' CITYFROM ='ROME' AIRPFROM ='FCO' COUNTRYTO ='JP' CITYTO ='OSAKA' AIRPTO ='KIX' FLTIME ='815' DEPTIME ='103500' ARRTIME ='081000' DISTANCE ='6030.0000' DISTID ='MI' FLTYPE ='X' PERIOD ='1'  )
* ( MANDT ='010' CARRID ='DL' CONNID ='0106' COUNTRYFR ='US' CITYFROM ='NEW YORK' AIRPFROM ='JFK' COUNTRYTO ='DE' CITYTO ='FRANKFURT' AIRPTO ='FRA' FLTIME ='475' DEPTIME ='193500' ARRTIME ='093000' DISTANCE ='3851.0000' DISTID ='MI' FLTYPE ='' PERIOD ='1'
*)
* ( MANDT ='010' CARRID ='DL' CONNID ='1699' COUNTRYFR ='US' CITYFROM ='NEW YORK' AIRPFROM ='JFK' COUNTRYTO ='US' CITYTO ='SAN FRANCISCO' AIRPTO ='SFO' FLTIME ='382' DEPTIME ='171500' ARRTIME ='203700' DISTANCE ='2572.0000' DISTID ='MI' FLTYPE ='' PERIOD
*='0'  )
* ( MANDT ='010' CARRID ='DL' CONNID ='1984' COUNTRYFR ='US' CITYFROM ='SAN FRANCISCO' AIRPFROM ='SFO' COUNTRYTO ='US' CITYTO ='NEW YORK' AIRPTO ='JFK' FLTIME ='325' DEPTIME ='100000' ARRTIME ='182500' DISTANCE ='2572.0000' DISTID ='MI' FLTYPE ='' PERIOD
*='0'  )
* ( MANDT ='010' CARRID ='JL' CONNID ='0407' COUNTRYFR ='JP' CITYFROM ='TOKYO' AIRPFROM ='NRT' COUNTRYTO ='DE' CITYTO ='FRANKFURT' AIRPTO ='FRA' FLTIME ='725' DEPTIME ='133000' ARRTIME ='173500' DISTANCE ='9100.0000' DISTID ='KM' FLTYPE ='' PERIOD ='0'  )
* ( MANDT ='010' CARRID ='JL' CONNID ='0408' COUNTRYFR ='DE' CITYFROM ='FRANKFURT' AIRPFROM ='FRA' COUNTRYTO ='JP' CITYTO ='TOKYO' AIRPTO ='NRT' FLTIME ='675' DEPTIME ='202500' ARRTIME ='154000' DISTANCE ='9100.0000' DISTID ='KM' FLTYPE ='X' PERIOD ='1'
*)
* ( MANDT ='010' CARRID ='LH' CONNID ='0400' COUNTRYFR ='DE' CITYFROM ='FRANKFURT' AIRPFROM ='FRA' COUNTRYTO ='US' CITYTO ='NEW YORK' AIRPTO ='JFK' FLTIME ='444' DEPTIME ='101000' ARRTIME ='113400' DISTANCE ='6162.0000' DISTID ='KM' FLTYPE ='' PERIOD ='0'
*)
* ( MANDT ='010' CARRID ='LH' CONNID ='0401' COUNTRYFR ='US' CITYFROM ='NEW YORK' AIRPFROM ='JFK' COUNTRYTO ='DE' CITYTO ='FRANKFURT' AIRPTO ='FRA' FLTIME ='435' DEPTIME ='183000' ARRTIME ='074500' DISTANCE ='6162.0000' DISTID ='KM' FLTYPE ='' PERIOD ='1'
*)
* ( MANDT ='010' CARRID ='LH' CONNID ='0402' COUNTRYFR ='DE' CITYFROM ='FRANKFURT' AIRPFROM ='FRA' COUNTRYTO ='US' CITYTO ='NEW YORK' AIRPTO ='JFK' FLTIME ='455' DEPTIME ='133000' ARRTIME ='150500' DISTANCE ='6162.0000' DISTID ='KM' FLTYPE ='X' PERIOD =
*'0'  )
* ( MANDT ='010' CARRID ='LH' CONNID ='2402' COUNTRYFR ='DE' CITYFROM ='FRANKFURT' AIRPFROM ='FRA' COUNTRYTO ='DE' CITYTO ='BERLIN' AIRPTO ='SXF' FLTIME ='65' DEPTIME ='103000' ARRTIME ='113500' DISTANCE ='555.0000' DISTID ='KM' FLTYPE ='' PERIOD ='0'  )
* ( MANDT ='010' CARRID ='LH' CONNID ='2407' COUNTRYFR ='DE' CITYFROM ='BERLIN' AIRPFROM ='TXL' COUNTRYTO ='DE' CITYTO ='FRANKFURT' AIRPTO ='FRA' FLTIME ='65' DEPTIME ='071000' ARRTIME ='081500' DISTANCE ='555.0000' DISTID ='KM' FLTYPE ='' PERIOD ='0'  )
* ( MANDT ='010' CARRID ='QF' CONNID ='0005' COUNTRYFR ='SG' CITYFROM ='SINGAPORE' AIRPFROM ='SIN' COUNTRYTO ='DE' CITYTO ='FRANKFURT' AIRPTO ='FRA' FLTIME ='825' DEPTIME ='225000' ARRTIME ='053500' DISTANCE ='10000.0000' DISTID ='KM' FLTYPE ='' PERIOD =
*'1'  )
* ( MANDT ='010' CARRID ='QF' CONNID ='0006' COUNTRYFR ='DE' CITYFROM ='FRANKFURT' AIRPFROM ='FRA' COUNTRYTO ='SG' CITYTO ='SINGAPORE' AIRPTO ='SIN' FLTIME ='670' DEPTIME ='205500' ARRTIME ='150500' DISTANCE ='10000.0000' DISTID ='KM' FLTYPE ='' PERIOD =
*'1'  )
* ( MANDT ='010' CARRID ='SQ' CONNID ='0002' COUNTRYFR ='SG' CITYFROM ='SINGAPORE' AIRPFROM ='SIN' COUNTRYTO ='US' CITYTO ='SAN FRANCISCO' AIRPTO ='SFO' FLTIME ='1,105' DEPTIME ='170000' ARRTIME ='192500' DISTANCE ='8452.0000' DISTID ='MI' FLTYPE =''
*PERIOD ='0'  )
* ( MANDT ='010' CARRID ='SQ' CONNID ='0015' COUNTRYFR ='US' CITYFROM ='SAN FRANCISCO' AIRPFROM ='SFO' COUNTRYTO ='SG' CITYTO ='SINGAPORE' AIRPTO ='SIN' FLTIME ='1,125' DEPTIME ='160000' ARRTIME ='024500' DISTANCE ='8452.0000' DISTID ='MI' FLTYPE =''
*PERIOD ='2'  )
* ( MANDT ='010' CARRID ='SQ' CONNID ='0158' COUNTRYFR ='SG' CITYFROM ='SINGAPORE' AIRPFROM ='SIN' COUNTRYTO ='ID' CITYTO ='JAKARTA' AIRPTO ='JKT' FLTIME ='95' DEPTIME ='152500' ARRTIME ='160000' DISTANCE ='560.0000' DISTID ='MI' FLTYPE ='' PERIOD ='0'  )
* ( MANDT ='010' CARRID ='SQ' CONNID ='0988' COUNTRYFR ='SG' CITYFROM ='SINGAPORE' AIRPFROM ='SIN' COUNTRYTO ='JP' CITYTO ='TOKYO' AIRPTO ='TYO' FLTIME ='400' DEPTIME ='163500' ARRTIME ='121500' DISTANCE ='3125.0000' DISTID ='MI' FLTYPE ='' PERIOD ='1'  )
* ( MANDT ='010' CARRID ='UA' CONNID ='0941' COUNTRYFR ='DE' CITYFROM ='FRANKFURT' AIRPFROM ='FRA' COUNTRYTO ='US' CITYTO ='SAN FRANCISCO' AIRPTO ='SFO' FLTIME ='696' DEPTIME ='143000' ARRTIME ='170600' DISTANCE ='5685.0000' DISTID ='MI' FLTYPE ='' PERIOD
*='0'  )
* ( MANDT ='010' CARRID ='UA' CONNID ='3504' COUNTRYFR ='US' CITYFROM ='SAN FRANCISCO' AIRPFROM ='SFO' COUNTRYTO ='DE' CITYTO ='FRANKFURT' AIRPTO ='FRA' FLTIME ='630' DEPTIME ='150000' ARRTIME ='103000' DISTANCE ='5685.0000' DISTID ='MI' FLTYPE ='' PERIOD
*='1'  )
* ( MANDT ='010' CARRID ='UA' CONNID ='3516' COUNTRYFR ='US' CITYFROM ='NEW YORK' AIRPFROM ='JFK' COUNTRYTO ='DE' CITYTO ='FRANKFURT' AIRPTO ='FRA' FLTIME ='445' DEPTIME ='162000' ARRTIME ='054500' DISTANCE ='6162.0000' DISTID ='KM' FLTYPE ='' PERIOD ='1'
*)
* ( MANDT ='010' CARRID ='UA' CONNID ='3517' COUNTRYFR ='DE' CITYFROM ='FRANKFURT' AIRPFROM ='FRA' COUNTRYTO ='US' CITYTO ='NEW YORK' AIRPTO ='JFK' FLTIME ='495' DEPTIME ='104000' ARRTIME ='125500' DISTANCE ='6162.0000' DISTID ='KM' FLTYPE ='' PERIOD ='0'
*)
* )
* ).


if 1 = 0.
  delete from zsbook_row.
  insert zsbook_row  from ( select * from sbook ).
  commit work and wait.
endif.

select
from sbook
fields bookid
*where bookid = '00449461'
into table @data(lt_book_id).

select
from zsbook_row
fields bookid
*where bookid = '00449461'
into table @data(lt_book_id_row).


select
from sbook
fields bookid
where bookid = '01691295'
into table @lt_book_id.

select
from zsbook_row
fields bookid
where bookid = '01691295'
into table @lt_book_id_row.



select
from sbook
fields sum( cast( luggweight as dec( 20,4 ) ) ) as lugweightsum
*where bookid = '00449461'
into @data(lv_weight)
*group by connid
.

select
from sbook
fields sum( cast( luggweight as dec( 20,4 ) ) ) as lugweightsum
*where bookid = '00449461'
into @data(lv_weight_row).

*select *
*from zcds_test_table_function
*into table @data(lt_dummy5).

*data lt_spfli type standard table of spfli with empty key.


select
from spfli
fields *
into table @data(lt_spfli).

select
from @lt_spfli as flight_schedule
fields *
where airpfrom = 'TXL'
into table @data(lt_spfli_copy_from_txl) .

data lt_spfli_empty type standard table of spfli with empty key.

select spfli~*
from spfli
join @lt_spfli_empty as flight "empty table
        on flight~carrid = spfli~carrid
into table @data(lt_result).

"lt_result is empty but no dump

*select *
**from zcds_kal_test_001( p_test = 'ABC' )
*into table @data(lt_dummy2).

select *
from zdemo_c_sorderitem_vf
into table @data(lt_dummy3).


    endmethod.

  method sql_common_table_expression.



data from_id type spfli-carrid.
data to_id type spfli-carrid.

from_id = 'AA'.
to_id = 'LH'.

with
  +connections as (
    select spfli~carrid, carrname, connid, cityfrom, cityto
           from spfli
           inner join scarr
             on scarr~carrid = spfli~carrid
           where spfli~carrid between @from_id and @to_id ),
  +sum_seats as (
    select carrid, connid, sum( seatsocc ) as sum_seats
           from sflight
           where carrid between @from_id and @to_id
           group by carrid, connid ),
  +result( name, connection, departure, arrival, occupied ) as (
    select carrname, c~connid, cityfrom, cityto, sum_seats
           from +connections as c
             inner join +sum_seats as s
               on c~carrid = s~carrid and
                  c~connid = s~connid )
  select *
         from +result
         order by name, connection
         into table @data(result).



  endmethod.

  method conv.

    data lv_arbgb type c length 50.
    data lv_msgnr type c length 3.

    lv_arbgb = 'RP'.
    lv_msgnr = '001'.

    "Dump
    if 1 = 0.
      call function 'RP_READ_T100'
        exporting
          arbgb = lv_arbgb        " Arbeitsgebiet
          msgnr = lv_msgnr.       " Nachrichtennummer
    endif.

    "better
    call function 'RP_READ_T100'
      exporting
        arbgb = conv arbgb( lv_arbgb )        " Arbeitsgebiet
        msgnr = conv symsgno( lv_msgnr ).     " Nachrichtennummer


    "conv #
    data lv_string type string.
    data lv_text type c length 10.

    lv_string = conv string( lv_text ).

    "no
*    cl_abap_aab_utilities=>store_t100_message(
*        msgid  = lv_arbgb  " Nachrichtenklasse
*        msgno  = lv_msgnr   " Nachrichtennummer
*    ).

    "yes
    cl_abap_aab_utilities=>store_t100_message(
        msgid  = conv #( lv_arbgb )   " Nachrichtenklasse
        msgno  = conv #( lv_msgnr )   " Nachrichtennummer
    ).



  endmethod.

  method string_functions.

    "https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-US/abenprocess_functions.htm
    "http://www.cadaxo.com/high-class-development/abap-7-02-new-features-neue-stringfunktionen/

    "Instead of SPLIT AT
    data(lv_part1) = segment( val = 'Das ist ein Text'  sep = 'ein' index = 1 ).  "Das ist
    data(lv_part2) = segment( val = 'Das ist ein Text'  sep = 'ein' index = 2 ).  " Text


*SPLIT var AT '#' INTO var DATA(DUMMY).
    data(var) = `part1 # part2`.
    var = segment( val = var sep = `#` index = 1 ).

    "instead of SHIFT
    data(lv_trim1) = shift_left( '       test').
    data(lv_trim2) = shift_right( 'test         ').


    "instead of TO UPPER CASE
    data(lv_text1) = to_upper( 'kleinschreibung').
    "instead of TO LOWER CASE
    data(lv_text2) = to_upper( 'großschreibung').
    "first letter upper case
    data(lv_text3) = to_mixed( val = 'daimler AG' ). "Daimler AG


    "instead of  TRANSLATE … USING …
    lv_text1 = translate( val = 'ABCD' from = 'AC' to = 'YZ' ). "YBZD

    "reverse
    lv_text1 = reverse( 'PABA' ). "ABAP

    "insetad of REPLACE
    lv_text1 = replace( val = 'ABAP xx GOOD' off = 4 len = 4 with = 'IS' ). "ABAPISGOOD


    "cmax, cmin - character-like extreme value functions
    "condense - condense function
    "escape - escape function
    "insert - insert function
    "match - match function
    "repeat - repeat function
    "substring, substring_... - substring functions

    "concat_lines_of - concatenation function


  endmethod.

  method string_embedded_expressions.


    "https://help.sap.com/doc/abapdocu_750_index_htm/7.50/en-US/abapcompute_string_format_options.htm#!ABAP_ADDITION_12@12@

    data: lv_text type string.
    data: lv_vbeln type vbeln_vl value '0080003371'.

    "alpha
    lv_text = |Nr der Lieferung:{ lv_vbeln alpha = out }|.
    lv_text = |{ lv_vbeln alpha = in }|.

    " embedded expressions
*    [WIDTH     = len]
*    [ALIGN     = LEFT|RIGHT|CENTER|(val)]
*    [PAD       = c]
*    [CASE      = RAW|UPPER|LOWER|(val)]
*    [SIGN      = LEFT|LEFTPLUS|LEFTSPACE|RIGHT|RIGHTPLUS|RIGHTSPACE|(val)]
*    [EXPONENT  = exp]
*    [DECIMALS  = dec]
*    [ZERO      = YES|NO|(val)]
*    [XSD       = YES|NO|(val)]
*    [STYLE     =  SIMPLE|SIGN_AS_POSTFIX|SCALE_PRESERVING
*                 |SCIENTIFIC|SCIENTIFIC_WITH_LEADING_ZERO
*                 |SCALE_PRESERVING_SCIENTIFIC|ENGINEERING
*                 |(val)]
*    [CURRENCY  = cur]
*    [NUMBER    = RAW|USER|ENVIRONMENT|(val)]
*    [DATE      = RAW|ISO|USER|ENVIRONMENT|(val)]
*    [TIME      = RAW|ISO|USER|ENVIRONMENT|(val)]
*    [TIMESTAMP = SPACE|ISO|USER|ENVIRONMENT|(val)]
*    [TIMEZONE  = tz]
*    [COUNTRY   = cty] ...


    "Datum
    lv_text = |'Das aktuelle Datum { sy-datum date = environment }|. "RAW / ISO / USER
*    lv_text = |'Das aktuelle Datum { cl_abap_context_info=>get_system_date( ) DATE = ENVIRONMENT }|.

    "decimals
    data amount_field type netwr value '1234567.123'.
    lv_text = |{ amount_field  decimals = 1 }|.
    lv_text = |{ amount_field  number = user }|. "RAW / ENVIRONMENT / USER = SU01

    data currency_field type waerk.
    lv_text = |{ amount_field currency = currency_field  number = user }|. "RAW
    lv_text = |{ amount_field country = 'GB ' }|.

    "formatierung
    lv_text = |{ 'großschreiben' case = upper }|.
    lv_text = |{ amount_field sign = left }|. "left '-' withut '+'


  endmethod.

  method main.

*    Select *
*    from vbup
*    into table @data(lt_vbup)
*    up to 10 rows.
*


    lcl_new_abap_syntax=>conv(  ).
    lcl_new_abap_syntax=>value(  ).

    lcl_new_abap_syntax=>string(  ).
    lcl_new_abap_syntax=>string_functions(  ).
    lcl_new_abap_syntax=>string_embedded_expressions(  ).

    lcl_new_abap_syntax=>conditions(  ).

    lcl_new_abap_syntax=>internal_tables(  ).
    lcl_new_abap_syntax=>internal_tables_corresponding(  ).
    lcl_new_abap_syntax=>internal_tables_secondary_key(  ).

    lcl_new_abap_syntax=>let_and_reduce(  ).

    lcl_new_abap_syntax=>classes( ).
    lcl_new_abap_syntax=>exceptions(  ).

    lcl_new_abap_syntax=>other_features(  ).
    lcl_new_abap_syntax=>type_boxed(  ).
    lcl_new_abap_syntax=>enum(  ).

    lcl_new_abap_syntax=>good_examples(  ).

    lcl_new_abap_syntax=>sql_common_table_expression(  ).

  endmethod.


  method value.

    "struktur erzeugen
    data(ls_t100) = value t100( arbgb = 'MESSAGECLASS' msgnr = 100 sprsl = 'DE'  ).


    "tabelle erzeugen
    data(lt_bapi) = value bapiret2_tab(
                             ( number = '123' id = 'MESSAGECLASS'  type = 'E' )
                             ( number = '123' id = 'MESSAGECLASS'  type = 'E' )
                             ( number = '123' id = 'MESSAGECLASS'  type = 'E' )
                          ).
    "Range erzeugen
    data(lr_lgort) = value range_lgo(
        sign   = 'I'
        option = 'EQ'
        low    = '0100'
    ).

    "Rangetab erzeugen
    data(lr_r_matnr) = value ranges_matnr(
                            ( sign = 'I' option = 'EQ' low = '1234567' )
                            ( sign = 'I' option = 'EQ' low = '123sdfjh' )
                            ( sign = 'I' option = 'EQ' low = '243547' )
                            ).



    "typ aus kontext mit #
    lt_bapi = value #(  ( number = '123' id = 'MESSAGECLASS'  type = 'E' ) ).


    insert value #(
      number = '123'
      id     = 'MESSAGECLASS'
      type   = 'E'
      ) into table lt_bapi.


    insert value #(
      number = '123'
      id     = conv #(  'MESSAGECLASS' )
      type   = 'E'
      ) into table lt_bapi.



    data(l_result) = cl_abap_aab_utilities=>get_key( id = conv #( '123' ) ).


  endmethod.


  method classes.

    "erzeugen
    data(lo_grid) = new cl_gui_alv_grid( i_parent = cl_gui_container=>default_screen ).

    data(lo_alv) = new cl_gui_alv_grid( i_parent = new cl_gui_custom_container( 'CC_ALV') ).


    "method chaining
    data(lo_test) = new lcl_example(  ).

    lo_test->do_something(  )->do_something_else(  ).

    new lcl_example(  )->do_something(  )->do_something_else(  ).

    new cl_gui_alv_grid( i_parent = new cl_gui_custom_container( 'CC_ALV') )->free(  ).


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " casting

    data(lo_struct1) = cast cl_abap_structdescr( cl_abap_elemdescr=>describe_by_name( 'LTAP' ) ).

    data param type string.
    data(typedescr) = cl_abap_typedescr=>describe_by_data( param ).

    if typedescr is instance of cl_abap_elemdescr.
      data(elemdescr) = cast cl_abap_elemdescr( typedescr ).
      ...
    elseif typedescr is instance of cl_abap_structdescr.
      data(structdescr) = cast cl_abap_structdescr( typedescr ).
      ...
    elseif typedescr is instance of cl_abap_tabledescr.
      data(tabledescr) = cast cl_abap_tabledescr( typedescr ).
      ...
    else.
      ...
    endif.


    case type of cl_abap_elemdescr=>describe_by_name( 'LTAP' ).

      when type cl_abap_structdescr into data(lo_struct).

      when type cl_abap_tabledescr into data(lo_tab).

    endcase.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " interfaces

    "-> li_example_fail_ignore

  endmethod.


  method good_examples.

    "lcl_marc_proxy

  endmethod.

  method type_boxed.

    "http://zevolving.com/2013/02/what-is-new-type-category-type-boxed-in-abap/


    types:
      begin of lty_pox,
        pox type mepoitem_datax,
      end   of lty_pox.
    types:
      begin of lty_po,
        po  type ekko-ebeln,
        pox type lty_pox,
      end   of lty_po.
*
    data: lt_po type standard table of lty_po.
    data: ls_po like line of lt_po.
*
*---- ITAB Declared with BOXED TYPE
    types:
      begin of lty_pox_b,
        pox type mepoitem_datax boxed,    "<<
      end   of lty_pox_b.
    types:
      begin of lty_po_b,
        po  type ekko-ebeln,
        pox type lty_pox_b,
      end   of lty_po_b.
*
    data: lt_po_b type standard table of lty_po_b.
    data: ls_po_b like line of lt_po_b.
*
*
    data: ls_pox type lty_pox.

*-----
* Initial values in both Tables
*-----
    do 100 times.
      ls_po-po = sy-tabix.
      append ls_po to lt_po.
    enddo.
    do 100 times.
      ls_po_b-po = sy-tabix.
      append ls_po_b to lt_po_b.
    enddo.
    break-point.
*
*-----
* Update alternate 50 records
*-----
    field-symbols: <lfs_po_b> like line of lt_po_b.
    data: lv_flag type flag.
    loop at lt_po_b assigning <lfs_po_b>.
      if lv_flag = 'X'.
        <lfs_po_b>-pox-pox-loekz = 'X'.
        clear lv_flag.
      else.
        lv_flag = 'X'.
      endif.
    endloop.
    break-point.
*
*----
* rest 50 = total 100
*----
    lv_flag = 'X'.
    loop at lt_po_b assigning <lfs_po_b>.
      if lv_flag = 'X'.
        <lfs_po_b>-pox-pox-loekz = 'X'.
        clear lv_flag.
      else.
        lv_flag = 'X'.
      endif.
    endloop.
*------
* Check how Memory is consumed in Memory Analysis Tab.
*------
    break-point.
    write: 'done'.


  endmethod.

  method internal_tables_secondary_key.


    "http://zevolving.com/2013/03/abap-internal-table-secondary-keys-new-in-abap-7-0-ehp2/

    types:
      begin of ty_vbap,
        vbeln type vbap-vbeln,
        posnr type vbap-posnr,
        matnr type vbap-matnr,
        arktx type vbap-arktx,
        netpr type vbap-netpr,
        werks type vbap-werks,
      end   of ty_vbap.

    types:
      tt_vbap type standard table of ty_vbap
        with key vbeln posnr
        with non-unique sorted key matnr_werks components matnr werks.


    data t_vbap type tt_vbap.
    data itab type tt_vbap.

    read table t_vbap into data(ls_vbap)
      with key matnr_werks components
        matnr = ' '
        werks = ' '.
*
*
    loop at t_vbap into ls_vbap
                   using key matnr_werks
                   where matnr = ' '
                   and   werks = ' '.
    endloop.
*
*
    insert lines of t_vbap
      using key matnr_werks
      into itab index 1.
*
*
    append lines of t_vbap
      from 1 to 10
      using key matnr_werks
      to itab.
*
*
    modify t_vbap from ls_vbap
      using key matnr_werks
      transporting arktx
      where matnr = ' '
      and   werks = ' '.
*
*
    delete t_vbap
      using key matnr_werks
      where matnr = ' '
      and   werks = ' '.

  endmethod.

endclass.


start-of-selection.
  lcl_new_abap_syntax=>sql_power(  ).
*  lcl_new_abap_syntax=>main( ).
