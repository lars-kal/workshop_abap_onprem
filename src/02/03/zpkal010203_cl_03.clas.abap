class zpkal010203_cl_03 definition
  public
  final
  create public .

  public section.

    interfaces if_amdp_marker_hdb.

    types ty_t_result type standard table of vbap with empty key.

    class-methods
      get_salesorder_info for table function ZPKAL010203_cds_01.
*        importing
*          value(iv_client) type mandt
*          value(iv_vbeln)  type string
*        exporting
*          value(et_result) type ty_t_result.

  protected section.
  private section.
endclass.


class zpkal010203_cl_03 implementation.

  method get_salesorder_info by database function
    for hdb
    language sqlscript
    options read-only
    using vbap.

    return select
        mandt as mandt,
         vbeln as vbeln
        from vbap where
       mandt = :iv_client and
       vbeln = :iv_vbeln;

  endmethod.

endclass.
