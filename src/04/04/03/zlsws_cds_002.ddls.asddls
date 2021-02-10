@AbapCatalog.sqlViewName: 'ZLSSQL_CDS_002'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds view with custom entities'
@OData: { publish: true }
define view ZLSWS_CDS_002 as select from spfli {
     key carrid,
  key connid,

  @ObjectModel.virtualElement: true
  @ObjectModel.virtualElementCalculatedBy: 'Zlsws_CL_DEMO_CDS_CALC'
  cast( ''  as abap.char(255)) as note 
}

