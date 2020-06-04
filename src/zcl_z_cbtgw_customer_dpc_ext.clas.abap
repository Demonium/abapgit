class ZCL_Z_CBTGW_CUSTOMER_DPC_EXT definition
  public
  inheriting from ZCL_Z_CBTGW_CUSTOMER_DPC
  create public .

public section.
protected section.

  methods CUSTOMERSET_GET_ENTITY
    redefinition .
  methods CUSTOMERSET_CREATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_Z_CBTGW_CUSTOMER_DPC_EXT IMPLEMENTATION.


  METHOD customerset_create_entity.

* =========================
* Déclaration des variables
* =========================
    DATA : ls_personaldata   TYPE bapikna101_1
         , ls_personalopt    TYPE bapikna105
         , ls_copyref        TYPE bapikna102
         , ls_message        TYPE bapireturn1
         , ls_sortl          TYPE kna1-sortl
         , ls_new_customer   TYPE zcbt_s_customer
         , lv_custnumber(10) TYPE c
         .

* ==========
* Constantes
* ==========
    CONSTANTS : c_vkorg TYPE char4 VALUE '0001'
              , c_vtweg TYPE char2 VALUE '01'
              , c_spart TYPE char2 VALUE '01'
              .

* =====================================
* Purge des variables avant utilisation
* =====================================
    CLEAR : ls_personaldata
          , ls_personalopt
          , ls_copyref
          , ls_message
          , ls_sortl
          , lv_custnumber
          .

* ===========================================
* Préparation des variables avant appel du MF
* ===========================================

    io_data_provider->read_entry_data(
    IMPORTING
    es_data = ls_new_customer ).

    MOVE-corresponding ls_new_customer to ls_personaldata.
    ls_personaldata-postl_cod1 = ls_new_customer-postlcode.
    ls_personaldata-country = ls_new_customer-country.
    ls_personaldata-currency = 'EUR'.
    ls_personaldata-langu_p = ls_new_customer-country.
    ls_personaldata-e_mail = ls_new_customer-email.
    ls_personaldata-tel1_numbr = ls_new_customer-telephone.

    ls_personalopt-transpzone = 'F000010000'.

    ls_copyref-salesorg = c_vkorg.
    ls_copyref-distr_chan = c_vtweg.
    ls_copyref-division = c_spart.

    SELECT SINGLE kunnr FROM knvp
                        INTO ls_copyref-ref_custmr
                        WHERE vkorg = c_vkorg
                        AND vtweg = c_vtweg
                        AND spart = c_spart.

* ===================================================
* Appel du module de fonction de création des clients
* ===================================================
    CALL FUNCTION 'BAPI_CUSTOMER_CREATEFROMDATA1'
      EXPORTING
        pi_personaldata     = ls_personaldata
        pi_opt_personaldata = ls_personalopt
        pi_copyreference    = ls_copyref
      IMPORTING
        customerno          = lv_custnumber
        return              = ls_message.

* ===================================================
* Préparation du message de retour pour le chatbot
* ===================================================
  ls_new_customer-customer = lv_custnumber.
  MOVE-CORRESPONDING ls_new_customer to ER_ENTITY.

  ENDMETHOD.


  method CUSTOMERSET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->CUSTOMERSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    IO_REQUEST_OBJECT       =
**    IO_TECH_REQUEST_CONTEXT =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    ER_ENTITY               =
**    ES_RESPONSE_CONTEXT     =
*    .
** CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION .
** CATCH /IWBEP/CX_MGW_TECH_EXCEPTION .
**ENDTRY.
  endmethod.
ENDCLASS.
