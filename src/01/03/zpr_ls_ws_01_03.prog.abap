*&---------------------------------------------------------------------*
*& Report zpr_ls_ws_01_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zpr_ls_ws_01_03.



**test mock up object
*
*report zre_kal_2020_test_01.
*
*class ltcl_unit definition final for testing
*                       duration short
*                       risk level harmless.
*
*  private section.
*    methods:
*      first_test for testing raising cx_static_check.
*endclass.
*
*
**class ltcl_unit implementation.
**
**  method first_test.
**
**    break-point.
**
**    select *
**    from vbpa
**    into table @data(lt_vbpa).
**
**
**
**    data(environment) = cl_osql_test_environment=>create( i_dependency_list = value #(  ( 'VBPA' ) ) ).
**
**    types ty_T_vbpa type standard table of vbpa with default key.
**
**    environment->insert_test_data( exporting i_data = value ty_T_vbpa(
**        (  parnr = '021435' parvw = 'AG' )
**        (  parnr = '021435' parvw = 'EG' )
**        ) ).
**
**
**    select *
**    from vbpa
**    into table @data(lt_vbpa2).
**
**    break-point.
**  endmethod.
**
**endclass.
