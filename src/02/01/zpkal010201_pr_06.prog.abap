report zpkal010201_pr_06.

start-of-selection.

  "https://blogs.sap.com/2015/11/18/abap-news-for-release-750-insert-from-subquery-and-gtts/comment-page-1/#comment-465359

  data from_id type spfli-carrid.
  data to_id type spfli-carrid.

  from_id = 'AA'.
  to_id = 'LH'.

  break-point.


  insert zkal_t_gtt from (
  select carrid, connid
  from spfli
  ).

  break-point.

  select from zkal_t_gtt
  fields *
  into table @data(lt_gtt).

  delete from zkal_t_gtt.

  break-point.
