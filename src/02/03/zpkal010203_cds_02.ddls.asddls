@AbapCatalog.sqlViewName: 'ZCDS01020302'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds - consuming cds table function'
define view ZPKAL010203_cds_02
  with parameters @Environment.systemField: #CLIENT
                  iv_client:abap.clnt,
                  iv_vbeln:abap.char(10) 
      as select from ZPKAL010203_cds_01 ( 
           iv_client : $parameters.iv_client, 
           iv_vbeln : $parameters.iv_vbeln
            ) 
     {
    *
}
