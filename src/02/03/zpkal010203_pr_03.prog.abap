report zpkal010203_pr_03.

start-of-selection.
  break-point.


  data(lt_result) = value zpkal010203_cl_02=>ty_t_result(  ).

  new zpkal010203_cl_02( )->get_user_fuzzy_search(
    exporting
      iv_client = sy-mandt
      iv_search = 'ue'
      iv_factor = '0.8'
    importing
      et_result = lt_result
  ).


  new zpkal010203_cl_02( )->get_user_fuzzy_search(
    exporting
      iv_client = sy-mandt
      iv_search = 'ue'
      iv_factor = '0.6'
    importing
      et_result = lt_result
  ).


  new zpkal010203_cl_02( )->get_user_fuzzy_search(
    exporting
      iv_client = sy-mandt
      iv_search = 'ue'
      iv_factor = '0.4'
    importing
      et_result = lt_result
  ).

  new zpkal010203_cl_02( )->get_user_fuzzy_search(
   exporting
     iv_client = sy-mandt
     iv_search = 'ue'
     iv_factor = '0.2'
   importing
     et_result = lt_result
 ).

  break-point.
