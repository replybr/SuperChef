
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
    Última alteração : 17/05/2021-13:51:09 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    extraido de SupeChef.prg, tamanhos de pizza
    */

/*
  sistema     : superchef pizzaria
  programa    : principal
  compilador  : xharbour 1.2
  lib gráfica : minigui extended
  programador : marcelo neves
*/
    
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

function Tamanhos_Pizza()
    Local aHeader:={'id','Tamanho','Pedaços','Sabores'}
    Private Rs:=Rs.New()
    Load Window form_pesquisa as form_tamanho
        form_tamanho.title:="Tamanhos de pizza"
        form_tamanho.tbox_pesquisa.enabled:=.F.
        form_tamanho.button_imprimir.enabled := .F.
        on key F5      of form_tamanho action dados(1)
        on key F6      of form_tamanho  action dados(2)
        on key F7      of form_tamanho  action excluir()
        on key escape  of form_tamanho action thiswindow.release
        
    form_tamanho.center
    form_tamanho.activate
    return(nil)
    
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := form_tamanho.Grid_Pesquisa.Item(form_tamanho.Grid_Pesquisa.value)[1]
    Load Window tamanhospizza_form_altera_tamanho as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from tamanhos where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := Rs.Field.nome.value
                form_dados.tbox_002.value := Rs.Field.pedacos.value
                form_dados.tbox_003.value := Rs.Field.sabores.value
            endif    
        else
            rs.sql:="select * from tamanhos where 1=2"
            rs.Open()
        endif
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar(parametro)
    
    if empty(form_dados.tbox_001.value)
        msginfo('Preencha o nome','Atenção')
        form_dados.tbox_001.setfocus()
        return(nil)
    endif
    
    if empty(form_dados.tbox_002.value)
        msginfo('Preencha a qtde de Pizzas','Atenção')
        form_dados.tbox_002.setfocus()
        return(nil)
    endif

    if empty(form_dados.tbox_003.value)
        msginfo('Numero de sabores deve ser ser informado','Atenção')
        form_dados.tbox_003.setfocus()
        return(nil)
    endif

    if parametro == 1
        Rs.Addnew()
    endif
    Rs.Field.nome.value    := form_dados.tbox_001.value
    Rs.Field.pedacos.value := form_dados.tbox_002.value
    Rs.Field.sabores.value := form_dados.tbox_003.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
static function atualizar()
    form_tamanho.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_tamanho
    Rs.SQL:="Select * from tamanhos order by codigo"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value,10),;
                  Rs.Field.nome.value,;
                  hb_ntos(Rs.Field.pedacos.value),;
                  hb_ntos(rs.field.sabores.value)} to Grid_Pesquisa of form_tamanho
        Rs.MoveNext()
    end
    form_tamanho.Grid_Pesquisa.ColumnsAutoFit()
    form_tamanho.Grid_Pesquisa.ColumnsAutoFitH()    
    form_tamanho.Grid_Pesquisa.enableupdate
    return(nil)    
    *-------------------------------------------------------------------------------
static function relacao()
    Return Nil    
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=Form_tamanho.Grid_Pesquisa.Item(Form_tamanho.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from tamanhos where codigo="+cId)
    if Rs.ErrorSQL()
        Return .F.
    endif
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
