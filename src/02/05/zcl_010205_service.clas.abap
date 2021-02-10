"! data generator - miscellaneous services used during implementation
class ZCL_010205_SERVICE definition
  public
  abstract
  final
  create public .

public section.

  class-methods SHOW_PROGRESS
    importing
      !IV_PERCENTAGE type I optional
      !IV_TEXT type SYST_UCOMM
    raising
      zcl_ls010205_exception .
  class-methods INITIALIZE_MESSAGES
    raising
     zcl_ls010205_exception .
  class-methods ADD_MESSAGE
    importing
      !IV_MSGTY type SYMSGTY
      !IV_MSGID type SYMSGID default 'ZA4H_BOOK_DG'
      !IV_MSGNO type SYMSGNO
      !IV_MSGV1 type ANY optional
      !IV_MSGV2 type ANY optional
      !IV_MSGV3 type ANY optional
      !IV_MSGV4 type ANY optional
      !IV_PROGRESS type BOOLE_D default ABAP_FALSE
    raising
      zcl_ls010205_exception  .
  class-methods DISPLAY_MESSAGES
    raising
      zcl_ls010205_exception  .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_010205_SERVICE IMPLEMENTATION.
ENDCLASS.
