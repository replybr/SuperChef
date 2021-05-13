/*
  sistema     : superchef pizzaria
  programa    : formas de pagamento
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
    Última alteração : 07/05/2021-13:18:25 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */

#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
Declare Cursor SQLAdo rs1
memvar Rs

function formas_pagamento()
    Forma_Pag_Rec("P")
    Return .t.
function formas_recebimento()
    Forma_Pag_Rec("R")
    Return .t.
    //////////////////////////////////////////////////////////////////////////
    *************************************************************************
    //////////////////////////////////////////////////////////////////////////
Static function Forma_Pag_Rec(cTabela)
    Local aHeader:={'Código','Nome','Banco','Dias p/pag.'}
    Private Rs:=Rs.New()
    Load window Form_Pesquisa as form_formas_pagamento
        form_formas_pagamento.cargo := cTabela
        Do case
            Case cTabela="P" 
                form_formas_pagamento.Title := "Formas de Pagamento"
            Case cTabela="R" 
                form_formas_pagamento.Title := "Formas de Recebimento"
        EndCase
        on key F5      of form_formas_pagamento action dados(1)
        on key F6      of form_formas_pagamento action dados(2)
        on key F7      of form_formas_pagamento action excluir()
        on key F8      of form_formas_pagamento action relacao()
        on key escape  of form_formas_pagamento action thiswindow.release
        form_formas_pagamento.center
    form_formas_pagamento.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := form_formas_pagamento.Grid_Pesquisa.Item(form_formas_pagamento.Grid_Pesquisa.value)[1]
    Local rs1.new()
    Load Window formas_pag_rec_form_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from forma_pag_rec where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := Rs.Field.nome.value
                form_dados.tbox_004.value := Rs.Field.dias_paga.value
                
                rs1.SQL := "Select codigo,nome from bancos where codigo="+hb_ntos(Rs.field.banco.value)
                rs1.Open()
                if !Rs1.Eof()
                    form_dados.tbox_003.addItem(rs1.field.nome.value)
                    Form_dados.tbox_003.cargo := {rs1.field.codigo.value}
                    Form_dados.tbox_003.value := 1
                endif
            endif    
        else
            //Necessario iniciar por conta da funcao atualizar ser uma consulta com join
            Rs.SQL := "Select * from forma_pag_rec where 1=2"
            Rs.oPEN()
        endif    
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
        form_dados.activate
    Return(Nil)
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=form_formas_pagamento.Grid_Pesquisa.Item(form_formas_pagamento.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from forma_pag_rec where codigo="+cId)
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
    
    Rs.SQL:="SELECT F.codigo, F.nome, B.nome as nomebanco, F.dias_paga FROM bancos as B INNER JOIN forma_pag_rec as F ON B.codigo = F.banco "
    Rs.SQL += "Where F.tipo='"+form_formas_pagamento.cargo+"' order by F.nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    SELECT PRINTER DIALOG PREVIEW
    
    START PRINTDOC NAME 'Gerenciador de impressão'
        START PRINTPAGE
        
        cabecalho(pagina)
        
        while !Rs.eof()
            
            @ linha,030 PRINT strzero(rs.field.codigo.value,4) FONT 'courier new' SIZE 010
            @ linha,050 PRINT rs.field.nome.value FONT 'courier new' SIZE 010
            @ linha,110 PRINT rs.field.nomebanco.value FONT 'courier new' SIZE 010
            @ linha,170 PRINT hb_ntos(rs.field.dias_paga.value) FONT 'courier new' SIZE 010
            
            linha += 5
            
            if linha >= u_linha
                END PRINTPAGE
                START PRINTPAGE
                pagina ++
                cabecalho(pagina)
                linha := p_linha
            endif
            
            rs.MoveNext()
            
        end
        
        rodape()
        
        END PRINTPAGE
    END PRINTDOC
    
    return(nil)
    *-------------------------------------------------------------------------------
static function cabecalho(p_pagina)
    
    @ 007,010 PRINT IMAGE 'logotipo' WIDTH 050 HEIGHT 020 STRETCH
    @ 010,070 PRINT 'RELAÇÃO DE FORMAS DE '+IIF(form_formas_pagamento.cargo="P","PAGAMENTO","RECEBIMENTO") FONT 'courier new' SIZE 018 BOLD
    @ 018,070 PRINT 'ordem alfabética' FONT 'courier new' SIZE 014
    @ 024,070 PRINT 'página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012
    
    @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK
    
    @ 035,030 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
    @ 035,050 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD
    @ 035,110 PRINT 'BANCO/CONTA' FONT 'courier new' SIZE 010 BOLD
    @ 035,170 PRINT 'DIAS P/PAG.' FONT 'courier new' SIZE 010 BOLD
    
    return(nil)
    *-------------------------------------------------------------------------------
static function rodape()
    
    @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR BLACK
    @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar(parametro)
    Local cMsg:="",cFocus
    
    if empty(form_dados.tbox_001.value)
        cMsg += "Nome deve ser preenchido"+CRLF
        cFocus:="tbox_001"
    endif
    if empty(form_dados.tbox_003.value)
        cMsg += "Banco deve ser informado"+CRLF
        if empty(cFocus)
            cFocus := "tbox_003"
        endif
    endif
    if empty(form_dados.tbox_004.value)
        cMsg += "Quantidade de dias deve ser informado"+CRLF
        if empty(cFocus)
            cFocus := "tbox_004"
        endif
    endif
    
    if !Empty(cMsg)
        msgalert(cMsg,'Atenção')
        form_dados.&(cFocus).Setfocus()
        return(nil)
    endif
    if parametro == 1
        Rs.AddNew()
        Rs.field.tipo.value := form_formas_pagamento.cargo
    endif
    rs.field.nome.value      := form_dados.tbox_001.value
    rs.field.banco.value     := Form_dados.tbox_003.cargo[form_dados.tbox_003.value]
    rs.field.dias_paga.value := form_dados.tbox_004.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return(nil)     
    *-------------------------------------------------------------------------------
static function atualizar()
    form_formas_pagamento.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_formas_pagamento
    Rs.SQL:="SELECT F.codigo, F.nome, B.nome as nomebanco, F.dias_paga FROM bancos as B INNER JOIN forma_pag_rec as F ON B.codigo = F.banco "
    Rs.SQL += "where F.tipo='"+(form_formas_pagamento.cargo)+"' and F.nome like '"+form_formas_pagamento.tbox_pesquisa.value+"%' order by F.nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value,4),Rs.Field.nome.value,rs.field.nomebanco,str(rs.field.dias_paga)} to Grid_Pesquisa of form_formas_pagamento
        Rs.MoveNext()
    end
    form_formas_pagamento.Grid_Pesquisa.ColumnsAutoFit()
    form_formas_pagamento.Grid_Pesquisa.ColumnsAutoFitH()    
    form_formas_pagamento.Grid_Pesquisa.enableupdate
    
    return(nil)
    *-------------------------------------------------------------------------------

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_003_Onlistdisplay( )
    Local rs1.new()
    rs1.SQL := "Select codigo,nome from bancos where nome like '"+Form_dados.tbox_003.Displayvalue+"%'"
    rs1.Open()
    Form_dados.tbox_003.deleteAllItems()
    Form_dados.tbox_003.Cargo := {}
    While !rs1.Eof()
        Form_dados.tbox_003.addItem(rs1.field.nome.value)
        AADD(Form_dados.tbox_003.cargo,rs1.field.codigo.value)
        rs1.MoveNext()
    enddo
    Return .T.
