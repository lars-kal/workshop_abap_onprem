report zpkal010201_pr_04.

start-of-selection.

*cte common table expression
*https://blogs.sap.com/2016/10/18/abap-news-release-7.51-common-table-expressions-cte-open-sql/comment-page-1/#comment-458022

  "old way
  "join
  select
    vbak~vbeln,
    vbak~vbtyp,
    vbap~posnr,
    vbap~matnr,
    vbap~zmeng
    from vbak
     join vbap
        on vbak~vbeln = vbap~vbeln
    into table @data(lt_vbak_vbap)
    where auart = 'TA'.



  with
    +my_vbak as (

      select from vbak
          fields
            vbak~vbeln,
            vbak~vbtyp
          where
           auart = 'TA'
           ),

    +my_vbap as (

        select from vbap
          inner join +my_vbak
            on +my_vbak~vbeln = vbap~vbeln
          fields
            vbap~posnr,
            vbap~matnr,
            vbap~zmeng
      )

   select from +my_vbap
    fields *
   into table @data(result).
