report zlsws130204_pr_04.


start-of-selection.

  "Partner lesen
  select from i_salesorder
  fields
   salesorder,
    \_item-salesorderitem,
     \_item\_partner[ partnerfunction = 'WE' ]-customer
    where salesorder = '0000000004'
    into table @data(lt_result).


  "Partner lesen mit Namen
  select from i_salesorder
  fields
   salesorder,
    \_item-salesorderitem,
     \_item\_partner[ partnerfunction = 'WE' ]\_partnerfunction\_text[ language = @sy-langu ]-partnerfunctionname
    where salesorder = '0000000004'
    into table @data(lt_result2).



  "erst Position dann Kopf
  select from i_salesorder
  fields
     salesorder,
    \_item-salesorderitem,
    coalesce(
         \_item\_partner[ partnerfunction = 'WE' ]-customer ,
           \_partner[ partnerfunction = 'WE' ]-customer ) as warenempfaenger
    where salesorder = '0000000004'
    into table @data(lt_result3).




  "mehrere mit vorwärtsnavigation
  select from i_salesorder
  fields
      salesorder,
       \_item-salesorderitem,
      customeraccountassignmentgroup,
      customerpurchaseordertype,
      lastchangedbyuser,
      overallsddocumentrejectionsts,
      \_item-material,
      \_item-baseunit,
      \_partner[ partnerfunction = 'AG' ]-customer as auftraggeber,
      coalesce(
         \_item\_partner[ partnerfunction = 'WE' ]\_partnerfunction\_text[ language = @sy-langu ]-partnerfunctionname ,
           \_partner[ partnerfunction = 'WE' ]-customer ) as warenempfaenger
*    \_Partner-PartnerFunction
*    \_Partner[ PartnerFunction = 'WE' ]-Customer
      where salesorder = '0000000004'
   into table @data(lt_result4).




  "wieder in einen cds view verschalen


  break-point.
