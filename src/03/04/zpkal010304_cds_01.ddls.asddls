@AbapCatalog.sqlViewName: 'ZPK010304_SQL_01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds - projection view'
@OData.publish: true
@OData.entitySet.name: 'FlightInfoSet'

@UI.headerInfo: {
    typeName: 'Flug',
    typeNamePlural: 'Fluege'

}

define view ZPKAL010304_cds_01
  as select from spfli
{

  key carrid,
  key connid,

      @Consumption.hidden: true
      airpfrom,
      
      
      @UI: { lineItem: [ { position: 10 },  {qualifier: 'ValueList', position: 10 }], selectionField.position: 10   }
      airpto

}
