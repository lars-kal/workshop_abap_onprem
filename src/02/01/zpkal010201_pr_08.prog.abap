report zpkal010201_pr_08.



*testreport partner auslesen
*    1. abap SQL
*    normal
*        intere tabelle (where or)
*        select auf interen tabelle
*    abap subquery
*    union all
*        group by
*    join / outer join
*        group by
*        ocalesce
*    gtt
*    cte
*    2. cds view
*        join
*        union
*        association
*    3. amdp
*
*    cds view mit 00000
*bei vbpa mit parnr we



"subquery

*
*"subquery
*select single
*kunnr
*from zkal_t_vbpa
*into lv_kunnr
*where vbeln = ls_lips-vbeln
*and ( 1 = ( select count( * ) from zkal_t_vbpa where vbeln = ls_lips-vbeln and posnr = ls_lips-posnr and  parvw = 'WE' )
*    and posnr = ls_lips-posnr )
*  or ( 0 = ( select count( * ) from zkal_t_vbpa where vbeln = ls_lips-vbeln and posnr = ls_lips-posnr and parvw = 'WE'
*  and  1 = ( select count( * ) from zkal_t_vbpa where vbeln = ls_lips-vbeln and posnr = '000000'  and parvw = 'WE' )
*    and posnr = ls_lips-posnr )
*and parvw = 'WE'.



*native sal
*https://blogs.sap.com/2020/07/03/native-sql-in-s4-replace-exec-sql-statement-with-this-method/



*https://help.sap.com/viewer/753088fc00704d0a80e7fbd6803c8adb/7.52.5/en-US/89a03e5e5908448cbe7cce3ddcf214b5.html





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
