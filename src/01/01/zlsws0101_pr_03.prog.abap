report zlsws0101_pr_03.

class lcl_parallel_task definition.

  public section.

    interfaces if_abap_parallel.

    data input  type i.
    data result type i.

endclass.

class lcl_parallel_task implementation.

  method if_abap_parallel~do.
    result = input * input.
  endmethod.

endclass.

start-of-selection.

  data:
    lt_task type cl_abap_parallel=>t_in_inst_tab,
    lo_task type ref to lcl_parallel_task.

  do 1000 times.
    lo_task = new lcl_parallel_task(  ).
    lo_task->input = sy-index.

    insert lo_task into table lt_task.
  enddo.


  data(lo_parallel) = new cl_abap_parallel( ).

  lo_parallel->run_inst(
    exporting p_in_tab = lt_task
    importing p_out_tab = data(lt_task_result) ).


  loop at lt_task_result assigning field-symbol(<ls_out>) where inst is not initial.
    lo_task ?= <ls_out>-inst.

    data(lv_result) = lo_task->result.
  endloop.
