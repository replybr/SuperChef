/*
  sistema     : superchef pizzaria
  programa    : motoboys/entregadores
  compilador  : xharbour 1.2 simplex
  lib gráfica : minigui 1.7 extended
  programador : marcelo neves
*/

#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

function motoboys_entregadores()
    Local aHeader:={'Código','Nome','Telefone fixo','Telefone celular'}
    Private Rs:=Rs.New()
    Load window Form_Pesquisa as form_motoboys
        form_motoboys.Title := "Motoboys ou Entregadores"
        on key F5      of form_motoboys action dados(1)
        on key F6      of form_motoboys action dados(2)
        on key F7      of form_motoboys action excluir()
        on key F8      of form_motoboys action relacao()
        on key escape  of form_motoboys action thiswindow.release        
        form_motoboys.center
    form_motoboys.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := form_motoboys.Grid_Pesquisa.Item(form_motoboys.Grid_Pesquisa.value)[1]
    Load Window motoboys_form_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from motoboys where codigo="+cId
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
                form_dados.tbox_013.value := Rs.field.diaria.value  
                form_dados.oAtivo.value   := Rs.field.ativo.value
            else
                form_dados.tbox_009.value := "PR"
            endif        
        endif
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=form_motoboys.Grid_Pesquisa.Item(form_motoboys.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from motoboys where codigo="+cId)
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
    
    Rs.SQL:="Select * from motoboys order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    SELECT PRINTER DIALOG PREVIEW
    
    START PRINTDOC NAME 'Gerenciador de impressão'
        START PRINTPAGE
        
        cabecalho(pagina)
        
        while .not. eof()
            
            @ linha,010 PRINT strzero(rs.field.codigo.value,4) FONT 'courier new' SIZE 010
            @ linha,025 PRINT rs.field.nome.value FONT 'courier new' SIZE 010
            @ linha,100 PRINT rs.field.fixo.value FONT 'courier new' SIZE 010
            @ linha,130 PRINT rs.field.celular.value FONT 'courier new' SIZE 010
            @ linha,160 PRINT trans(rs.field.diaria.value,'@E 9,999.99') FONT 'courier new' SIZE 010
            
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
    @ 010,070 PRINT 'RELAÇÃO DE MOTOBOYS ou ENTREGADORES' FONT 'courier new' SIZE 018 BOLD
    @ 018,070 PRINT 'ordem alfabética' FONT 'courier new' SIZE 014
    @ 024,070 PRINT 'página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012
    
    @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK
    
    @ 035,010 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
    @ 035,025 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD
    @ 035,100 PRINT 'TEL.FIXO' FONT 'courier new' SIZE 010 BOLD
    @ 035,130 PRINT 'TEL.CELULAR' FONT 'courier new' SIZE 010 BOLD
    @ 035,160 PRINT 'DIÁRIA(R$)' FONT 'courier new' SIZE 010 BOLD
    
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
        cMsg += "Nome deve ser preechido."+CRLF
        cFocus := "tbox_001"
    endif
    if empty(form_dados.tbox_002.value)
        cMsg += "telefone fixo deve ser preenchido"
        if empty(cFocus)
            cFocus := "tbox_002"
        endif
    endif
    
    if !Empty(cMsg)
        msgalert(cMsg,'Atenção')
        form_dados.&(cFocus).Setfocus()
        return FALSE
    endif
    
    if parametro == 1
        Rs.AddNew()
    endif
    rs.field.nome.value     := form_dados.tbox_001.value
    rs.field.fixo.value     := form_dados.tbox_002.value
    rs.field.celular.value  := form_dados.tbox_003.value
    rs.field.endereco.value := form_dados.tbox_004.value
    rs.field.numero.value   := form_dados.tbox_005.value
    rs.field.complem.value  := form_dados.tbox_006.value
    rs.field.bairro.value   := form_dados.tbox_007.value
    rs.field.cidade.value   := form_dados.tbox_008.value
    rs.field.uf.value       := form_dados.tbox_009.value
    rs.field.cep.value      := form_dados.tbox_010.value
    rs.field.email.value    := form_dados.tbox_011.value
    rs.field.diaria.value   := form_dados.tbox_013.value
    rs.field.ativo.value    := form_dados.oAtivo.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()    
    return(nil)
    *-------------------------------------------------------------------------------
static function atualizar()
    form_motoboys.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_motoboys
    Rs.SQL:="Select * from motoboys where nome like '"+form_motoboys.tbox_pesquisa.value+"%' order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(rs.field.codigo.value),rs.field.nome.value,rs.field.fixo.value,rs.field.celular.value} to grid_Pesquisa of form_motoboys
        Rs.MoveNext()
    end
    form_motoboys.Grid_Pesquisa.ColumnsAutoFit()
    form_motoboys.Grid_Pesquisa.ColumnsAutoFitH()    
    form_motoboys.Grid_Pesquisa.enableupdate
    return(nil)


