/*
  sistema     : superchef pizzaria
  programa    : clientes
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
    Última alteração : 06/05/2021-16:57:10 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */

#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

function clientes(lNew)
    Local nReg:=0,aHeader:={'Código','Nome','Telefone fixo','Telefone celular'}
    Private Rs:=Rs.New()
    if App.cargo["demonstracao"]
        Rs.SQL:="Select count(1) as Reg from Clientes"
        Rs.Open()
        nReg :=Rs.field.reg.value
    endif
    
    //Criação de novo cliente chamado diretamente sem a tela de pesquisa.
    lNew:=IIF(lNew=Nil,FALSE,lNew)
    
    if !lNew
        Load window Form_Pesquisa as Form_Clientes
            Form_Clientes.Title := "Clientes"
            If App.cargo["demonstracao"] .and. nReg >= App.cargo["limiteregistro"]
                Form_Clientes.button_incluir.enabled := FALSE
                Form_Clientes.button_incluir.tooltip := "Limite de registros esgotado"
            endif
            on key F5      of Form_Clientes action dados(1)
            on key F6      of Form_Clientes action dados(2)
            on key F7      of Form_Clientes action excluir()
            on key F8      of Form_Clientes action relacao()
            on key escape  of Form_Clientes action thiswindow.release        
            Form_Clientes.center
        Form_Clientes.activate
    else
        dados(1)
    endif
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId 
    if _isWindowdefined("form_clientes")
        if Form_clientes.Grid_Pesquisa.value = 0
            return .F.
        endif
        cId := Form_clientes.Grid_Pesquisa.Item(Form_clientes.Grid_Pesquisa.value)[1]
    endif

    Load Window clientes_form_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from Clientes where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()  
                form_dados.tbox_001.value := Rs.Field.nome.Value
                form_dados.tbox_002.value := Rs.Field.fixo.Value
                form_dados.tbox_003.value := Rs.Field.celular.Value
                form_dados.tbox_004.value := Rs.Field.endereco.Value
                form_dados.tbox_005.value := Rs.Field.numero.Value
                form_dados.tbox_006.value := Rs.Field.complem.Value
                form_dados.tbox_007.value := Rs.Field.bairro.Value
                form_dados.tbox_008.value := Rs.Field.cidade.Value
                form_dados.tbox_009.value := Rs.Field.uf.Value
                form_dados.tbox_010.value := Rs.Field.cep.Value
                form_dados.tbox_011.value := Rs.Field.email.Value
                form_dados.tbox_012.value := Rs.Field.aniv_dia.Value
                form_dados.tbox_013.value := Rs.Field.aniv_mes.Value            
            endif
        else
            form_dados.tbox_009.value := "PR"
            Rs.SQL:="Select * from Clientes where 1=2"
            Rs.Open()            
        endif
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=Form_clientes.Grid_Pesquisa.Item(Form_clientes.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from Clientes where codigo="+cId)
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
    
    Rs.SQL:="Select * from Clientes order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    SELECT PRINTER DIALOG PREVIEW
    
    START PRINTDOC NAME 'Gerenciador de impressão'
        START PRINTPAGE
        
        cabecalho(pagina)
        
        while !Rs.Eof()
            
            @ linha,010 PRINT strzero(Rs.Field.codigo.value,4) FONT 'courier new' SIZE 010
            @ linha,025 PRINT Rs.Field.nome.value FONT 'courier new' SIZE 010
            @ linha,100 PRINT Rs.Field.fixo.value FONT 'courier new' SIZE 010
            @ linha,130 PRINT Rs.Field.celular.value FONT 'courier new' SIZE 010
            @ linha,160 PRINT Rs.Field.cidade.value FONT 'courier new' SIZE 010
            
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
    @ 010,070 PRINT 'RELAÇÃO DE CLIENTES' FONT 'courier new' SIZE 018 BOLD
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
    if empty(form_dados.tbox_001.value)
        msgalert('Nome deve ser preenchido','Atenção')
        Return .F.
    endif
    if parametro == 1
        Rs.AddNew()
    endif
    Rs.Field.nome.value     := form_dados.tbox_001.value
    Rs.Field.fixo.value     := form_dados.tbox_002.value
    Rs.Field.celular.value  := form_dados.tbox_003.value
    Rs.Field.endereco.value := form_dados.tbox_004.value
    Rs.Field.numero.value   := form_dados.tbox_005.value
    Rs.Field.complem.value  := form_dados.tbox_006.value
    Rs.Field.bairro.value   := form_dados.tbox_007.value
    Rs.Field.cidade.value   := form_dados.tbox_008.value
    Rs.Field.uf.value       := form_dados.tbox_009.value
    Rs.Field.cep.value      := form_dados.tbox_010.value
    Rs.Field.email.value    := form_dados.tbox_011.value
    Rs.Field.aniv_dia.value := form_dados.tbox_012.value
    Rs.Field.aniv_mes.value := form_dados.tbox_013.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif    
    form_dados.release
    IF _isWindowdefined("form_clientes")
        atualizar()
    endif
    return(nil)
    *-------------------------------------------------------------------------------
static function atualizar()
    form_clientes.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_clientes
    Rs.SQL:="Select * from clientes where nome like '"+form_clientes.tbox_pesquisa.value+"%' order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif    
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value),Rs.Field.nome.value,Rs.Field.fixo.value,Rs.Field.celular.value} to grid_pesquisa of form_clientes
        Rs.MoveNext()
    end
    form_clientes.Grid_Pesquisa.ColumnsAutoFit()
    form_clientes.Grid_Pesquisa.ColumnsAutoFitH()    
    form_clientes.grid_Pesquisa.enableupdate
    
    return(nil)

