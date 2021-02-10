class ZCL_ZPKAL010304_CDS_01 definition
  public
  inheriting from CL_SADL_GTK_EXPOSURE_MPC
  final
  create public .

public section.
protected section.

  methods GET_PATHS
    redefinition .
  methods GET_TIMESTAMP
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZPKAL010304_CDS_01 IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( |CDS~ZPKAL010304_CDS_01| )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20201118093758.
  endmethod.
ENDCLASS.
