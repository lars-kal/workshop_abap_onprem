"! <p class="shorttext synchronized" lang="EN">Usage of ABAP Doc</p>
"! Wraps {@link cl_abap_browser}.
"! class documentation ...
class zlsws0103_cl_01 definition
  public
  final
  create public .

public section.

    "! <p class="shorttext synchronized" lang="EN">Type</p>
    "! type documentation ...
  types TYP type STRING .

    "! <p class="shorttext synchronized" lang="EN">Method</p>
    "! @parameter p1 |
    "! <p class="shorttext synchronized" lang="EN">First parameter</p>
    "! parameter documentation ...
    "! @parameter p2 |
    "! <p class="shorttext synchronized" lang="EN">Second parameter</p>
    "! parameter documentation ...
    "! @parameter r |
    "! parameter documentation ...
    "! <p class="shorttext synchronized" lang="EN">Return value</p>
  methods METH
    importing
      !P1 type STRING optional
      !P2 type STRING optional
    returning
      value(R) type STRING .
  PRIVATE SECTION.
    "! <p class="shorttext synchronized" lang="EN">Attribute</p>
    "! attribute documentation ...
    DATA attr TYPE string .
ENDCLASS.



CLASS zlsws0103_cl_01 IMPLEMENTATION.


  METHOD meth.
    DATA txt TYPE typ.
    r = attr && p1 && p2 && txt.
  ENDMETHOD.
ENDCLASS.
