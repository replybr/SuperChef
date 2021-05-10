/*
  sistema     : superchef pizzaria
  programa    : Principal
  compilador  : xharbour 1.2
  lib gráfica : minigui extended
  programador : marcelo neves
*/

/*  SOBRE A IDE
    ==============================================================================================
    Gerado pela IDE Designer
    #Define VERSION_PRODUCT "0.99.23.28 RELEASE CANDIDATE (RC) 210505 1602"
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 21.03.3 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.1 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO GERADO:
    Última alteração : 10/05/2021-10:30:52 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    Forma de Pagamento extraido de SuperChef.prg
    */


#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

Function configurar_venda()
    Private Rs:=Rs.New()
    rs.sql := "Select forma_pagamento from empresa"
    rs.Open()    
    Load Window Forma_Pagamento as form_configurar
        form_configurar.cbo_tipo.addItem('Calcular pelo MAIOR preço')
        form_configurar.cbo_tipo.addItem('Calcular pela MÉDIA de preços')
        on key escape  of form_configurar action thiswindow.release  
        form_configurar.center
        if !Rs.Eof()
            form_configurar.cbo_tipo.value := rs.field.forma_pagamento.value
        endif
    form_configurar.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar_config()
    if form_configurar.cbo_tipo.value>0
        rs.Execute("Update empresa set forma_pagamento="+hb_ntos(form_configurar.cbo_tipo.value))
        rs.ErrorSQL()
    endif
    form_configurar.release
    return(nil)
    *-------------------------------------------------------------------------------
