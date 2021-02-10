*&---------------------------------------------------------------------*
*& Report ZPR_LS_WS_07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zpkal010201_pr_02.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"tabelle voranstellen damit man f4hilfe benutezn kann
"und datendeklaration
select single
from usr01
fields
datfm
where bname = 'ABC'
into @data(lv_datfm).


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

*onto table am ende

*The rationale behind this change is, that the INTO clause is not part of standard SQL but defines the data interface between SQL and ABAP.
*In order to enable future enhancements in the SQL part of Open SQL, e.g. UNION, the INTO clause has to be removed from the SQL part.

"I promised to tell you, why the INTO clause should be placed behind all the other clauses in an Open SQL SELECT statement.
"One reason is that Open SQL also wanted to support the SQL syntax addition UNION. An UNION addition can be placed between
 "SELECT statements in order to create the union of the result sets. ABAP CDS offered its UNION from the beginning (7.40, SP05).
 "If you wanted to use it in Open SQL, you had to wrap it in a CDS view. What hindered Open SQL? Well, the position of the ABAP specific
 "INTO clause before the WHERE, GROUP BY and ORDER BY clauses. These clauses can be part of any SELECT statement participating in unions
 "and there must be only one INTO clause at the end. Therefore, with 7.40, SP08, as a first step, the INTO clause was given a new position.




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

select  *
from vbap
into table @data(lt_vbap).


select matnr, sum( zmeng ) as menge
from @lt_vbap as lt_vbap
group by matnr
into table @data(lt_result)
.



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

*    select internal table anstatt jion
