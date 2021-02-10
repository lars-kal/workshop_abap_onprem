report zlsws130204_pr_03.

start-of-selection.

  select from mard
  fields
   matnr as material,
   werks as plant,
   lgort as storagelocation,
   labst as stock
   where labst <> 0
  into table @data(lt_mard).

  select from i_materialstock
  fields
   material,
  plant,
  storagelocation,
  supplier,
   inventorystocktype,
   \_inventorystocktype\_text[ language = @sy-langu ]-inventorystocktypename,

   inventoryspecialstocktype,
    \_inventoryspecialstocktype\_text[ language = @sy-langu ]-inventoryspecialstocktypename,
*MatlDocLatestPostgDate,
*batch,
*supplier,
  sum( matlwrhsstkqtyinmatlbaseunit ) as stock
   where
      inventoryspecialstocktype = 'O' or
      inventorystocktype <> '01'
  group by
  material,
  plant,
  storagelocation,
  supplier,
   inventorystocktype,
   \_inventorystocktype\_text[ language = @sy-langu ]-inventorystocktypename,
   inventoryspecialstocktype,
     \_inventoryspecialstocktype\_text[ language = @sy-langu ]-inventoryspecialstocktypename
*MatlDocLatestPostgDate
*batch
*supplier
*having
*sum( matlwrhsstkqtyinmatlbaseunit ) <> 0
  into table @data(lt_material_stock).

*delete lt_material_stock where stock <> 0.

  break-point.




  loop at lt_mard into data(ls_mard).

    if line_exists( lt_material_stock[
        material = ls_mard-material
        plant    = ls_mard-plant
        storagelocation = ls_mard-storagelocation
        ] ).
      delete lt_mard.
      delete lt_material_stock
       where
        material = ls_mard-material and
       plant    = ls_mard-plant and
       storagelocation = ls_mard-storagelocation.

    endif.


  endloop.


  break-point.
