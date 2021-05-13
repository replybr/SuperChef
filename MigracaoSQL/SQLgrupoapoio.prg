/*
  sistema     : superchef pizzaria
  programa    : categoria produtos
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
    Última alteração : 06/05/2021-19:02:40 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */

#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

function categoria_produtos()
    GrupoApoio(1,"Categoria Produtos")
    Return .t.
function subcategoria_produtos()
    GrupoApoio(2,"SubCategoria de Produtos")
    Return .T.
function unidades_medida()
    GrupoApoio(3,"Unidade de Medida")
    Return .T.
function grupo_fornecedores()
    GrupoApoio(4,"Grupo de fornecedores")
    Return .T.
function mesas()
    GrupoApoio(5,"Cadastro de Mesas")
    Return .T.

    //////////////////////////////////////////////////////////////////////////
    *************************************************************************
    //////////////////////////////////////////////////////////////////////////
Static function GrupoApoio(nTabela,cTitle)
    Local aHeader:={'Código','Nome'}
    Private Rs:=Rs.New()
    Load window Form_Pesquisa as form_apoio
        form_apoio.cargo := nTabela
        form_apoio.Title := cTitle
        on key F5      of form_apoio action dados(1)
        on key F6      of form_apoio action dados(2)
        on key F7      of form_apoio action excluir()
        on key F8      of form_apoio action relacao()
        on key escape  of form_apoio action thiswindow.release
        form_apoio.center
    form_apoio.activate
    return(nil)
        
        *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := Form_apoio.Grid_Pesquisa.Item(Form_apoio.Grid_Pesquisa.value)[1]
    Load Window grupoapoio_form_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from grupo_apoio where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := Rs.Field.nome.value
            endif        
        endif    
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
        form_dados.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=Form_apoio.Grid_Pesquisa.Item(Form_apoio.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from grupo_apoio where codigo="+cId)
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
    
    Rs.SQL:="Select * from grupo_apoio where tabela="+hb_ntos(form_apoio.cargo)+" order by nome"
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
    @ 010,070 PRINT 'RELAÇÃO DE '+Upper(form_apoio.title) FONT 'courier new' SIZE 018 BOLD
    @ 018,070 PRINT 'ordem alfabética' FONT 'courier new' SIZE 014
    @ 024,070 PRINT 'página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012
    
    @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK
    
    @ 035,030 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
    @ 035,045 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD
    
    return(nil)
    *-------------------------------------------------------------------------------
static function rodape()
    
    @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR BLACK
    @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar(parametro)
    if empty(form_dados.tbox_001.value)
        msgalert('Preencha o campo','Atenção')
        return FALSE
    endif
    if parametro == 1
        Rs.AddNew()
        Rs.field.tabela.value := form_apoio.cargo
    endif
    rs.field.nome.value := form_dados.tbox_001.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return(nil)    
    *-------------------------------------------------------------------------------
static function atualizar()
    form_apoio.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_apoio
    Rs.SQL:="Select * from grupo_apoio where tabela="+hb_ntos(form_apoio.cargo)+" and nome like '"+form_apoio.tbox_pesquisa.value+"%' order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value,4),Rs.Field.nome.value} to Grid_Pesquisa of form_apoio
        Rs.MoveNext()
    end
    form_apoio.Grid_Pesquisa.ColumnsAutoFit()
    form_apoio.Grid_Pesquisa.ColumnsAutoFitH()    
    form_apoio.Grid_Pesquisa.enableupdate
    
    return(nil)

