@AbapCatalog.sqlViewName: 'ZLSSQL_CDS_001'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds view with virtual element'
@OData: { publish: true }
define view zlsws_cds_001 as select from spfli {
     key carrid,
  key connid,

  @ObjectModel.virtualElement: true
  @ObjectModel.virtualElementCalculatedBy: 'Zlsws_CL_DEMO_CDS_CALC'
  cast( ''  as abap.char(255)) as note 
}
