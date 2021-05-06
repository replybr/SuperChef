/*
  sistema     : superchef pizzaria
  programa    : cadastro da empresa
  compilador  : xharbour 1.2 simplex
  lib gráfica : minigui 1.7 extended
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
    Última alteração : 06/05/2021-18:13:32 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

function empresa()
    Private Rs:=Rs.New()    
    Load Window empresa_form_empresa as form_empresa
        Rs.SQL := "Select * from empresa"
        Rs.Open()
        if !Rs.ErrorSQL().and.!Rs.Eof()
            form_empresa.tbox_001.value := Rs.Field.nome.value
            form_empresa.tbox_002.value := Rs.Field.fixo_1.value
            form_empresa.tbox_003.value := Rs.Field.fixo_2.value
            form_empresa.tbox_004.value := Rs.Field.endereco.value
            form_empresa.tbox_005.value := Rs.Field.numero.value
            form_empresa.tbox_006.value := Rs.Field.complem.value
            form_empresa.tbox_007.value := Rs.Field.bairro.value
            form_empresa.tbox_008.value := Rs.Field.cidade.value
            form_empresa.tbox_009.value := Rs.Field.uf.value
            form_empresa.tbox_010.value := Rs.Field.cep.value
            form_empresa.tbox_011.value := Rs.Field.email.value
            form_empresa.tbox_012.value := Rs.Field.site.value        
        endif
        form_empresa.center
    form_empresa.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar()
    if Rs.Eof()
        Rs.AddNew()
    endif
    Rs.Field.nome.value     := form_empresa.tbox_001.value
    Rs.Field.fixo_1.value   := form_empresa.tbox_002.value
    Rs.Field.fixo_2.value   := form_empresa.tbox_003.value
    Rs.Field.endereco.value := form_empresa.tbox_004.value
    Rs.Field.numero.value   := form_empresa.tbox_005.value
    Rs.Field.complem.value  := form_empresa.tbox_006.value
    Rs.Field.bairro.value   := form_empresa.tbox_007.value
    Rs.Field.cidade.value   := form_empresa.tbox_008.value
    Rs.Field.uf.value       := form_empresa.tbox_009.value
    Rs.Field.cep.value      := form_empresa.tbox_010.value
    Rs.Field.email.value    := form_empresa.tbox_011.value
    Rs.Field.site.value     := form_empresa.tbox_012.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_empresa.release
    return(nil)

