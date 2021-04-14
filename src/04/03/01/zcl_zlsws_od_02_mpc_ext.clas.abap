class ZCL_ZLSWS_OD_02_MPC_EXT definition
  public
  inheriting from ZCL_ZLSWS_OD_02_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZLSWS_OD_02_MPC_EXT IMPLEMENTATION.


  method DEFINE.

  DATA: lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
  DATA: lo_property TYPE REF TO /iwbep/if_mgw_odata_property.

* Aufruf Basisklasse
  super->define( ).

* Entität "FileStream" holen
  lo_entity = model->get_entity_type( iv_entity_name = zcl_zlsws_od_02_mpc=>gc_file ).
  lo_entity->set_is_media( ).

  IF lo_entity IS BOUND.

* Feld für MimeType (==MIME_TYPE) als ContentType setzen
    lo_property = lo_entity->get_property( iv_property_name = 'MimeType' ).
    lo_property->set_as_content_type( ).

  ENDIF.


  endmethod.
ENDCLASS.
