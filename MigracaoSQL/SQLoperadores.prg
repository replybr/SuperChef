/*
  sistema     : superchef pizzaria
  programa    : operadores do programa
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
    Última alteração : 07/05/2021-10:33:56 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
#Define DEFINE_ACESSO_MAX 43
Declare Cursor SQLADO rs
memvar Rs

function operadores()
    Local aHeader:={'Código','Nome'}
    Private Rs:=Rs.New()
    Load window Form_Pesquisa as Form_Operadores
        //tela padrao deve incluir um botao de acesso
        Form_Operadores.button_sair.col := 617
        define buttonex button_acessos
            parent Form_Operadores
            picture 'acessos'
            col 515
            row 002
            width 100
            height 100
            caption 'Acessos'
            action acesso()
            fontname 'verdana'
            fontsize 009
            fontbold .T.
            fontcolor  { 0 , 0 , 255 }
            vertical .T.
            flat .T.
            noxpstyle .T.
            backcolor { 255 , 255 , 255 }
        end buttonex
        
        Form_Operadores.Title := "Operadores do Programa"
        on key F5      of Form_Operadores action dados(1)
        on key F6      of Form_Operadores action dados(2)
        on key F7      of Form_Operadores action excluir()
        on key F8      of Form_Operadores action relacao()
        on key escape  of Form_Operadores action thiswindow.release        
        Form_Operadores.center
    Form_Operadores.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := Form_Operadores.Grid_Pesquisa.Item(Form_Operadores.Grid_Pesquisa.value)[1]
    Load Window operadores_form_dados as form_dados
    
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from operadores where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := Rs.Field.nome.value
                form_dados.tbox_002.value := Rs.Field.senha.value
            endif        
        endif
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=Form_Operadores.Grid_Pesquisa.Item(Form_Operadores.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    Rs.Execute("Delete from operadores where codigo="+cId)
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
    
    Rs.SQL:="Select * from Operadores order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    endif
    
    SELECT PRINTER DIALOG PREVIEW
    
    START PRINTDOC NAME 'Gerenciador de impressão'
        START PRINTPAGE
        
        cabecalho(pagina)
        
        while .not. eof()
            
            @ linha,030 PRINT strzero(rs.field.codigo.value,4) FONT 'courier new' SIZE 010
            @ linha,050 PRINT rs.field.nome.value FONT 'courier new' SIZE 010
            
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
    @ 010,070 PRINT 'RELAÇÃO DE OPERADORES' FONT 'courier new' SIZE 018 BOLD
    @ 018,070 PRINT 'ordem alfabética' FONT 'courier new' SIZE 014
    @ 024,070 PRINT 'página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012
    
    @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK
    
    @ 035,030 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
    @ 035,050 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD
    
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
        cMsg += "Nome deve ser informado"+CRLF
        cFocus:="tbox_001"
    endif
    if empty(form_dados.tbox_002.value)
        cMsg += "Senha deve ser informada"
        if empty(cFocus)
            cFocus:="tbox_002"
        endif
    endif
    
    if !empty(cMsg)
        msgalert(cMsg,'Atenção')
        form_dados.&(cfocus).setfocus()
        return(nil)
    endif
    
    if parametro == 1
        rs.addNew()
        rs.field.acesso.value := replicate("0",43)
    endif
    rs.field.nome.value  := form_dados.tbox_001.value
    rs.field.senha.value := form_dados.tbox_002.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
static function atualizar()
    Form_Operadores.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of Form_Operadores
    Rs.SQL:="Select * from operadores where nome like '"+Form_Operadores.tbox_pesquisa.value+"%' order by nome"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value,4),Rs.Field.nome.value} to Grid_Pesquisa of Form_Operadores
        Rs.MoveNext()
    end
    Form_Operadores.Grid_Pesquisa.ColumnsAutoFit()
    Form_Operadores.Grid_Pesquisa.ColumnsAutoFitH()    
    Form_Operadores.Grid_Pesquisa.enableupdate
    return(nil)
    *-------------------------------------------------------------------------------
    
static function acesso()
    local cId := Form_Operadores.Grid_Pesquisa.Item(Form_Operadores.Grid_Pesquisa.value)[1]
    Local nAcesso,cAcesso:=replicate("0",DEFINE_ACESSO_MAX),cCheck
    if val(cId)=0
        MsgStop("Selecione um operador para definir acesso !")
        Return .F.
    endif
    Load Window operadores_form_acesso as form_acesso
        Form_Acesso.title := "Definir acessos para "+Form_Operadores.Grid_Pesquisa.Item(Form_Operadores.Grid_Pesquisa.value)[2]
        Rs.SQL:="Select * from Operadores where codigo="+cId
        Rs.Open()
        if !Rs.ErrorSQL().and.!Rs.Eof()
            cAcesso:=rs.field.acesso.value
        endif                
        For nAcesso=1 to DEFINE_ACESSO_MAX
            cCheck:="chkbox_"+strzero(nAcesso,3)
            Form_Acesso.&(cCheck).Value := substr(cAcesso,nAcesso,1)="1"
        Next
        form_acesso.center
    form_acesso.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar_acesso()
    Local nAcesso,cCheck,cAcesso:=""
    For nAcesso=1 to DEFINE_ACESSO_MAX
        cCheck:="chkbox_"+strzero(nAcesso,3)
        cAcesso += IIF(Form_Acesso.&(cCheck).Value,"1","0")
    Next   
    rs.field.acesso.value := cAcesso
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif    
    form_acesso.release
    return(nil)

