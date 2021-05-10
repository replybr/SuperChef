/*
  sistema     : superchef pizzaria
  programa    : fornecedores
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
    Última alteração : 06/05/2021-20:25:34 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
Declare Cursor SQLADO rspesquisa
memvar Rs

function fornecedores()
    Local aHeader:={'Código','Nome','Telefone fixo','Telefone celular'}
    Private Rs.New()
    Load window Form_Pesquisa as form_fornecedores
        form_fornecedores.Title := "Fornecedores"
        on key F5      of form_fornecedores action dados(1)
        on key F6      of form_fornecedores action dados(2)
        on key F7      of form_fornecedores action excluir()
        on key F8      of form_fornecedores action relacao()
        on key escape  of form_fornecedores action thiswindow.release        
        form_fornecedores.center
    form_fornecedores.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := Form_fornecedores.Grid_Pesquisa.Item(Form_fornecedores.Grid_Pesquisa.value)[1]
    Local RsPesquisa.New()
    Load Window fornecedores_form_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from fornecedores where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := Rs.field.nome.value
                form_dados.tbox_002.value := Rs.field.fixo.value
                form_dados.tbox_003.value := Rs.field.celular.value
                form_dados.tbox_004.value := Rs.field.endereco.value
                form_dados.tbox_005.value := Rs.field.numero.value
                form_dados.tbox_006.value := Rs.field.complem.value
                form_dados.tbox_007.value := Rs.field.bairro.value
                form_dados.tbox_008.value := Rs.field.cidade.value
                form_dados.tbox_009.value := Rs.field.uf.value
                form_dados.tbox_010.value := Rs.field.cep.value
                form_dados.tbox_011.value := Rs.field.email.value
                if !Empty(Rs.field.grupo.value)
                    rsPesquisa.SQL:="Select * from grupo_apoio where codigo="+hb_ntos(Rs.field.grupo.value)
                    rsPesquisa.Open()
                    if !RsPesquisa.Eof()
                        form_dados.tbox_012.DeleteallItems()
                        form_dados.tbox_012.cargo:={Rs.field.grupo.value}
                        form_dados.tbox_012.addItem(RsPesquisa.field.nome.value)
                        form_dados.tbox_012.value := 1                
                    endif
                endif
            endif        
        endif    
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=Form_fornecedores.Grid_Pesquisa.Item(Form_fornecedores.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from fornecedores where codigo="+cId)
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
    
    Rs.SQL:="Select * from Fornecedores order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    SELECT PRINTER DIALOG PREVIEW
    
    START PRINTDOC NAME 'Gerenciador de impressão'
        START PRINTPAGE
        
        cabecalho(pagina)
        
        while .not. eof()
            
            @ linha,010 PRINT strzero(Rs.field.codigo.value,4) FONT 'courier new' SIZE 010
            @ linha,025 PRINT Rs.field.nome.value FONT 'courier new' SIZE 010
            @ linha,100 PRINT Rs.field.fixo.value FONT 'courier new' SIZE 010
            @ linha,130 PRINT Rs.field.celular.value FONT 'courier new' SIZE 010
            @ linha,160 PRINT Rs.field.cidade.value FONT 'courier new' SIZE 010
            
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
    @ 010,070 PRINT 'RELAÇÃO DE FORNECEDORES' FONT 'courier new' SIZE 018 BOLD
    @ 018,070 PRINT 'ordem alfabética' FONT 'courier new' SIZE 014
    @ 024,070 PRINT 'página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012
    
    @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK
    
    @ 035,010 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
    @ 035,025 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD
    @ 035,100 PRINT 'TEL.FIXO' FONT 'courier new' SIZE 010 BOLD
    @ 035,130 PRINT 'TEL.CELULAR' FONT 'courier new' SIZE 010 BOLD
    @ 035,160 PRINT 'CIDADE' FONT 'courier new' SIZE 010 BOLD
    
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
    if empty(form_dados.tbox_002.value)
        cMsg += "Telefone fixo deve ser preenchido"+CRLF
        if empty(cFocus)
            cFocus:="tbox_002"
        endif
    endif
    if form_dados.tbox_012.value = 0
        cMsg += "Grupo de fornecedores deve ser informado"+CRLF
        if empty(cFocus)
            cFocus:="tbox_012"
        endif        
    endif
    
    if !Empty(cMsg)
        msgalert(cMsg,'Atenção')
        Form_dados.&(cFocus).Setfocus()
        return(nil)
    endif
    
    if parametro == 1
        Rs.AddNew()
    endif
    Rs.field.nome.value     := form_dados.tbox_001.value
    Rs.field.fixo.value     := form_dados.tbox_002.value
    Rs.field.celular.value  := form_dados.tbox_003.value
    Rs.field.endereco.value := form_dados.tbox_004.value
    Rs.field.numero.value   := form_dados.tbox_005.value
    Rs.field.complem.value  := form_dados.tbox_006.value
    Rs.field.bairro.value   := form_dados.tbox_007.value
    Rs.field.cidade.value   := form_dados.tbox_008.value
    Rs.field.uf.value       := form_dados.tbox_009.value
    Rs.field.cep.value      := form_dados.tbox_010.value
    Rs.field.email.value    := form_dados.tbox_011.value
    if form_dados.tbox_012.value >0
        Rs.field.grupo.value    := form_dados.tbox_012.cargo[form_dados.tbox_012.value]
    endif
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
static function atualizar()
    form_fornecedores.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_fornecedores
    Rs.SQL:="Select * from fornecedores where nome like '"+form_fornecedores.tbox_pesquisa.value+"%' order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs.field.codigo.value) , Rs.field.nome.value , Rs.field.fixo.value , Rs.field.celular.value} to grid_Pesquisa of form_fornecedores
        Rs.MoveNext()
    end
    form_fornecedores.Grid_Pesquisa.ColumnsAutoFit()
    form_fornecedores.Grid_Pesquisa.ColumnsAutoFitH()    
    form_fornecedores.Grid_Pesquisa.enableupdate
    return(nil)
    *-------------------------------------------------------------------------------
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_012_Onlistdisplay( )
    Local Rspesquisa.New()
    RsPesquisa.SQL:="Select top 30 codigo,nome from grupo_apoio where tabela=4 and nome like '"+form_dados.tbox_012.displayvalue+"%'"
    Gravalog(RsPesquisa.SQL)
    RsPesquisa.Open()
    Form_dados.tbox_012.DeleteallItems()
    Form_dados.tbox_012.Cargo:={}
    While !RsPesquisa.Eof()
        Form_dados.tbox_012.addItem(RsPesquisa.field.nome.value)
        AADD(Form_dados.tbox_012.cargo,RsPesquisa.field.codigo.value)
        RsPesquisa.MoveNext()
    enddo
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_012_Onenter( )
    if form_dados.tbox_012.value >0
        Return .T.
    endif
    PostMessage(form_dados.tbox_012.handle,(320+15),1,0)
    form_dados.tbox_012.setfocus()
    Return .T.
