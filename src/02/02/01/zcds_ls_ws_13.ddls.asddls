@AbapCatalog.sqlViewName: 'ZSQL_LS_WS_13'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds - association exposed'
define view zcds_ls_ws_13
  as select 
       from vbak

   association [0..*] to vbap as _vbap
        on vbak.vbeln = _vbap.vbeln

{

  vbak.vbeln,
  vbak.vbtyp,
  _vbap
  
}
where 
 auart = 'TA'
