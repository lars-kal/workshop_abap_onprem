report zpkal010201_pr_07.


"https://blogs.sap.com/2020/05/04/sql-windowing-functions/
"https://help.sap.com/viewer/4fe29514fd584807ac9f2a04f6754767/2.0.03/en-US/20a353327519101495dfd0a87060a0d3.html


"In this example we calculate the number of free seats on the previous and next flight out of Frankfurt.
SELECT
  sflight~carrid,
  sflight~connid,
  sflight~fldate,
  sflight~seatsmax,
  sflight~seatsocc,
  ( sflight~seatsmax - sflight~seatsocc ) AS seatsfree
*  ( LAG( sflight~seatsmax )
*      OVER( PARTITION BY sflight~carrid ORDER BY fldate )
*  - LAG( sflight~seatsocc )
*      OVER( PARTITION BY sflight~carrid ORDER BY fldate ) ) AS seatsfree_previous,
*  ( LEAD( sflight~seatsmax )
*      OVER( PARTITION BY sflight~carrid ORDER BY fldate )
*  - LEAD( sflight~seatsocc )
*      OVER( PARTITION BY sflight~carrid ORDER BY fldate ) ) AS seatsfree_next
  FROM spfli
  INNER JOIN sflight ON spfli~carrid = sflight~carrid AND spfli~connid = sflight~connid
  WHERE spfli~cityfrom = 'FRANKFURT'
  ORDER BY sflight~carrid, sflight~fldate
  INTO TABLE @DATA(lt_sflights).
