@AbapCatalog.sqlViewName: 'ZSQL_LS_WS_12'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds - association'
define view zcds_ls_ws_12 
  as select 
       from vbak

   association [0..*] to vbap 
        on vbak.vbeln = vbap.vbeln

{
  vbak.vbeln,
  vbak.vbtyp,
  
  vbap.posnr,
  vbap.matnr,
  vbap.zmeng,
  
  vbap
}
where 
 auart = 'TA'

