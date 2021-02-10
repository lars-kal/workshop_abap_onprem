*&---------------------------------------------------------------------*
*& Report ZLSWS0103_PR_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLSWS0103_PR_01.

"order by
"select on stellvertreter object
"and so on

data ls_vbap type vbap.

select single  *
    from vbap
    into corresponding fields of ls_vbap
    where vbeln = '000000004'.



*    lv_int = 10.
