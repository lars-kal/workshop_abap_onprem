@ClientDependent: true
define table function ZPKAL010203_cds_01 
  with parameters @Environment.systemField: #CLIENT
                  iv_client:abap.clnt,
                  iv_vbeln:abap.char(10) 
      returns { 
            mandt:mandt;  
            vbeln:vbeln; 
             } 
  implemented by method 
     ZPKAL010203_CL_03=>get_salesorder_info;

