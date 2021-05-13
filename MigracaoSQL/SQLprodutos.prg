/*
  sistema     : superchef pizzaria
  programa    : produtos
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
    Última alteração : 10/05/2021-17:37:31 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
Declare Cursor SQLADo rs1
memvar Rs

function Produtos()
    Local aHeader:={'Pizza','Promoção','Baixa','Código','Código Barra','Nome (longo)','Qtd.Estoque'}
    Private Rs:=Rs.New()
    Load window Form_Pesquisa as form_produtos
        form_produtos.Title := "Produtos"
        form_produtos.button_sair.col := 719
        define buttonex button_fornecedores
            parent form_produtos
            picture 'fornecedores'
            col 515
            row 002
            width 100
            height 100
            caption 'Fornecedores'
            action fornecedores_produto()
            fontname 'verdana'
            fontsize 009
            fontbold .T.
            fontcolor BLACK
            vertical .T.
            flat .T.
            noxpstyle .T.
            backcolor WHITE
        end buttonex
        define buttonex button_compor
            parent form_produtos
            picture 'compor'
            col 617
            row 002
            width 100
            height 100
            caption 'Compor Prod.'
            action compor_produto()
            fontname 'verdana'
            fontsize 009
            fontbold .T.
            fontcolor BLACK
            vertical .T.
            flat .T.
            noxpstyle .T.
            backcolor WHITE
        end buttonex      
        form_produtos.rodape_001.row       := getdesktopheight()-090
        form_produtos.tbox_pesquisa.row    := getdesktopheight()-095
        form_produtos.tbox_pesquisa.col    := 160
        form_produtos.tbox_pesquisa.width  := 550
        form_produtos.rodape_002.row       := getdesktopheight()-085
        form_produtos.rodape_002.col       := getdesktopwidth()- 270
        form_produtos.grid_Pesquisa.width  := getdesktopwidth()
        form_produtos.grid_Pesquisa.height := getdesktopheight()-210
                
        on key F5      of form_produtos action dados(1)
        on key F6      of form_produtos action dados(2)
        on key F7      of form_produtos action excluir()
        on key F8      of form_produtos action relacao()
        on key escape  of form_produtos action thiswindow.release        
        form_produtos.maximize
    form_produtos.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := form_produtos.Grid_Pesquisa.Item(form_produtos.Grid_Pesquisa.value)[4]
    Local rs1.new()
    Load Window produtos_form_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        form_dados.tbox_001.enabled := .F.
        form_dados.tbox_010.enabled  := .F. //lancamento automatico
        if parametro=2
            Rs.SQL:="Select * from produtos where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := rs.field.codigo.value
                form_dados.tbox_004.value := rs.field.cbarra.value
                form_dados.tbox_002.value := rs.field.nome_longo.value
                form_dados.tbox_003.value := rs.field.nome_cupom.value
                form_dados.tbox_008.value := rs.field.categoria.value
                form_dados.tbox_009.value := rs.field.scategoria.value
                form_dados.tbox_013.value := rs.field.imposto.value
                form_dados.tbox_007.value := rs.field.baixa.value
                form_dados.tbox_010.value := rs.field.qtd_estoque.value
                form_dados.tbox_011.value := rs.field.qtd_min.value
                form_dados.tbox_012.value := rs.field.qtd_max.value
                form_dados.tbox_014.value := rs.field.vlr_custo.value
                form_dados.tbox_015.value := rs.field.vlr_venda.value
                form_dados.tbox_006.value := rs.field.promocao.value
                form_dados.tbox_005.value := rs.field.pizza.value
                
                rs1.SQL:="Select codigo,nome from grupo_apoio where codigo="+hb_ntos(rs.field.categoria.value)
                rs1.Open()
                if !Rs.Eof()
                    form_dados.tbox_008.additem(rs1.field.nome.value)
                    form_dados.tbox_008.cargo := {rs1.field.codigo.value}
                    form_dados.tbox_008.value := 1
                endif
                
                rs1.SQL:="Select codigo,nome from grupo_apoio where codigo="+hb_ntos(rs.field.scategoria.value)
                rs1.Open()
                if !Rs.Eof()
                    form_dados.tbox_009.additem(rs1.field.nome.value)
                    form_dados.tbox_009.cargo := {rs1.field.codigo.value}
                    form_dados.tbox_009.value := 1
                endif
                
                rs1.SQL:="Select codigo,nome from impostos where codigo="+hb_ntos(rs.field.imposto.value)
                rs1.Open()
                if !Rs.Eof()
                    form_dados.tbox_013.additem(rs1.field.nome.value)
                    form_dados.tbox_013.cargo := {rs1.field.codigo.value}
                    form_dados.tbox_013.value := 1
                endif
                
            endif      
        else
            rs.sql:="Select * from produtos where 1=2"
            rs.Open()
        endif
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function compor_produto()
    if form_produtos.Grid_Pesquisa.value=0
        Return Nil
    endif
    
    Load Window produtos_form_compor as form_compor
        form_compor.title := 'Compor produto : '+form_produtos.Grid_Pesquisa.Item(form_produtos.Grid_Pesquisa.value)[6]
        filtra_composicao()
        form_compor.center
    form_compor.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function filtra_composicao()
    Local rs1.new()
    delete item all from grid_mprima_composicao of form_compor
    if form_produtos.Grid_Pesquisa.value=0
        return .F.
    endif
    rs1.sql :="SELECT P.produto, P.materia_prima, M.nome as nomemateriaprima, P.quantidade, A.nome as nomeunidade "
    rs1.sql +="FROM grupo_apoio as A  INNER JOIN (materia_prima as M INNER JOIN produto_composto as P ON M.codigo = P.materia_prima) ON A.codigo = M.unidade "
    rs1.sql +="where P.produto="+form_produtos.Grid_Pesquisa.Item(form_produtos.Grid_Pesquisa.value)[4]
    rs1.Open()
    while !rs1.eof()
        add item {str(rs1.field.produto.value),;
                  str(rs1.field.materia_prima.value,6),;
                  rs1.field.nomemateriaprima.value,;
                  trans(rs1.field.quantidade.value,'@R 99,999.999'),;
                  rs1.field.nomeunidade.value} to grid_mprima_composicao of form_compor
        rs1.movenext()
    end
    
    return(nil)
    *-------------------------------------------------------------------------------
    
static function incluir_composicao()
    Load Window produtos_form_inccpo as form_inccpo
        form_inccpo.center
    form_inccpo.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar_composicao()
    Local cProduto:=form_produtos.grid_pesquisa.item(form_produtos.grid_pesquisa.value)[4]
    Local rs1.new()
    if form_inccpo.tbox_001.value=0
        MsgInfo("Necessário selecionar uma matéria prima !")
        form_inccpo.tbox_001.setfocus()
        return .F.
    endif
    rs1.sql:="Select * from produto_composto where produto="+cProduto+" and materia_prima="+hb_ntos(form_inccpo.tbox_001.cargo[form_inccpo.tbox_001.value])
    rs1.open()
    if rs1.eof()
        rs1.addnew()
        rs1.field.produto.value       := cProduto
        rs1.field.materia_prima.value := form_inccpo.tbox_001.cargo[form_inccpo.tbox_001.value]
    endif
    rs1.field.quantidade.value := form_inccpo.tbox_002.value
    Rs1.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif    
    filtra_composicao()
    form_inccpo.release
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=Form_produtos.Grid_Pesquisa.Item(Form_produtos.Grid_Pesquisa.value)[4]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from produtos where codigo="+cId)
    if Rs.ErrorSQL()
        Return .F.
    endif
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir_composicao()
    Local aItem          :=  form_compor.grid_mprima_composicao.item(form_compor.grid_mprima_composicao.value)
    Local cProduto       := aItem[1]
    Local cMateria_Prima := aItem[2]
    Local rs1.New()
    if form_compor.grid_mprima_composicao.value=0
        msgexclamation('Selecione uma informação','Atenção')
        return(nil)
    endif
    rs1.Execute("Delete from produto_composto where produto="+cProduto+" and materia_prima="+cMateria_Prima+";")
    rs1.ErrorSQL()
    filtra_composicao()
    return(nil)
    *-------------------------------------------------------------------------------
static function relacao()
    
    local p_linha := 040
    local u_linha := 260
    local linha   := p_linha
    local pagina  := 1
    
    Rs.SQL:="Select * from produtos order by nome_longo"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    SELECT PRINTER DIALOG PREVIEW
    
    START PRINTDOC NAME 'Gerenciador de impressão'
        START PRINTPAGE
        
        cabecalho(pagina)
        
        while !rs.eof()
            
            @ linha,010 PRINT str(rs.field.codigo.value,6) FONT 'courier new' SIZE 010
            @ linha,030 PRINT rs.field.nome_longo.value FONT 'courier new' SIZE 010
            @ linha,110 PRINT iif(rs.field.pizza.value,'Sim','Não') FONT 'courier new' SIZE 010
            @ linha,140 PRINT iif(rs.field.baixa.value,'Sim','Não') FONT 'courier new' SIZE 010
            @ linha,170 PRINT str(rs.field.qtd_estoque.value,6) FONT 'courier new' SIZE 010
            
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
    @ 010,070 PRINT 'RELAÇÃO DE PRODUTOS (simples)' FONT 'courier new' SIZE 018 BOLD
    @ 018,070 PRINT 'ordem alfabética' FONT 'courier new' SIZE 014
    @ 024,070 PRINT 'página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012
    
    @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK
    
    @ 035,010 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
    @ 035,030 PRINT 'NOME (longo)' FONT 'courier new' SIZE 010 BOLD
    @ 035,110 PRINT 'PIZZA' FONT 'courier new' SIZE 010 BOLD
    @ 035,140 PRINT 'BAIXA EST.' FONT 'courier new' SIZE 010 BOLD
    @ 035,170 PRINT 'QTD. EST.' FONT 'courier new' SIZE 010 BOLD
    
    return(nil)
    *-------------------------------------------------------------------------------
static function rodape()
    
    @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR BLACK
    @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar(parametro)
    Local cMsg:="",cFocus:=""
    if empty(form_dados.tbox_002.value)
        cMsg :="Falta preencher nome "+CRLF
        cFocus := "Tbox_002"
    endif
    if form_dados.tbox_008.value=0
        cMsg += "Selecione uma categoria"+CRLF
        if empty(cMsg)
            cFocus:="tbox_008"
        endif
    endif
    if  form_dados.tbox_009.value=0
        cMsg += "Selecione uma sub-categoria"+CRLF
        if empty(cFocus)
            cFocus:="tbox_009"
        endif
    endif
    if form_dados.tbox_013.value=0
        cMsg += "Selecione o imposto"+CRLF
        if empty(cFocus)
            cFocus:="tbox_013"
        endif
    endif
    if !empty(cMsg)
        MsgStop(cMsg,"Atenção")
        Form_dados.&(cFocus).SetFocus()
        Return .F.
    endif
    if parametro == 1
        Rs.Addnew()
    endif
    rs.field.cbarra.value     := form_dados.tbox_004.value
    rs.field.nome_longo.value := form_dados.tbox_002.value
    rs.field.nome_cupom.value := form_dados.tbox_003.value
    rs.field.categoria.value  := form_dados.tbox_008.cargo[form_dados.tbox_008.value]
    rs.field.scategoria.value := form_dados.tbox_009.cargo[form_dados.tbox_009.value]
    rs.field.imposto.value    := form_dados.tbox_013.cargo[form_dados.tbox_013.value]
    rs.field.baixa.value      := form_dados.tbox_007.value
    rs.field.qtd_estoque.value  := form_dados.tbox_010.value
    rs.field.qtd_min.value    := form_dados.tbox_011.value
    rs.field.qtd_max.value    := form_dados.tbox_012.value
    rs.field.vlr_custo.value  := form_dados.tbox_014.value
    rs.field.vlr_venda.value  := form_dados.tbox_015.value
    rs.field.promocao.value   := form_dados.tbox_006.value
    rs.field.pizza.value      := form_dados.tbox_005.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
static function atualizar()
    form_produtos.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_produtos
    Rs.SQL:="Select * from produtos where nome_longo like '"+form_produtos.tbox_pesquisa.value+"%' order by nome_longo"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {iif(rs.field.pizza.value,"Sim","Não"),;
        iif(rs.field.promocao.value,"Sim","Não"),;
        iif(rs.field.baixa.value,"Sim","Não"),;
        str(Rs.Field.codigo.value,10),;
        Rs.Field.cbarra.value,;
        Rs.Field.nome_longo.value,;
        str(Rs.Field.qtd_estoque.value,6)} to Grid_Pesquisa of form_produtos
        Rs.MoveNext()
    end
    form_produtos.Grid_Pesquisa.ColumnsAutoFit()
    form_produtos.Grid_Pesquisa.ColumnsAutoFitH()    
    form_produtos.Grid_Pesquisa.enableupdate
    return(nil)
    *-------------------------------------------------------------------------------
static function fornecedores_produto()
    if form_produtos.Grid_Pesquisa.value=0
        return .F.
    endif
    Load Window produtos_form_fornecedor_produto as form_fornecedor_produto
        form_fornecedor_produto.title := "Fornecedores de : "+form_produtos.Grid_Pesquisa.item(form_produtos.Grid_Pesquisa.value)[6]
        filtra_fornecedor()
        form_fornecedor_produto.center
    form_fornecedor_produto.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function filtra_fornecedor()
    msgstop("em desenvolvimento")
    /*
    local x_old_fornecedor // := 0
    
    delete item all from grid_fornecedor_produto of form_fornecedor_produto
    
    dbselectarea('tcompra1')
    index on fornecedor to indcpa11 for produto == parametro
    go top
    
    while .not. eof()
        x_old_fornecedor := fornecedor
        skip
        if fornecedor <> x_old_fornecedor
            add item {acha_fornecedor_2(x_old_fornecedor)} to grid_fornecedor_produto of form_fornecedor_produto
        endif
    end
    */
    return(nil)
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_008_Onlistdisplay( ) //categoria
    Local rs1.new()
    form_dados.tbox_008.deleteAllitems()
    form_dados.tbox_008.cargo:={}
    rs1.SQL:="Select codigo,nome from grupo_apoio where tabela=1 and nome like '"+form_dados.tbox_008.displayvalue+"%'"
    rs1.Open()
    While !rs1.eof()
        form_dados.tbox_008.additem(rs1.field.nome.value)
        AADD(form_dados.tbox_008.cargo,rs1.field.codigo.value)
        rs1.MoveNext()
    enddo
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_008_Onenter( )
    if form_dados.tbox_008.value > 0
        return .T.
    endif
    PostMessage(form_dados.tbox_008.handle,(320+15),1,0)
    form_dados.tbox_008.setfocus()    
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_009_Onlistdisplay( )
    Local rs1.new()
    form_dados.tbox_009.deleteAllitems()
    form_dados.tbox_009.cargo:={}
    rs1.SQL:="Select codigo,nome from grupo_apoio where tabela=2 and nome like '"+form_dados.tbox_009.displayvalue+"%'"
    rs1.Open()
    While !rs1.eof()
        form_dados.tbox_009.additem(rs1.field.nome.value)
        AADD(form_dados.tbox_009.cargo,rs1.field.codigo.value)
        rs1.MoveNext()
    enddo    
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_009_Onenter( )
    if form_dados.tbox_009.value > 0
        return .T.
    endif
    PostMessage(form_dados.tbox_009.handle,(320+15),1,0)
    form_dados.tbox_009.setfocus() 
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_013_Onlistdisplay( )
    Local rs1.new()
    form_dados.tbox_013.deleteAllitems()
    form_dados.tbox_013.cargo:={}
    rs1.SQL:="Select codigo,nome from impostos where  nome like '"+form_dados.tbox_013.displayvalue+"%'"
    rs1.Open()
    While !rs1.eof()
        form_dados.tbox_013.additem(rs1.field.nome.value)
        AADD(form_dados.tbox_013.cargo,rs1.field.codigo.value)
        rs1.MoveNext()
    enddo   
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_013_Onenter( )
    if form_dados.tbox_013.value > 0
        return .T.
    endif
    PostMessage(form_dados.tbox_013.handle,(320+15),1,0)
    form_dados.tbox_013.setfocus() 
    Return .T.


    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_inccpo_tbox_001_Onlistdisplay( )
    Local rs1.new()
    form_inccpo.tbox_001.deleteAllitems()
    form_inccpo.tbox_001.cargo:={}
    rs1.SQL:="Select codigo,nome from materia_prima where  nome like '"+form_inccpo.tbox_001.displayvalue+"%'"
    rs1.Open()
    While !rs1.eof()
        form_inccpo.tbox_001.additem(rs1.field.nome.value)
        AADD(form_inccpo.tbox_001.cargo,rs1.field.codigo.value)
        rs1.MoveNext()
    enddo    
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_inccpo_tbox_001_Onenter( )
    if form_inccpo.tbox_001.value > 0
        return .T.
    endif
    PostMessage(form_inccpo.tbox_001.handle,(320+15),1,0)
    form_inccpo.tbox_001.setfocus() 
    Return .T.
