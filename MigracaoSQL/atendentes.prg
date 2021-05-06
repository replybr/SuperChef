/*
  sistema     : superchef pizzaria
  programa    : atendentes da pizzaria
  compilador  : xharbour 1.2 simplex
  lib gráfica : minigui 1.7 extended
  programador : marcelo neves
*/

/*  SOBRE A IDE
    ==============================================================================================
    IDE Designer
    #Define VERSION_PRODUCT "0.99.23.28 RELEASE CANDIDATE (RC) 210505 1602"
    https://github.com/ivanilmarcelino/designer by IVANIL MARCELINO <ivanil.marcelino@yahoo.com.br>
    Versão Minigui:  Harbour MiniGUI Extended Edition 21.03.3 (32-bit) ANSI  Grigory Filatov <gfilatov@inbox.ru>
    Versão Harbour/xHarbour: Harbour 3.2.0dev (r2104281802)
    Compilador : MinGW GNU C 11.1 (32-bit)
    ----------------------------------------------------------------------------------------------
    SOBRE ESTE CÓDIGO:
    Alteração : 05/05/2021-15:41:31 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    Conversão de DBF para SQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

function atendentes()
    Local aHeader:={"Código","Nome","%Comissão"}
    Private Rs:=Rs.New()
    
    Load window Form_Pesquisa as Form_atendentes
        Form_Atendentes.Title := "Atendentes ou Garçons"
        on key F5 of Form_Atendentes action dados(1)
        on key F6 of Form_Atendentes action dados(2)
        on key F7 of Form_Atendentes action excluir()
        on key F8 of Form_Atendentes action relacao()
        on key escape  of Form_Atendentes  action thiswindow.release        
        form_atendentes.center
    form_atendentes.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := Form_Atendentes.Grid_Pesquisa.Item(Form_Atendentes.Grid_Pesquisa.value)[1]
    local titulo     := ''
    local x_nome     := ''
    local x_comissao := 0
    
    if parametro == 1
        titulo := 'Incluir'
    elseif parametro == 2
        titulo := 'Alterar'
        Rs.SQL:="Select nome,comissao from atendentes where codigo="+cId
        Rs.Open()
        if Rs.ErrorSQL()
            Return .F.
        endif
        if !Rs.Eof()
            x_nome     := Rs.Field.nome.value
            x_comissao := Rs.Field.comissao.value
        else
            msgexclamation('Selecione uma informação','Atenção')
            return(nil)
        endif
    endif
    Load Window atendentes_form_dados as Form_dados
        Form_Dados.Title := titulo
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate

    return(nil)
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=Form_Atendentes.Grid_Pesquisa.Item(Form_Atendentes.Grid_Pesquisa.value)[1]
    
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from atendentes where codigo="+cId)
    if Rs.ErrorSQL()
        Return .F.
    endif
    atualizar()
    Return .T.
    *-------------------------------------------------------------------------------
static function relacao()
    local p_linha := 040
    local u_linha := 260
    local linha   := p_linha
    local pagina  := 1
    
    Rs.SQL:="Select * from atendentes order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    SELECT PRINTER DIALOG PREVIEW
    
    START PRINTDOC NAME 'Gerenciador de impressão'
        START PRINTPAGE
        
        cabecalho(pagina)
        
        while !Rs.Eof()
            
            @ linha,030 PRINT strzero(rs.Field.codigo.value,4) FONT 'courier new' SIZE 010
            @ linha,045 PRINT Rs.Field.nome.value FONT 'courier new' SIZE 010
            @ linha,090 PRINT trans(Rs.Field.comissao.value,'@R 999.99') FONT 'courier new' SIZE 010
            
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
    @ 010,070 PRINT 'RELAÇÃO DE ATENDENTES/GARÇONS' FONT 'courier new' SIZE 018 BOLD
    @ 018,070 PRINT 'ordem alfabética' FONT 'courier new' SIZE 014
    @ 024,070 PRINT 'página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012
    
    @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK
    
    @ 035,030 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
    @ 035,045 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD
    @ 035,090 PRINT 'COMISSÃO (%)' FONT 'courier new' SIZE 010 BOLD
    
    return(nil)
    *-------------------------------------------------------------------------------
static function rodape()
    
    @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR BLACK
    @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar(parametro)
    if empty(form_dados.tbox_001.value)
        msgalert('Preencha todos os campos','Atenção')
        Return FALSE
    endif
    
    if parametro == 1
        Rs.AddNew()
    endif
    Rs.Field.nome.value     := form_dados.tbox_001.value
    Rs.Field.comissao.value := form_dados.tbox_002.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return TRUE
    *-------------------------------------------------------------------------------
static function atualizar()
    form_atendentes.Grid_Pesquisa.disableupdate
    delete item all from Grid_Pesquisa of form_atendentes
    Rs.SQL := "Select top 100 * from atendentes where nome like '"+form_atendentes.tbox_pesquisa.value+"%' order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value),alltrim(Rs.Field.nome.value),trans(Rs.Field.comissao.value,'@R 999.99')} to Grid_Pesquisa of form_atendentes
        Rs.MoveNext()
    end
    form_atendentes.Grid_Pesquisa.ColumnsAutoFit()
    form_atendentes.Grid_Pesquisa.ColumnsAutoFitH()
    form_atendentes.Grid_Pesquisa.enableupdate
    
    return(nil)
