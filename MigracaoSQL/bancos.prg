/*
  sistema     : superchef pizzaria
  programa    : contas bancárias
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
    SOBRE ESTE CÓDIGO:
    alteração : 06/05/2021-11:37:50 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    Conversão de DBF para SQL
    */

#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

function contas_bancarias()
    Local aHeader:={'Código','Nome','Banco','Agência','Conta'}
    Private Rs:=Rs.New()
    Load window Form_Pesquisa as form_bancos
        form_bancos.Title := "Contas Bancárias"
        on key F5      of form_bancos action dados(1)
        on key F6      of form_bancos action dados(2)
        on key F7      of form_bancos action excluir()
        on key F8      of form_bancos action relacao()
        on key escape  of form_bancos action thiswindow.release        
        form_bancos.center
    form_bancos.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := Form_bancos.Grid_Pesquisa.Item(Form_bancos.Grid_Pesquisa.value)[1]
    Load Window bancos_form_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from Bancos where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := Rs.Field.nome.value
                form_dados.tbox_002.value := Rs.Field.banco.value
                form_dados.tbox_003.value := Rs.Field.agencia.value
                form_dados.tbox_004.value := Rs.Field.conta_c.value
                form_dados.tbox_005.value := Rs.Field.limite.value
                form_dados.tbox_006.value := Rs.Field.titular.value
                form_dados.tbox_007.value := Rs.Field.gerente.value
                form_dados.tbox_008.value := Rs.Field.telefone.value        
            endif        
        endif
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=Form_bancos.Grid_Pesquisa.Item(Form_Bancos.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from bancos where codigo="+cId)
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
    
    Rs.SQL:="Select * from Bancos order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    SELECT PRINTER DIALOG PREVIEW
    
    START PRINTDOC NAME 'Gerenciador de impressão'
        START PRINTPAGE
        
        cabecalho(pagina)
        
        while .not. eof()
            
            @ linha,020 PRINT strzero(rs.field.codigo.value,4) FONT 'courier new' SIZE 010
            @ linha,035 PRINT rs.field.nome.value FONT 'courier new' SIZE 010
            @ linha,080 PRINT rs.field.banco.value FONT 'courier new' SIZE 010
            @ linha,120 PRINT rs.field.agencia.value FONT 'courier new' SIZE 010
            @ linha,160 PRINT rs.field.conta_c.value FONT 'courier new' SIZE 010
            
            linha += 5
            
            if linha >= u_linha
                END PRINTPAGE
                START PRINTPAGE
                pagina ++
                cabecalho(pagina)
                linha := p_linha
            endif
            
            Rs.MoveNext()
            
        end
        
        rodape()
        
        END PRINTPAGE
    END PRINTDOC
    
    return(nil)
    *-------------------------------------------------------------------------------
static function cabecalho(p_pagina)
    
    @ 007,010 PRINT IMAGE 'logotipo' WIDTH 050 HEIGHT 020 STRETCH
    @ 010,070 PRINT 'RELAÇÃO DE CONTAS BANCÁRIAS' FONT 'courier new' SIZE 018 BOLD
    @ 018,070 PRINT 'ordem alfabética' FONT 'courier new' SIZE 014
    @ 024,070 PRINT 'página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012
    
    @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK
    
    @ 035,020 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
    @ 035,035 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD
    @ 035,080 PRINT 'BANCO' FONT 'courier new' SIZE 010 BOLD
    @ 035,120 PRINT 'AGÊNCIA' FONT 'courier new' SIZE 010 BOLD
    @ 035,160 PRINT 'Nº CONTA' FONT 'courier new' SIZE 010 BOLD
    
    return(nil)
    *-------------------------------------------------------------------------------
static function rodape()
    
    @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR BLACK
    @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar(parametro)
    
    local cMsg:=""
    
    if empty(form_dados.tbox_001.value)
        cMsg += "Falta preencher nome "+CRLF
    endif
    if empty(form_dados.tbox_002.value)
        cMsg += "Falta preencher banco "+CRLF
    endif
    if empty(form_dados.tbox_003.value)
        cMsg += "Falta preencher Agência"+CRLF
    endif
    if empty(form_dados.tbox_004.value)
        cMsg += "Falta preencher a Conta"+CRLF
    endif
    
    if !Empty(cMsg)
        msgalert(cMsg,'Atenção')
        return(nil)
    endif
    
    if parametro == 1
        Rs.Addnew()
    endif
    Rs.Field.nome.value     := form_dados.tbox_001.value
    Rs.Field.banco.value    := form_dados.tbox_002.value
    Rs.Field.agencia.value  := form_dados.tbox_003.value
    Rs.Field.conta_c.value  := form_dados.tbox_004.value
    Rs.Field.limite.value   := form_dados.tbox_005.value
    Rs.Field.titular.value  := form_dados.tbox_006.value
    Rs.Field.gerente.value  := form_dados.tbox_007.value
    Rs.Field.telefone.value := form_dados.tbox_008.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
static function atualizar()
    form_bancos.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_bancos
    Rs.SQL:="Select * from bancos where nome like '"+form_bancos.tbox_pesquisa.value+"%' order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value,4),Rs.Field.nome.value,Rs.Field.banco.value,Rs.Field.agencia.value,Rs.Field.conta_c.value} to Grid_Pesquisa of form_bancos
        Rs.MoveNext()
    end
    form_bancos.Grid_Pesquisa.ColumnsAutoFit()
    form_bancos.Grid_Pesquisa.ColumnsAutoFitH()    
    form_bancos.Grid_Pesquisa.enableupdate
    return(nil)
    *-------------------------------------------------------------------------------
