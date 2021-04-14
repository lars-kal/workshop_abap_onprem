report zlsws0101_pr_04.


types: begin of ty_s_tables,
         t_mara type standard table of mara with default key,
       end of ty_s_tables,
       ty_t_tables type standard table of ty_s_tables.

data: gt_tables type ty_t_tables.

data: gt_mara type standard table of  mara.

field-symbols: <ft> type any table.

data: gv_count type i.

start-of-selection.
  break-point.
  do 100000 times.
    append initial line to gt_mara.
  enddo.

  append initial line to gt_tables assigning  field-symbol(<fs>).

  loop at gt_mara into data(ls_mara).
    add 1 to gv_count.
    if gv_count = 20000.
      append initial line to gt_tables assigning <fs>.
      clear gv_count.
    endif.
    append ls_mara to <fs>-t_mara.
  endloop.

  "einzelne zeilen löschen bring nichts
  do 50000 times.
    delete gt_mara index 1.
  enddo.

  "wenn zeile eine tabelle ist dann bringt löschen was
  loop at gt_tables assigning <fs> from 3.
    delete gt_tables.
*   clear <fs>-t_mara.
  endloop.

  "extremform: für jeden eintrag eine tabelle
  gt_tables = value #(  ).
  gt_mara = value #(  ).

  do 100000 times.
    append initial line to gt_mara.
  enddo.

  loop at gt_mara into ls_mara.
    append initial line to gt_tables assigning <fs>.
    append ls_mara to <fs>-t_mara.
  endloop.

  "wenn zeile eine tabelle ist dann bringt löschen was
  do 5000 times.
    delete gt_tables index 1..
*   clear <fs>-t_mara.
  enddo.

  cl_abap_memory_utilities=>get_total_used_size(
    importing
      size = data(lv_size)
  ).
  cl_abap_memory_utilities=>get_memory_size_of_object(
    exporting
      object                     = gt_tables
    importing
      bound_size_alloc           = data(lv_alloc)
      bound_size_used            = data(lv_used)
  ).


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " boxed testen
  break-point.
  gt_tables = value #(  ).
  gt_mara = value #(  ).

  types:
    begin of ty_S_mara_b,
      s_mara type mara boxed,
    end of ty_S_mara_b.

  data gt_mara_boxed type standard table of ty_S_mara_b.

  do 100000 times.
    append initial line to gt_mara.
  enddo.

  do 100000 times.
    append initial line to gt_mara_boxed.
  enddo.

  break-point.



  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  "anderes beispiel


TYPES : BEGIN OF ty_so_boxed,
          no          TYPE i,
          sales_order TYPE ekpo BOXED,
        END OF ty_so_boxed.

TYPES : BEGIN OF ty_so_unboxed,
          no          TYPE i,
          sales_order TYPE ekpo,
        END OF ty_so_unboxed.

DATA : li_so_boxed   TYPE TABLE OF ty_so_boxed ,
       li_so_unboxed TYPE TABLE OF ty_so_unboxed .

*DATA : lv_size TYPE abap_msize.

START-OF-SELECTION.

  DO 50000 TIMES.
    APPEND INITIAL LINE TO li_so_boxed.
    APPEND INITIAL LINE TO li_so_unboxed.
  ENDDO.

  "Check memory usage between two internal table.
  cl_abap_memory_utilities=>get_memory_size_of_object( EXPORTING object = li_so_boxed
                                                       IMPORTING bound_size_alloc = lv_size ).

  WRITE : 'Memory usage of Boxed Internal Table ', lv_size.

  CLEAR lv_size.
  cl_abap_memory_utilities=>get_memory_size_of_object( EXPORTING object = li_so_unboxed
                                                       IMPORTING bound_size_alloc = lv_size ).

  WRITE : 'Memory usage of Un-Boxed Internal Table ', lv_size.

*  cl_abap_memory_utilities=>do_garbage_collection( ).


*  exporting
**    connection         =
*    requested_features =
**  receiving
**    supports_features  =
*).
*catch cx_abap_invalid_param_value.
