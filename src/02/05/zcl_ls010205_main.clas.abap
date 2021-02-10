"! data generator - main class for mass data generation for the flight data model
"! author: Thorsten Schneider, status: completed
class zcl_ls010205_main definition
  public
  final
  create private .

  public section.

    constants sc_distid type s_distid value 'KM'.           "#EC NOTEXT
    constants sc_currcode type s_currcode value 'EUR'.      "#EC NOTEXT
    constants sc_economy type s_class value 'Y'.            "#EC NOTEXT
    constants sc_business type s_class value 'C'.           "#EC NOTEXT
    constants sc_first type s_class value 'F'.              "#EC NOTEXT
    constants sc_wunit type s_weiunit value 'KG'.           "#EC NOTEXT

    "! this method returns the singleton for the data generator
    class-methods get_instance
      returning
        value(rr_dg_main) type ref to zcl_ls010205_main
      raising
        zcl_ls010205_exception .
    "! this method starts the mass data generation for the flight data model
    methods generate_mass_data
      importing
        !iv_fldate_from type s_date
        !iv_fldate_to   type s_date
      raising
        zcl_ls010205_exception .
  protected section.
  private section.

    types:
      begin of ty_distribution_function,
        distribution_function type integer,
        lower_limit           type integer,
        upper_limit           type integer,
        delta                 type integer,
        accumulated           type integer,
      end   of ty_distribution_function .
    types:
      tt_distribution_function type sorted table of ty_distribution_function with unique key distribution_function lower_limit .
    types:
      begin of ty_distribution_index,
        distribution_function type integer,
        accumulated           type integer,
        lower_limit           type integer,
      end of ty_distribution_index .
    types:
      tt_distribution_index type hashed table of ty_distribution_index with unique key distribution_function accumulated .
    types:
      tt_sbook type sorted table of sbook with unique key carrid connid fldate bookid .
    types:
      begin of ty_customer,
        id type s_customer,
      end of ty_customer .
    types:
      tt_customer type standard table of ty_customer .
    types:
      begin of ty_agency,
        agencynum type s_agncynum,
      end of ty_agency .
    types:
      tt_agency type standard table of ty_agency .

    "! static attribute for singleton
    class-data sr_dg_main type ref to zcl_ls010205_main .
    data mr_random_connection_price type ref to cl_abap_random_int .
    data mr_random_connection_util type ref to cl_abap_random_int .
    data mr_random_flight_util type ref to cl_abap_random_int .
    data mr_random_planetype type ref to cl_abap_random_int .
    data mr_random_distr_function type ref to cl_abap_random_int .
    data mr_random_customer_id type ref to cl_abap_random_int .
    data mr_random_agency type ref to cl_abap_random_int .
    data mr_random_order_date type ref to cl_abap_random_int .
    data mr_random_counter_or_agency type ref to cl_abap_random_int .
    data mr_random_weight type ref to cl_abap_random_int .
    data mr_random_cancelled type ref to cl_abap_random_int .
    data mr_random_invoiced type ref to cl_abap_random_int .
    data mt_distribution_function type tt_distribution_function .
    data mt_distribution_index type tt_distribution_index .
    data mt_customer type tt_customer .
    data mt_agency type tt_agency .

    methods generate_flights
      importing
        !iv_fldate_from type s_date
        !iv_fldate_to   type s_date
      raising
        zcl_ls010205_exception .
    methods generate_bookings
      raising
        zcl_ls010205_exception .
    methods generate_bookings_for_flights
      importing
        !is_spfli type spfli
      raising
        zcl_ls010205_exception .
    methods generate_bookings_for_class
      importing
        !is_spfli                 type spfli
        !iv_class                 type s_class
        !iv_distribution_function type i
      changing
        !cs_sflight               type sflight
        !ct_sbook                 type tt_sbook
      raising
        zcl_ls010205_exception .
    methods determine_connection_price
      importing
        !iv_distance      type s_distance
        !iv_distance_unit type s_distid
        !iv_currency      type s_currcode
      returning
        value(rv_price)   type s_price
      raising
        zcl_ls010205_exception .
    methods determine_flight_price
      importing
        !iv_price       type s_price
        !iv_currency    type s_currcode
        !iv_fldate      type s_date
      returning
        value(rv_price) type s_price
      raising
        zcl_ls010205_exception .
    methods determine_planetype
      importing
        !iv_distance        type s_distance
        !iv_distance_unit   type s_distid
      returning
        value(rv_planetype) type s_planetye
      raising
        zcl_ls010205_exception .
    methods determine_connection_seatsocc
      importing
        !iv_seatsmax   type s_seatsmax
        !iv_seatsmax_b type s_smax_b
        !iv_seatsmax_f type s_smax_f
      exporting
        !ev_seatsocc   type s_seatsocc
        !ev_seatsocc_b type s_socc_b
        !ev_seatsocc_f type s_socc_f
      raising
        zcl_ls010205_exception .
    methods determine_flight_seatsocc
      importing
        !iv_seatsmax   type s_seatsmax
        !iv_seatsmax_b type s_smax_b
        !iv_seatsmax_f type s_smax_f
        !iv_seatsocc   type s_seatsocc
        !iv_seatsocc_b type s_socc_b
        !iv_seatsocc_f type s_socc_f
        !iv_fldate     type s_date
      exporting
        !ev_seatsocc   type s_seatsocc
        !ev_seatsocc_b type s_socc_b
        !ev_seatsocc_f type s_socc_f
      raising
        zcl_ls010205_exception .
    methods adapt_flight_seatsocc
      importing
        !iv_seatsocc              type s_seatsocc
        !iv_seatsocc_b            type s_socc_b
        !iv_seatsocc_f            type s_socc_f
        !iv_fldate                type s_date
        !iv_distribution_function type i
      exporting
        !ev_seatsocc              type s_seatsocc
        !ev_seatsocc_b            type s_socc_b
        !ev_seatsocc_f            type s_socc_f
      raising
        zcl_ls010205_exception .
    methods determine_counter
      importing
        !is_spfli         type spfli
      returning
        value(rv_counter) type s_countnum
      raising
        zcl_ls010205_exception .
    methods determine_agency
      exporting
        !ev_agencynum type s_agncynum
        !ev_currency  type s_curr_ag
      raising
        zcl_ls010205_exception .
    methods constructor
      raising
        zcl_ls010205_exception .
ENDCLASS.



CLASS ZCL_LS010205_MAIN IMPLEMENTATION.


  method adapt_flight_seatsocc.
    data: lv_duration_to_fldate type i,
          lv_lower_limit        type i.

    field-symbols: <ls_distribution_function> type ty_distribution_function.

*   initialization
    clear: ev_seatsocc,
           ev_seatsocc_b,
           ev_seatsocc_f.

    if iv_fldate <= sy-datum.
      ev_seatsocc = iv_seatsocc.
      ev_seatsocc_b = iv_seatsocc_b.
      ev_seatsocc_f = iv_seatsocc_f.
    else.
      lv_duration_to_fldate = iv_fldate - sy-datum.
      lv_lower_limit = ( lv_duration_to_fldate div 10 ) * 10 + 1.

      read table mt_distribution_function assigning <ls_distribution_function>
           with table key distribution_function = iv_distribution_function
                          lower_limit = lv_lower_limit.
      if not sy-subrc is initial.
        clear: ev_seatsocc,
               ev_seatsocc_b,
               ev_seatsocc_f.
      else.
        ev_seatsocc = round( val = iv_seatsocc * ( <ls_distribution_function>-accumulated / 100 ) dec = 0 ).
        if ev_seatsocc > iv_seatsocc.
          ev_seatsocc = iv_seatsocc.
        endif.
        ev_seatsocc_b = round( val = iv_seatsocc_b * ( <ls_distribution_function>-accumulated / 100 ) dec = 0 ).
        if ev_seatsocc_b > iv_seatsocc_b.
          ev_seatsocc_b = iv_seatsocc_b.
        endif.
        ev_seatsocc_f = round( val = iv_seatsocc_f * ( <ls_distribution_function>-accumulated / 100 ) dec = 0 ).
        if ev_seatsocc_f > iv_seatsocc_f.
          ev_seatsocc_f = iv_seatsocc_f.
        endif.
      endif.
    endif.

  endmethod.


  method constructor.

    data:
      lv_min_id                type i,
      lv_max_id                type i,
      lv_distribution_function type i,
      lv_accumulated           type i,
      ls_distribution_index    type ty_distribution_index.

    field-symbols: <ls_distribution_function> type ty_distribution_function.

    try.
        mr_random_connection_price = cl_abap_random_int=>create( seed = 999 min = 80 max = 120 ).
        mr_random_connection_util = cl_abap_random_int=>create( seed = 999 min = 70 max = 90 ).
        mr_random_flight_util = cl_abap_random_int=>create( seed = 999 min = 90 max = 110 ).
        mr_random_planetype = cl_abap_random_int=>create( seed = 999 min = 0 max = 3 ).

        mr_random_distr_function = cl_abap_random_int=>create( seed = 999 min = 1 max = 3 ).

        select id from scustom into corresponding fields of table mt_customer.
        lv_min_id = 1.
        lv_max_id = lines( mt_customer ).
        mr_random_customer_id = cl_abap_random_int=>create( seed = 999 min = lv_min_id max = lv_max_id ).

        select agencynum from stravelag into corresponding fields of table mt_agency.
        lv_min_id = 1.
        lv_max_id = lines( mt_agency ).
        mr_random_agency = cl_abap_random_int=>create( seed = 999 min = lv_min_id max = lv_max_id ).

        mr_random_order_date = cl_abap_random_int=>create( seed = 999 min = 0 max = 9 ).
        mr_random_counter_or_agency = cl_abap_random_int=>create( seed = 999 min = 0 max = 1 ).
        mr_random_weight = cl_abap_random_int=>create( seed = 999 min = 0 max = 30 ).
        mr_random_cancelled = cl_abap_random_int=>create( seed = 999 min = 0 max = 9 ).
        mr_random_invoiced = cl_abap_random_int=>create( seed = 999 min = 0 max = 1 ).

      catch cx_abap_random.
*       Internal Error: &1
        message a000(za4h_book_dg) with 'CONSTRUCTOR' into data(lv_null). "#EC NEEDED
        zcl_010205_service=>add_message( iv_msgty = 'A' iv_msgno = '000' iv_msgv1 = 'CONSTRUCTOR' ).
        raise exception type zcl_ls010205_exception.
    endtry.

    mt_distribution_function = value tt_distribution_function( ( distribution_function = 1 lower_limit = 001 upper_limit = 010 delta = 03 accumulated = 003 )
                                                               ( distribution_function = 1 lower_limit = 011 upper_limit = 020 delta = 03 accumulated = 006 )
                                                               ( distribution_function = 1 lower_limit = 021 upper_limit = 030 delta = 03 accumulated = 009 )
                                                               ( distribution_function = 1 lower_limit = 031 upper_limit = 040 delta = 05 accumulated = 014 )
                                                               ( distribution_function = 1 lower_limit = 041 upper_limit = 050 delta = 05 accumulated = 019 )
                                                               ( distribution_function = 1 lower_limit = 051 upper_limit = 060 delta = 07 accumulated = 026 )
                                                               ( distribution_function = 1 lower_limit = 061 upper_limit = 070 delta = 07 accumulated = 033 )
                                                               ( distribution_function = 1 lower_limit = 071 upper_limit = 080 delta = 07 accumulated = 040 )
                                                               ( distribution_function = 1 lower_limit = 081 upper_limit = 090 delta = 09 accumulated = 049 )
                                                               ( distribution_function = 1 lower_limit = 091 upper_limit = 100 delta = 09 accumulated = 058 )
                                                               ( distribution_function = 1 lower_limit = 101 upper_limit = 110 delta = 07 accumulated = 065 )
                                                               ( distribution_function = 1 lower_limit = 111 upper_limit = 120 delta = 07 accumulated = 072 )
                                                               ( distribution_function = 1 lower_limit = 121 upper_limit = 130 delta = 07 accumulated = 079 )
                                                               ( distribution_function = 1 lower_limit = 131 upper_limit = 140 delta = 05 accumulated = 084 )
                                                               ( distribution_function = 1 lower_limit = 141 upper_limit = 150 delta = 05 accumulated = 089 )
                                                               ( distribution_function = 1 lower_limit = 151 upper_limit = 160 delta = 05 accumulated = 094 )
                                                               ( distribution_function = 1 lower_limit = 161 upper_limit = 170 delta = 03 accumulated = 097 )
                                                               ( distribution_function = 1 lower_limit = 171 upper_limit = 180 delta = 03 accumulated = 100 )

                                                               ( distribution_function = 2 lower_limit = 001 upper_limit = 010 delta = 06 accumulated = 006 )
                                                               ( distribution_function = 2 lower_limit = 011 upper_limit = 020 delta = 06 accumulated = 012 )
                                                               ( distribution_function = 2 lower_limit = 021 upper_limit = 030 delta = 05 accumulated = 017 )
                                                               ( distribution_function = 2 lower_limit = 031 upper_limit = 040 delta = 06 accumulated = 023 )
                                                               ( distribution_function = 2 lower_limit = 041 upper_limit = 050 delta = 05 accumulated = 028 )
                                                               ( distribution_function = 2 lower_limit = 051 upper_limit = 060 delta = 05 accumulated = 033 )
                                                               ( distribution_function = 2 lower_limit = 061 upper_limit = 070 delta = 06 accumulated = 039 )
                                                               ( distribution_function = 2 lower_limit = 071 upper_limit = 080 delta = 06 accumulated = 045 )
                                                               ( distribution_function = 2 lower_limit = 081 upper_limit = 090 delta = 05 accumulated = 050 )
                                                               ( distribution_function = 2 lower_limit = 091 upper_limit = 100 delta = 06 accumulated = 056 )
                                                               ( distribution_function = 2 lower_limit = 101 upper_limit = 110 delta = 05 accumulated = 061 )
                                                               ( distribution_function = 2 lower_limit = 111 upper_limit = 120 delta = 05 accumulated = 066 )
                                                               ( distribution_function = 2 lower_limit = 121 upper_limit = 130 delta = 06 accumulated = 072 )
                                                               ( distribution_function = 2 lower_limit = 131 upper_limit = 140 delta = 06 accumulated = 078 )
                                                               ( distribution_function = 2 lower_limit = 141 upper_limit = 150 delta = 05 accumulated = 083 )
                                                               ( distribution_function = 2 lower_limit = 151 upper_limit = 160 delta = 06 accumulated = 089 )
                                                               ( distribution_function = 2 lower_limit = 161 upper_limit = 170 delta = 06 accumulated = 095 )
                                                               ( distribution_function = 2 lower_limit = 171 upper_limit = 180 delta = 05 accumulated = 100 )

                                                               ( distribution_function = 3 lower_limit = 001 upper_limit = 010 delta = 01 accumulated = 001 )
                                                               ( distribution_function = 3 lower_limit = 011 upper_limit = 020 delta = 01 accumulated = 002 )
                                                               ( distribution_function = 3 lower_limit = 021 upper_limit = 030 delta = 03 accumulated = 005 )
                                                               ( distribution_function = 3 lower_limit = 031 upper_limit = 040 delta = 03 accumulated = 008 )
                                                               ( distribution_function = 3 lower_limit = 041 upper_limit = 050 delta = 03 accumulated = 011 )
                                                               ( distribution_function = 3 lower_limit = 051 upper_limit = 060 delta = 03 accumulated = 014 )
                                                               ( distribution_function = 3 lower_limit = 061 upper_limit = 070 delta = 05 accumulated = 019 )
                                                               ( distribution_function = 3 lower_limit = 071 upper_limit = 080 delta = 05 accumulated = 024 )
                                                               ( distribution_function = 3 lower_limit = 081 upper_limit = 090 delta = 05 accumulated = 029 )
                                                               ( distribution_function = 3 lower_limit = 091 upper_limit = 100 delta = 05 accumulated = 034 )
                                                               ( distribution_function = 3 lower_limit = 101 upper_limit = 110 delta = 05 accumulated = 039 )
                                                               ( distribution_function = 3 lower_limit = 111 upper_limit = 120 delta = 07 accumulated = 046 )
                                                               ( distribution_function = 3 lower_limit = 121 upper_limit = 130 delta = 07 accumulated = 053 )
                                                               ( distribution_function = 3 lower_limit = 131 upper_limit = 140 delta = 07 accumulated = 060 )
                                                               ( distribution_function = 3 lower_limit = 141 upper_limit = 150 delta = 10 accumulated = 070 )
                                                               ( distribution_function = 3 lower_limit = 151 upper_limit = 160 delta = 10 accumulated = 080 )
                                                               ( distribution_function = 3 lower_limit = 161 upper_limit = 170 delta = 10 accumulated = 090 )
                                                               ( distribution_function = 3 lower_limit = 171 upper_limit = 180 delta = 10 accumulated = 100 ) ).

    do 3 times.
      lv_distribution_function = sy-index.
      lv_accumulated = 0.
      loop at mt_distribution_function assigning <ls_distribution_function>
              where distribution_function = lv_distribution_function.
        do <ls_distribution_function>-delta times.
          lv_accumulated = lv_accumulated + 1.
          clear ls_distribution_index.
          ls_distribution_index-distribution_function = lv_distribution_function.
          ls_distribution_index-accumulated = lv_accumulated.
          ls_distribution_index-lower_limit = <ls_distribution_function>-lower_limit.
          insert ls_distribution_index into table mt_distribution_index.
        enddo.
      endloop.
    enddo.

  endmethod.


  method determine_agency.

    data: lv_agency_index type s_customer,
          ls_stravelag    type stravelag.

    lv_agency_index = mr_random_agency->get_next( ).
    read table mt_agency into data(ls_agency)
         index lv_agency_index.

    select single * from stravelag into ls_stravelag
           where agencynum = ls_agency-agencynum.
    if not sy-subrc is initial.
*     Internal Error: &1
      message a000(za4h_book_dg) with 'DETERMINE_AGENCY' into data(lv_null). "#EC NEEDED
      zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '000' iv_msgv1 = 'DETERMINE_AGENCY' ).
      raise exception type zcl_ls010205_exception.
    else.
      ev_agencynum = ls_stravelag-agencynum.
      ev_currency = ls_stravelag-currency.
    endif.

  endmethod.


  method determine_connection_price.
    data: lv_distance type s_distance,
          lv_price    type s_price.

    clear rv_price.

    if iv_distance_unit = sc_distid.
      lv_distance = iv_distance.
    else.
      call function 'UNIT_CONVERSION_SIMPLE'
        exporting
          input                = iv_distance
          unit_in              = iv_distance_unit
          unit_out             = sc_distid
        importing
          output               = lv_distance
        exceptions
          conversion_not_found = 1
          division_by_zero     = 2
          input_invalid        = 3
          output_invalid       = 4
          overflow             = 5
          type_invalid         = 6
          units_missing        = 7
          unit_in_not_found    = 8
          unit_out_not_found   = 9
          others               = 10.
      if not sy-subrc is initial.
*       Internal Error: &1
        message a000(za4h_book_dg) with 'DETERMINE_CONNECTION_PRICE' into data(lv_null). "#EC NEEDED
        zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '000' iv_msgv1 = 'DETERMINE_CONNECTION_PRICE' ).
        raise exception type zcl_ls010205_exception.
      endif.
    endif.

*   700 EUR base, 0.10 EUR per kilometer, random 'fluctuation' +/- 20%
    lv_price = round( val = 700 + lv_distance * '0.10' * ( mr_random_connection_price->get_next( ) / 100 ) dec = 2 ).

    if iv_currency = sc_currcode.
      rv_price = lv_price.
    else.
      call function 'SAPBC_GLOBAL_FOREIGN_CURRENCY'
        exporting
          local_amount     = lv_price
          local_currency   = sc_currcode
          foreign_currency = iv_currency
        importing
          foreign_amount   = rv_price
        exceptions
          overflow         = 1
          no_factors_found = 2
          invalid_curr_key = 3
          others           = 4.
      if not sy-subrc is initial.
*       Currency conversion from &1 to &2 failed
        message a003(za4h_book_dg) with sc_currcode iv_currency into lv_null.
        zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '003' iv_msgv1 = sc_currcode iv_msgv2 = iv_currency ).
        raise exception type zcl_ls010205_exception.
      endif.
    endif.
  endmethod.


  method determine_connection_seatsocc.
    clear: ev_seatsocc,
           ev_seatsocc_b,
           ev_seatsocc_f.

*   the utilization is a random value. It is determined per class
    ev_seatsocc = round( val = iv_seatsmax * ( mr_random_connection_util->get_next( ) / 100 ) dec = 0 ).
    if ev_seatsocc > iv_seatsmax.
      ev_seatsocc = iv_seatsmax.
    endif.
    ev_seatsocc_b = round( val = iv_seatsmax_b * ( mr_random_connection_util->get_next( ) / 100 ) dec = 0 ).
    if ev_seatsocc_b > iv_seatsmax_b.
      ev_seatsocc_b = iv_seatsmax_b.
    endif.
    ev_seatsocc_f = round( val = iv_seatsmax_f * ( mr_random_connection_util->get_next( ) / 100 ) dec = 0 ).
    if ev_seatsocc_f > iv_seatsmax_f.
      ev_seatsocc_f = iv_seatsmax_f.
    endif.

  endmethod.


  method determine_counter.

    clear rv_counter.
*   use 'first' counter for departure airport
    select single countnum into rv_counter
           from scounter
           where carrid = is_spfli-carrid
             and airport = is_spfli-airpfrom.
    if not sy-subrc is initial.
*     use 'first' counter for arrival airport
      select single countnum into rv_counter
             from scounter
             where carrid = is_spfli-carrid
               and airport = is_spfli-airpto.
      if not sy-subrc is initial.
*       use any counter the airline has
        select single countnum into rv_counter
               from scounter
               where carrid = is_spfli-carrid.

*       Internal Error: &1
        message a000(za4h_book_dg) with 'DETERMINE_COUNTER' into data(lv_null). "#EC NEEDED
        zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '000' iv_msgv1 = 'DETERMINE_COUNTER' ).
        raise exception type zcl_ls010205_exception.
      endif.
    endif.

  endmethod.


  method determine_flight_price.
    data: lv_fldate type s_date.

    clear rv_price.

    lv_fldate(4) = '9999'.
    lv_fldate+4(4) = iv_fldate+4(4).

    if ( lv_fldate >= '99991215' and lv_fldate <= '99991231' ) or
       ( lv_fldate >= '99990101' and lv_fldate <= '99990115').
*     Christmas
      rv_price = round( val = iv_price * '1.3' dec = 2 ).
    elseif ( lv_fldate >= '99990315' and lv_fldate <= '99990415' ).
*     Easter (we could improve the calculation by using the public holiday calendar, for the time being we keep it simple)
      rv_price = round( val = iv_price * '1.1' dec = 2 ).
    elseif ( lv_fldate >= '99990701' and lv_fldate <= '99990831' ).
*     Summer
      rv_price = round( val = iv_price * '1.2' dec = 2 ).
    else.
*     all other cases
      rv_price = iv_price.
    endif.
  endmethod.


  method determine_flight_seatsocc.
    data: lv_fldate type s_date.

    clear: ev_seatsocc,
           ev_seatsocc_b,
           ev_seatsocc_f.

    lv_fldate(4) = '9999'.
    lv_fldate+4(4) = iv_fldate+4(4).

    if ( lv_fldate >= '99991215' and lv_fldate <= '99991231' ) or
       ( lv_fldate >= '99990101' and lv_fldate <= '99990115').
*     Christmas
      ev_seatsocc = round( val = iv_seatsocc * '1.15' dec = 0 ).
      ev_seatsocc_b = round( val = iv_seatsocc_b * '1.15' dec = 0 ).
      ev_seatsocc_f = round( val = iv_seatsocc_f * '1.15' dec = 0 ).
    elseif ( lv_fldate >= '99990315' and lv_fldate <= '99990415' ).
*     Easter (we could improve the calculation by using the public holiday calendar, for the time being we keep it simple)
      ev_seatsocc = round( val = iv_seatsocc * '1.05' dec = 0 ).
      ev_seatsocc_b = round( val = iv_seatsocc_b * '1.05' dec = 0 ).
      ev_seatsocc_f = round( val = iv_seatsocc_f * '1.05' dec = 0 ).
    elseif ( lv_fldate >= '99990701' and lv_fldate <= '99990831' ).
*     Summer
      ev_seatsocc = round( val = iv_seatsocc * '1.10' dec = 0 ).
      ev_seatsocc_b = round( val = iv_seatsocc_b * '1.10' dec = 0 ).
      ev_seatsocc_f = round( val = iv_seatsocc_f * '1.10' dec = 0 ).
    else.
*     all other cases
      ev_seatsocc = iv_seatsocc.
      ev_seatsocc_b = iv_seatsocc_b.
      ev_seatsocc_f = iv_seatsocc_f.
    endif.

    ev_seatsocc = round( val = ev_seatsocc * ( mr_random_flight_util->get_next( ) / 100 ) dec = 0 ).
    if ev_seatsocc > iv_seatsmax.
      ev_seatsocc = iv_seatsmax.
    endif.
    ev_seatsocc_b = round( val = ev_seatsocc_b * ( mr_random_flight_util->get_next( ) / 100 ) dec = 0 ).
    if ev_seatsocc_b > iv_seatsmax_b.
      ev_seatsocc_b = iv_seatsmax_b.
    endif.
    ev_seatsocc_f = round( val = ev_seatsocc_f * ( mr_random_flight_util->get_next( ) / 100 ) dec = 0 ).
    if ev_seatsocc_f > iv_seatsmax_f.
      ev_seatsocc_f = iv_seatsmax_f.
    endif.

  endmethod.


  method determine_planetype.
    data: lv_distance type s_distance.

    clear rv_planetype.

    if iv_distance_unit = sc_distid.
      lv_distance = iv_distance.
    else.
      call function 'UNIT_CONVERSION_SIMPLE'
        exporting
          input                = iv_distance
          unit_in              = iv_distance_unit
          unit_out             = sc_distid
        importing
          output               = lv_distance
        exceptions
          conversion_not_found = 1
          division_by_zero     = 2
          input_invalid        = 3
          output_invalid       = 4
          overflow             = 5
          type_invalid         = 6
          units_missing        = 7
          unit_in_not_found    = 8
          unit_out_not_found   = 9
          others               = 10.
      if not sy-subrc is initial.
*       Internal Error: &1
        message a000(za4h_book_dg) with 'DETERMINE_PLANETYPE' into data(lv_null). "#EC NEEDED
        zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '000' iv_msgv1 = 'DETERMINE_CONNECTION_PRICE' ).
        raise exception type zcl_ls010205_exception.
      endif.
    endif.

    if lv_distance > 1500.
      case mr_random_planetype->get_next( ).
        when 0.
          rv_planetype = '747-400'.
        when 1.
          rv_planetype = 'A310-300'.
        when 2.
          rv_planetype = 'A319'.
        when 3.
          rv_planetype = 'DC-10-10'.
      endcase.
    else.
      case mr_random_planetype->get_next( ).
        when 0.
          rv_planetype = '727-200'.
        when 1.
          rv_planetype = '737-200'.
        when 2.
          rv_planetype = 'A319'.
        when 3.
          rv_planetype = 'A321'.
      endcase.
    endif.

  endmethod.


  method generate_bookings.

    data: lt_spfli type standard table of spfli.
    field-symbols: <ls_spfli> type spfli.

    select * from spfli into table lt_spfli.

    loop at lt_spfli assigning <ls_spfli>.
      generate_bookings_for_flights( is_spfli =  <ls_spfli> ).
    endloop.

  endmethod.


  method generate_bookings_for_class.
    data: lv_seatsocc       type s_seatsocc,
          lv_bookings       type s_seatsocc,
          ls_sbook          type sbook,
          lv_customer_index type s_customer,
          ls_scustom        type scustom,
          lv_percentage     type decimals,
          lv_accumulated    type integer.

    field-symbols: <ls_distribution_index>    type ty_distribution_index,
                   <ls_distribution_function> type ty_distribution_function.

    case iv_class.
      when sc_economy.
        lv_seatsocc = cs_sflight-seatsocc.
      when sc_business.
        lv_seatsocc = cs_sflight-seatsocc_b.
      when sc_first.
        lv_seatsocc = cs_sflight-seatsocc_f.
      when others.
*       Internal Error: &1
        message a000(za4h_book_dg) with 'GENERATE_BOOKINGS_FOR_CLASS' into data(lv_null). "#EC NEEDED
        zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '000' iv_msgv1 = 'GENERATE_BOOKINGS_FOR_CLASS' ).
        raise exception type zcl_ls010205_exception.
    endcase.

    while lv_bookings < lv_seatsocc.
      clear ls_sbook.
      ls_sbook-carrid = cs_sflight-carrid.
      ls_sbook-connid = cs_sflight-connid.
      ls_sbook-fldate = cs_sflight-fldate.

      call function 'NUMBER_GET_NEXT'
        exporting
          nr_range_nr             = '01'
          object                  = 'SBOOKID'
          subobject               = ls_sbook-carrid
        importing
          number                  = ls_sbook-bookid
        exceptions
          interval_not_found      = 1
          number_range_not_intern = 2
          object_not_found        = 3
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          buffer_overflow         = 7
          others                  = 8.
      if not sy-subrc is initial.
*       Internal Error: &1
        message a000(za4h_book_dg) with 'GENERATE_BOOKINGS_FOR_CLASS' into lv_null.
        zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '000' iv_msgv1 = 'GENERATE_BOOKINGS_FOR_CLASS' ).
        raise exception type zcl_ls010205_exception.
      endif.

      lv_customer_index = mr_random_customer_id->get_next( ).
      read table mt_customer into data(ls_customer)
           index lv_customer_index.

      select single * from scustom into ls_scustom
             where id = ls_customer-id.
      if not sy-subrc is initial.
*       Internal Error: &1
        message a000(za4h_book_dg) with 'GENERATE_BOOKINGS_FOR_CLASS' into lv_null.
        zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '000' iv_msgv1 = 'GENERATE_BOOKINGS_FOR_CLASS' ).
        raise exception type zcl_ls010205_exception.
      endif.

      ls_sbook-customid = ls_scustom-id.
      ls_sbook-custtype = ls_scustom-custtype.
      ls_sbook-smoker = space.
      ls_sbook-luggweight = mr_random_weight->get_next( ).
      ls_sbook-wunit = sc_wunit.
      ls_sbook-passname = ls_scustom-name.
      ls_sbook-passform = ls_scustom-form.
      ls_sbook-passbirth = space.
      ls_sbook-class = iv_class.

      if mr_random_counter_or_agency->get_next( ) = 0.
*       booking done via counter
        ls_sbook-counter = determine_counter( is_spfli = is_spfli ).
        ls_sbook-forcurkey = cs_sflight-currency.
      else.
*       booking done via agency
        determine_agency(
          importing
            ev_agencynum = ls_sbook-agencynum
            ev_currency = ls_sbook-forcurkey ).
      endif.

      ls_sbook-loccuram = round( val = cs_sflight-price * ( ( 100 - ls_scustom-discount ) / 100 ) dec = 2 ).
      if iv_class = sc_business.
        ls_sbook-loccuram = ls_sbook-loccuram * 3.
      elseif iv_class = sc_first.
        ls_sbook-loccuram = ls_sbook-loccuram * 5.
      endif.
      ls_sbook-loccurkey = cs_sflight-currency.

      if ls_sbook-loccurkey = ls_sbook-forcurkey.
        ls_sbook-forcuram = ls_sbook-loccuram.
      else.
        call function 'SAPBC_GLOBAL_FOREIGN_CURRENCY'
          exporting
            local_amount     = ls_sbook-loccuram
            local_currency   = ls_sbook-loccurkey
            foreign_currency = ls_sbook-forcurkey
          importing
            foreign_amount   = ls_sbook-forcuram
          exceptions
            overflow         = 1
            no_factors_found = 2
            invalid_curr_key = 3
            others           = 4.
        if not sy-subrc is initial.
*         Internal Error: &1
          message a000(za4h_book_dg) with 'GENERATE_BOOKINGS_FOR_CLASS' into lv_null.
          zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '000' iv_msgv1 = 'GENERATE_BOOKINGS_FOR_CLASS' ).
          raise exception type zcl_ls010205_exception.
        endif.
      endif.

      lv_percentage = ( ( lv_bookings + 1 ) / lv_seatsocc ) * 100.
      lv_accumulated = lv_percentage.
      if lv_accumulated < 1.
        lv_accumulated = 1.
      elseif lv_accumulated > 100.
        lv_accumulated = 100.
      endif.

      read table mt_distribution_index assigning <ls_distribution_index>
           with table key distribution_function = iv_distribution_function
                          accumulated = lv_accumulated.
      if not sy-subrc is initial.
*       Internal Error: &1
        message a000(za4h_book_dg) with 'GENERATE_BOOKINGS_FOR_CLASS' into lv_null.
        zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '000' iv_msgv1 = 'GENERATE_BOOKINGS_FOR_CLASS' ).
        raise exception type zcl_ls010205_exception.
      else.
        read table mt_distribution_function assigning <ls_distribution_function>
             with table key distribution_function = iv_distribution_function
                            lower_limit = <ls_distribution_index>-lower_limit.
        if not sy-subrc is initial.
*         Internal Error: &1
          message a000(za4h_book_dg) with 'GENERATE_BOOKINGS_FOR_CLASS' into lv_null.
          zcl_010205_service=>add_message( iv_msgty = 'E' iv_msgno = '000' iv_msgv1 = 'GENERATE_BOOKINGS_FOR_CLASS' ).
          raise exception type zcl_ls010205_exception.
        endif.
      endif.

      ls_sbook-order_date = ls_sbook-fldate - 180 + <ls_distribution_function>-lower_limit + mr_random_order_date->get_next( ).

      if mr_random_cancelled->get_next( ) = 0.
*       10% of the bookings are cancelled
        ls_sbook-cancelled = abap_true.
      else.
        if ls_sbook-fldate < sy-datum.
*         all bookings in the past are invoiced
          ls_sbook-invoice = abap_true.
        else.
          if not mr_random_invoiced->get_next( ) = 0.
*           50% of the bookings in the future are invoiced
            ls_sbook-invoice = abap_true.
          endif.
        endif.
        cs_sflight-paymentsum = cs_sflight-paymentsum + ls_sbook-loccuram.
        lv_bookings = lv_bookings + 1.
      endif.

      insert ls_sbook into table ct_sbook.
    endwhile.

  endmethod.


  method generate_bookings_for_flights.

    data: lt_sflight               type standard table of sflight,
          ls_sflight_new           type sflight,
          lv_distribution_function type i,
          lt_sbook                 type sorted table of sbook with unique key carrid connid fldate bookid.

    field-symbols: <ls_sflight_old> type sflight.

*   read all flights
    select * from sflight into table lt_sflight
             where carrid = is_spfli-carrid
               and connid = is_spfli-connid.

    loop at lt_sflight assigning <ls_sflight_old>.
      ls_sflight_new = <ls_sflight_old>.

*     determine distribution function
      lv_distribution_function = mr_random_distr_function->get_next( ).

      adapt_flight_seatsocc(
        exporting
          iv_seatsocc = <ls_sflight_old>-seatsocc
          iv_seatsocc_b = <ls_sflight_old>-seatsocc_b
          iv_seatsocc_f = <ls_sflight_old>-seatsocc_f
          iv_fldate = <ls_sflight_old>-fldate
          iv_distribution_function  = lv_distribution_function
        importing
          ev_seatsocc = ls_sflight_new-seatsocc
          ev_seatsocc_b = ls_sflight_new-seatsocc_b
          ev_seatsocc_f = ls_sflight_new-seatsocc_f ).

*     Economy Class
      generate_bookings_for_class(
        exporting
          is_spfli = is_spfli
          iv_class = sc_economy
          iv_distribution_function = lv_distribution_function
        changing
          cs_sflight = ls_sflight_new
          ct_sbook = lt_sbook[] ).

*     Business Class
      generate_bookings_for_class(
        exporting
          is_spfli = is_spfli
          iv_class = sc_business
          iv_distribution_function = lv_distribution_function
        changing
          cs_sflight = ls_sflight_new
          ct_sbook = lt_sbook[] ).

*     First Class
      generate_bookings_for_class(
        exporting
          is_spfli = is_spfli
          iv_class = sc_first
          iv_distribution_function = lv_distribution_function
        changing
          cs_sflight = ls_sflight_new
          ct_sbook = lt_sbook[] ).

      insert sbook from table lt_sbook.
      insert zsbook_row from table lt_sbook.
      clear lt_sbook[].

      update sflight set seatsocc = ls_sflight_new-seatsocc
                         seatsocc_b = ls_sflight_new-seatsocc_b
                         seatsocc_f = ls_sflight_new-seatsocc_f
                         paymentsum = ls_sflight_new-paymentsum
             where carrid = ls_sflight_new-carrid
               and connid = ls_sflight_new-connid
               and fldate = ls_sflight_new-fldate.
      commit work.
    endloop.

  endmethod.


  method generate_flights.

    data: lt_spfli      type sorted table of spfli with unique key carrid connid,
          lt_sflight    type sorted table of sflight with unique key carrid connid fldate,
          ls_sflight    type sflight,
          ls_scarr      type scarr,
          ls_saplane    type saplane,
          lv_price      type s_price,
          lv_seatsocc   type s_seatsocc,
          lv_seatsocc_b type s_socc_b,
          lv_seatsocc_f type s_socc_f,
          lv_fldate     type s_date.

    field-symbols: <ls_spfli> type spfli.

*   get all connections
    select * from spfli into table lt_spfli.

    loop at lt_spfli assigning <ls_spfli>.
      clear ls_sflight.
*     airline, connection
      ls_sflight-carrid = <ls_spfli>-carrid.
      ls_sflight-connid = <ls_spfli>-connid.

*     connection price
      select single * from scarr into ls_scarr
        where carrid = <ls_spfli>-carrid.
      ls_sflight-currency = ls_scarr-currcode.
      lv_price = determine_connection_price(
        iv_distance = <ls_spfli>-distance
        iv_distance_unit = <ls_spfli>-distid
        iv_currency = ls_sflight-currency ).

*     plane and capacity per class
      ls_sflight-planetype = determine_planetype(
        iv_distance = <ls_spfli>-distance
        iv_distance_unit = <ls_spfli>-distid ).
      select single * from saplane into ls_saplane
        where planetype = ls_sflight-planetype.
      if sy-subrc is initial.
        ls_sflight-seatsmax = ls_saplane-seatsmax.
        ls_sflight-seatsmax_b = ls_saplane-seatsmax_b.
        ls_sflight-seatsmax_f = ls_saplane-seatsmax_f.
      endif.

*     occupied capacity for connection
      determine_connection_seatsocc(
        exporting
          iv_seatsmax = ls_sflight-seatsmax
          iv_seatsmax_b = ls_sflight-seatsmax_b
          iv_seatsmax_f = ls_sflight-seatsmax_f
        importing
          ev_seatsocc = lv_seatsocc
          ev_seatsocc_b = lv_seatsocc_b
          ev_seatsocc_f = lv_seatsocc_f ).

      lv_fldate = iv_fldate_from.
      while lv_fldate <= iv_fldate_to.
*       flight date
        ls_sflight-fldate = lv_fldate.

*       flight price
        ls_sflight-price = determine_flight_price(
          exporting
            iv_price = lv_price
            iv_currency = ls_sflight-currency
            iv_fldate = ls_sflight-fldate ).

*       occupied capacity for flight
        determine_flight_seatsocc(
          exporting
            iv_seatsmax = ls_sflight-seatsmax
            iv_seatsmax_b = ls_sflight-seatsmax_b
            iv_seatsmax_f = ls_sflight-seatsmax_f
            iv_seatsocc = lv_seatsocc
            iv_seatsocc_b = lv_seatsocc_b
            iv_seatsocc_f = lv_seatsocc_f
            iv_fldate = ls_sflight-fldate
          importing
            ev_seatsocc = ls_sflight-seatsocc
            ev_seatsocc_b = ls_sflight-seatsocc_b
            ev_seatsocc_f = ls_sflight-seatsocc_f ).

        insert ls_sflight into table lt_sflight.
        lv_fldate = lv_fldate + 1.
      endwhile.
    endloop.

    insert sflight from table lt_sflight.
    commit work and wait.

  endmethod.


  method generate_mass_data.
    zcl_010205_service=>initialize_messages( ).

*   Starting mass data generation for flight data model
    message i001(za4h_book_dg) into data(lv_null).          "#EC NEEDED
    zcl_010205_service=>add_message( iv_msgty = 'I' iv_msgno = '001' iv_progress = abap_true ).

*   initialize tables
    delete from sflight.
    delete from sbook.
    delete from zsbook_row.

*   generate flights
    generate_flights(
      exporting
        iv_fldate_from = iv_fldate_from
        iv_fldate_to = iv_fldate_to ).

*   generate bookings
    generate_bookings( ).

*   Mass data generation finished
    message i002(za4h_book_dg) into lv_null.
    zcl_010205_service=>add_message( iv_msgty = 'I' iv_msgno = '002' iv_progress = abap_true ).

*   display messages
    zcl_010205_service=>display_messages( ).
  endmethod.


  method get_instance.
    if not sr_dg_main is bound.
      create object sr_dg_main.
    endif.
    rr_dg_main = sr_dg_main.
  endmethod.
ENDCLASS.
