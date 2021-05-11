/*
  sistema     : superchef pizzaria
  programa    : matéria prima
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
    Última alteração : 07/05/2021-17:17:54 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
Declare Cursor SQLADO rs1
memvar Rs

function materia_prima()
    Local aHeader:={'Código','Nome','Unidade','Preço R$','Qtd.'}
    Private Rs:=Rs.New()
    Load window Form_Pesquisa as form_materia_prima
        form_materia_prima.button_sair.col:=617
        define buttonex button_fornecedores
            parent form_materia_prima
            picture 'fornecedores'
            col 515
            row 002
            width 100
            height 100
            caption 'Fornecedores'
            action fornecedores_mprima()
            fontname 'verdana'
            fontsize 009
            fontbold .T.
            fontcolor BLACK
            vertical .T.
            flat .T.
            noxpstyle .T.
            backcolor WHITE
        end buttonex      
        
        form_materia_prima.Title := "Matéria Prima"
        on key F5      of form_materia_prima action dados(1)
        on key F6      of form_materia_prima action dados(2)
        on key F7      of form_materia_prima action excluir()
        on key F8      of form_materia_prima action relacao()
        on key escape  of form_materia_prima action thiswindow.release        
        form_materia_prima.center
    form_materia_prima.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := form_materia_prima.Grid_Pesquisa.Item(form_materia_prima.Grid_Pesquisa.value)[1]
    local rs1.new()
    if form_materia_prima.Grid_Pesquisa.value=0
        MsgInfo("Selecione uma linha para visualizar/editar")
        Return .F.
    endif
    Load Window materia_prima_form_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from materia_prima where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := rs.field.nome.value
                form_dados.tbox_003.value := rs.field.preco.value
                form_dados.tbox_004.value := rs.field.qtd.value      
                if !Empty(rs.field.unidade.value)
                    Rs1.SQL:="Select * from grupo_apoio where codigo="+hb_ntos(rs.field.unidade.value)
                    Rs1.Open()
                    if !Rs1.Eof()
                        form_dados.tbox_002.additem(rs1.field.nome.value)
                        form_dados.tbox_002.cargo := {rs.field.codigo.value}
                        form_dados.tbox_002.value := 1
                    endif
                endif
            endif   
        else
            Rs.SQL:="Select * from materia_prima where 1=2"
            Rs.Open()        
        endif
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    return(nil)    
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=form_materia_prima.Grid_Pesquisa.Item(form_materia_prima.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from materia_prima where codigo="+cId)
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
    
    Rs.SQL:="SELECT M.codigo, M.nome, A.nome as nomeunidade, M.preco, M.qtd FROM grupo_apoio as A INNER JOIN materia_prima as M ON A.codigo = M.unidade;"

    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    SELECT PRINTER DIALOG PREVIEW
    
    START PRINTDOC NAME 'Gerenciador de impressão'
        START PRINTPAGE
        
        cabecalho(pagina)
        
        while !rs.eof()
            
            @ linha,030 PRINT strzero(rs.field.codigo.value,4) FONT 'courier new' SIZE 010
            @ linha,045 PRINT rs.field.nome.value FONT 'courier new' SIZE 010
            @ linha,120 PRINT rs.field.nomeunidade.value FONT 'courier new' SIZE 010
            @ linha,150 PRINT trans(rs.field.preco.value,'@E 9,999.99') FONT 'courier new' SIZE 010
            @ linha,170 PRINT trans(rs.field.qtd.value,'@R 99,999.999') FONT 'courier new' SIZE 010
            
            linha += 5
            
            if linha >= u_linha
                END PRINTPAGE
                START PRINTPAGE
                pagina ++
                cabecalho(pagina)
                linha := p_linha
            endif
            
            rs.movenext()
            
        end
        
        rodape()
        
        END PRINTPAGE
    END PRINTDOC
    
    return(nil)
    *-------------------------------------------------------------------------------
static function cabecalho(p_pagina)
    
    @ 007,010 PRINT IMAGE 'logotipo' WIDTH 050 HEIGHT 020 STRETCH
    @ 010,070 PRINT 'RELAÇÃO DE MATÉRIA PRIMA' FONT 'courier new' SIZE 018 BOLD
    @ 018,070 PRINT 'ordem alfabética' FONT 'courier new' SIZE 014
    @ 024,070 PRINT 'página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012
    
    @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK
    
    @ 035,030 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
    @ 035,045 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD
    @ 035,120 PRINT 'UNIDADE' FONT 'courier new' SIZE 010 BOLD
    @ 035,150 PRINT 'PREÇO R$' FONT 'courier new' SIZE 010 BOLD
    @ 035,180 PRINT 'QTD.' FONT 'courier new' SIZE 010 BOLD
    
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
        cFocus:="tbox_001"
    endif
    if empty(form_dados.tbox_002.value)
        cMsg += "Falta preencher unidade "+CRLF
        if empty(cFocus)
            cFocus:="tbox_002"
        endif
    endif
    if empty(form_dados.tbox_003.value)
        cMsg += "Falta preencher preço"+CRLF
        if empty(cFocus)
            cFocus:="tbox_003"
        endif
    endif
    if empty(form_dados.tbox_004.value)
        cMsg += "Falta preencher Qtde"+CRLF
        if empty(cFocus)
            cFocus:="tbox_004"
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
    Rs.Field.unidade.value  := form_dados.tbox_002.cargo[form_dados.tbox_002.value]
    Rs.Field.preco.value    := form_dados.tbox_003.value
    Rs.Field.qtd.value      := form_dados.tbox_004.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
static function atualizar()
    form_materia_prima.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_materia_prima
    Rs.SQL := "SELECT M.codigo, M.nome, A.nome as nomeunidade, M.preco, M.qtd FROM grupo_apoio as A INNER JOIN materia_prima as M ON A.codigo = M.unidade"
    Rs.SQL += " where M.nome like '"+form_materia_prima.tbox_pesquisa.value+"%' order by M.nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value,4),Rs.Field.nome.value,Rs.Field.nomeunidade.value,trans(rs.field.preco.value,'@E 999,999.99'),trans(rs.field.qtd.value,'@R 99,999.999')} to Grid_Pesquisa of form_materia_prima
        Rs.MoveNext()
    end
    form_materia_prima.Grid_Pesquisa.ColumnsAutoFit()
    form_materia_prima.Grid_Pesquisa.ColumnsAutoFitH()    
    form_materia_prima.Grid_Pesquisa.enableupdate
    return(nil)
    *-------------------------------------------------------------------------------
Static Function form_dados_tbox_002_Onlistdisplay( )
    Local rs1.new()
    Rs1.SQL:="Select top 30 * from grupo_apoio where tabela=3 and nome like '"+form_materia_prima.tbox_pesquisa.value+"%' order by nome"
    Rs1.Open()
    form_dados.tbox_002.DeleteAllItems()
    form_dados.tbox_002.cargo:={}
    While !rs1.eof()
        form_dados.tbox_002.additem(rs1.field.nome.value)
        AADD(form_dados.tbox_002.cargo,rs1.field.codigo.value)
        rs1.moveNext()
    Enddo
    Return .T.
    *-------------------------------------------------------------------------------
static function fornecedores_mprima()
    local cId :=form_materia_prima.Grid_Pesquisa.Item(form_materia_prima.Grid_Pesquisa.value)[1]    
    if val(cId)=0
        msgexclamation('Escolha uma matéria prima','Atenção')
        return(nil)
    endif
    
    Load Window materia_prima_form_fornecedor_mprima as form_fornecedor_mprima
        form_fornecedor_mprima.title := "Fornecedores de : "+form_materia_prima.Grid_Pesquisa.Item(form_materia_prima.Grid_Pesquisa.value)[2]  
        filtra_fornecedor()
        form_fornecedor_mprima.center
    form_fornecedor_mprima.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function filtra_fornecedor(parametro)
    Msginfo("Em analise filtra_fornecedor=cargaGrid..."+tipovar(parametro))
/*    
    local x_old_fornecedor //:= 0
    
    delete item all from grid_fornecedor_mprima of form_fornecedor_mprima
    
    dbselectarea('tcompra2')
    index on fornecedor to indcpa12 for mat_prima == parametro
    go top
    
    while .not. eof()
        x_old_fornecedor := fornecedor
        skip
        if fornecedor <> x_old_fornecedor
            add item {acha_fornecedor_2(x_old_fornecedor)} to grid_fornecedor_mprima of form_fornecedor_mprima
        endif
    end
*/    
    return(nil)
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_002_Onenter( )
    if form_dados.tbox_002.value >0
        Return .T.
    endif
    PostMessage(form_dados.tbox_002.handle,(320+15),1,0)
    form_dados.tbox_002.setfocus()    
    Return .T.
