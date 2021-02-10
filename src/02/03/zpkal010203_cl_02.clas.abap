class ZPKAL010203_CL_02 definition
  public
  final
  create public .

public section.

interfaces if_amdp_marker_hdb.

    types ty_t_result type standard table of usr01 with empty key.

    methods
      get_user_fuzzy_search
        importing
         value(iv_client) type mandt
          value(iv_search) type string
          value(iv_factor) type string
        exporting
          value(et_result) type ty_T_result.

  protected section.
  private section.
ENDCLASS.



CLASS ZPKAL010203_CL_02 IMPLEMENTATION.

  METHOD GET_USER_FUZZY_SEARCH by database procedure
    for hdb
    language sqlscript
    options read-only
    using usr01.


    et_result =  select * from usr01 where
       mandt = :iv_client and
       contains(bname, :iv_search , fuzzy(:iv_factor,'similarCalculationMode=search') );
*        maxDistance=3

  ENDMETHOD.

ENDCLASS.
