report zpkal010203_pr_01.

start-of-selection.
  break-point.

  data(lt_result) = value zpkal010203_cl_01=>ty_t_result( ).

  new zpkal010203_cl_01( )->get_salesorder_info(
    exporting
      iv_client = sy-mandt
      iv_vbeln  = '0000000013'
    importing
      et_result = lt_result
  ).


  break-point.
