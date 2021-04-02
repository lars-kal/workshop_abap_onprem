report zlsws0102_pr_02.

class lcx_error definition inheriting from cx_no_check.

  public section.

    class-methods factory_by_sy
      returning value(result) type ref to lcx_error.

    class-methods factory
      returning value(result) type ref to lcx_error.
endclass.

class lcx_error implementation.

  method factory.

  endmethod.

  method factory_by_sy.

  endmethod.

endclass.

class lcx_new_error definition inheriting from cx_no_check.

  public section.

    interfaces if_t100_dyn_msg.

endclass.


start-of-selection.

  try.

*      raise shortdump type lcx_error.

    catch cx_root.
  endtry.

  try.

      raise shortdump type lcx_error.

    catch cx_root.
  endtry.
