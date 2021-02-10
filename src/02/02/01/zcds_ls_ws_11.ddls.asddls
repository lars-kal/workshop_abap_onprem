@AbapCatalog.sqlViewName: 'ZSQL_LS_WS_11'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds - with join'
define view zcds_ls_ws_11
  as select 
       from vbak

    inner join vbap 
        on vbak.vbeln = vbap.vbeln

{
  vbak.vbeln,
  vbak.vbtyp,
  vbap.posnr,
  vbap.matnr,
  vbap.zmeng
}
where 
 auart = 'TA'
