report zlsws0205_pr_01.


data lv_min_order_date type sbook-order_date.
data lv_max_order_date type sbook-order_date.
data lv_avg_luggweight type sbook-luggweight.


break-point.

"HANA
"row store
"ca 42 Mio Enträge
select single
  min( order_date ) as min_order_date
  from zsbook_row
  into lv_min_order_date.

break-point.

"HANA
"Column store
"ca 42 Mio Enträge
select single
  min( order_date ) as min_order_date
  from sbook
  into lv_min_order_date.


return.








"SBOOK
"21.428.051 entries
"ZSBOOK_ROW

if 1 = 0.


  "new way
  delete from zsbook_row.
  commit work and wait.

  insert zsbook_row from ( select * from sbook ).
  commit work and wait.


  "old way
*  data lt_sbook type standard table of sbook.
*  select *
*    from sbook
*    into table lt_sbook.

*  insert zsbook_row from table lt_sbook.

endif.



*data lv_min_order_date type sbook-order_date.
*data lv_max_order_date type sbook-order_date.
*data lv_avg_luggweight type sbook-luggweight.

select single
  min( order_date ) as min_order_date
  from sbook
  into lv_min_order_date.


select single
  min( order_date ) as min_order_date
  from zsbook_row
  into lv_min_order_date.


select single
  min( order_date ) as min_order_date
  max( order_date ) as max_order_date
  avg( luggweight ) as avg_luggweight
  from sbook
  into
   ( lv_min_order_date ,
     lv_max_order_date ,
     lv_avg_luggweight  ).


select single
  min( order_date ) as min_order_date
  max( order_date ) as max_order_date
  avg( luggweight ) as avg_luggweight
  from zsbook_row
  into
   ( lv_min_order_date ,
     lv_max_order_date ,
     lv_avg_luggweight  ).



break-point.
