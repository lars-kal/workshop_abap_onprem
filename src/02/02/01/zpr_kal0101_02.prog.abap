report zpr_kal0101_02.

start-of-selection.

  break-point.

  "select geht immer auf beide tabellen
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


  break-point.

  "CDS - obiger select in view aufbauen und verschalen
  "ABAP - muss ich nciht mselber machen
  select *
  from zcds_ls_ws_11
  into table @data(lt_cds_join).


  "join on demand
  "problem- aufrufer kommt benötigt nur die und die felder
  "problem - aufrufer kommt und benötigt das feld zusätzlich?



  "nur head felder aber kein join!
  select
   vbeln,
   vbtyp
   from zcds_ls_ws_12
   into table @data(lt_cds_association).



  "view nur mit head feldern, wird dann ein join gemacht? -> nein
  select
   vbeln,
   vbtyp
   from zcds_ls_ws_13
   into table @data(lt_cds_association_exposed).


  "view mit _exponierung der asszioation -> join ja
  select
     vbeln,
     vbtyp,
     \_vbap-posnr,
     \_vbap-matnr
   from zcds_ls_ws_13
   into table @data(lt_cd_association_exposed2).



  "select mit neuer schreibweise
  select from zcds_ls_ws_13
      fields
      vbeln,
     \_vbap-posnr
*     \_vbap-
  into table @data(lt_cd_association_exposed3).


  "-------


  "eclipse erkennen wo die association ist



  "-----------


  "vdm salesodcuemnt durchnavigieren
  "partner holen
  "sprache einfügen
  "coalesece


  "wichtig vorwärtsnavigation


  "-----------------------------

  "bestand zeigen


  break-point.










  break-point.



*"join on demand
*select
*  vbak~vbeln,
*  vbak~vbtyp,
*  vbap~posnr,
*  vbap~matnr,
*  vbap~zmeng
*  from vbak
*   join vbap
*      on vbak~vbeln = vbap~vbeln
*  up to 10 rows
*  into table @data(lt_vbak_vbap).
