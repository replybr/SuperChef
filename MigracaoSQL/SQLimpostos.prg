/*
  sistema     : superchef pizzaria
  programa    : impostos e alíquotas
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
    Última alteração : 07/05/2021-15:28:21 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

function IMPOSTOS_ALIQUOTAS
    Local aHeader:={'Código','Nome','Alíquota (%)'}
    Private Rs:=Rs.New()
    //form_impostos
    Load window Form_Pesquisa as form_impostos
        form_impostos.Title := "Impostos e Alíquotas"
        on key F5      of form_impostos action dados(1)
        on key F6      of form_impostos action dados(2)
        on key F7      of form_impostos action excluir()
        on key F8      of form_impostos action relacao()
        on key escape  of form_impostos action thiswindow.release        
        form_impostos.center
    form_impostos.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := form_impostos.Grid_Pesquisa.Item(form_impostos.Grid_Pesquisa.value)[1]
    Load Window impostos_form_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from impostos where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := Rs.Field.nome.value
                form_dados.tbox_002.value := Rs.Field.aliquota.value
            endif        
        endif
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    return(nil)    
    
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=form_impostos.Grid_Pesquisa.Item(form_impostos.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from impostos where codigo="+cId)
    if Rs.ErrorSQL()
        Return .F.
    endif
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
static function relacao()
    
    local p_linha := 040
    local u_linha := 260
    local linha   := p_linha
    local pagina  := 1
    
    Rs.SQL:="Select * from impostos order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    SELECT PRINTER DIALOG PREVIEW
    
    START PRINTDOC NAME 'Gerenciador de impressão'
        START PRINTPAGE
        
        cabecalho(pagina)
        
        while !Rs.Eof()
            
            @ linha,030 PRINT strzero(rs.field.codigo.value,4) FONT 'courier new' SIZE 010
            @ linha,045 PRINT rs.field.nome.value FONT 'courier new' SIZE 010
            @ linha,090 PRINT trans(rs.field.aliquota.value,'@R 999.99') FONT 'courier new' SIZE 010
            
            linha += 5
            
            if linha >= u_linha
                END PRINTPAGE
                START PRINTPAGE
                pagina ++
                cabecalho(pagina)
                linha := p_linha
            endif
            
            rs.moveNext()
            
        end
        
        rodape()
        
        END PRINTPAGE
    END PRINTDOC
    
    return(nil)
    *-------------------------------------------------------------------------------
static function cabecalho(p_pagina)
    
    @ 007,010 PRINT IMAGE 'logotipo' WIDTH 050 HEIGHT 020 STRETCH
    @ 010,070 PRINT 'RELAÇÃO DE IMPOSTOS/ALÍQUOTAS' FONT 'courier new' SIZE 018 BOLD
    @ 018,070 PRINT 'ordem alfabética' FONT 'courier new' SIZE 014
    @ 024,070 PRINT 'página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012
    
    @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK
    
    @ 035,030 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
    @ 035,045 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD
    @ 035,090 PRINT 'ALÍQUOTA (%)' FONT 'courier new' SIZE 010 BOLD
    
    return(nil)
    *-------------------------------------------------------------------------------
static function rodape()
    
    @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR BLACK
    @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar(parametro)
    local cMsg:="",cFocus
    
    if empty(form_dados.tbox_001.value)
        cMsg += "Falta preencher nome "+CRLF
        cFocus := "tbox_001"
        
    endif
    if empty(form_dados.tbox_002.value)
        cMsg += "Falta preencher aliquota "+CRLF
        if empty(cFocus)
            cFocus:="tbox_002"
        endif
    endif
    
    if !Empty(cMsg)
        msgalert(cMsg,'Atenção')
        form_dados.&(cFocus).Setfocus()
        return(nil)
    endif
    
    if parametro == 1
        Rs.Addnew()
    endif
    Rs.Field.nome.value     := form_dados.tbox_001.value
    Rs.Field.aliquota.value := form_dados.tbox_002.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
static function atualizar()
    form_impostos.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_impostos
    Rs.SQL:="Select * from impostos where nome like '"+form_impostos.tbox_pesquisa.value+"%' order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value,4),rs.field.nome.value,trans(rs.field.aliquota.value,'@R 999.99')} to Grid_Pesquisa of form_impostos
        Rs.MoveNext()
    end
    form_impostos.Grid_Pesquisa.ColumnsAutoFit()
    form_impostos.Grid_Pesquisa.ColumnsAutoFitH()    
    form_impostos.Grid_Pesquisa.enableupdate
    return(nil)
    
