report zpkal010203_pr_02.

start-of-selection.

  break-point.

  data(lv_vbeln) = conv vbeln( '0000000013' ).


  select *
    from zpkal010203_cds_01( iv_vbeln = @lv_vbeln )
    into table @data(result)
  ##db_feature_mode[amdp_table_function].


  break-point.
