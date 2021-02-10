@AbapCatalog.sqlViewName: 'ZSQL_LS_WS_01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'exposed cds view - odata service'
@OData.publish: true
@OData.entitySet.name: 'FlightInfoSet'
define view ZCDS_LS_WS_01
  as select from spfli
{

  key carrid,
  key connid,

      @Consumption.hidden: true
      airpfrom,
      airpto

}
