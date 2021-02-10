class zpkal010203_cl_01 definition
  public
  final
  create public .

  public section.

    interfaces if_amdp_marker_hdb.

    types ty_t_result type standard table of vbap with empty key.

    methods
      get_salesorder_info
        importing
          value(iv_client) type mandt
          value(iv_vbeln)  type string
        exporting
          value(et_result) type ty_t_result.

  protected section.
  private section.
endclass.


class zpkal010203_cl_01 implementation.

  method get_salesorder_info by database procedure
    for hdb
    language sqlscript
    options read-only
    using vbap.


    et_result =  select * from vbap where
       mandt = :iv_client and
       vbeln = iv_vbeln;

  endmethod.

endclass.
