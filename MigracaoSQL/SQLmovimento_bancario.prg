/*
  sistema     : superchef pizzaria
  programa    : movimentação bancária
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
    Última alteração : 12/05/2021-15:20:37 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
Declare Cursor SQLADO rs1
memvar Rs

function movimento_bancario()
    Private rs:=rs.new()
  
    Load Window movimento_bancario_movban as form_movban
        rs.SQL:="Select codigo,nome from bancos order by nome"
        rs.Open()
        form_movban.cbo_001.cargo:={}
        While !Rs.Eof()
            form_movban.cbo_001.addItem(rs.field.nome.value)
            AADD(form_movban.cbo_001.cargo,rs.field.codigo.value)
            rs.MoveNext()
        enddo
        form_movban.cbo_001.value := 1
        on key F5     of form_movban action dados(1)
        on key F6     of form_movban action dados(2)
        on key F7     of form_movban action excluir()
        on key escape of form_movban  action thiswindow.release
    end window
    
    form_movban.center
    form_movban.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := form_movban.Grid_Pesquisa.Item(form_movban.Grid_Pesquisa.value)[1]
    Local rs1.new()
    if form_movban.cbo_001.value=0
        MsgStop("Não existe um banco selecionado !")
        Return .F.
    endif    
    Load Window movimento_bancario_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from movimento_bancario where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := Rs.Field.dtMovimento.value
                form_dados.tbox_002.value := Rs.Field.historico.value
                form_dados.tbox_003.value := Rs.Field.entrada.value
                form_dados.tbox_004.value := Rs.Field.saida.value
                rs1.sql := "select nome from bancos where codigo="+hb_ntos(rs.field.banco.value)
                rs1.Open()
                if !rs1.eof()
                    form_dados.tbox_000.value := hb_ntos(rs.field.banco.value)+" . "+rs1.field.nome.value
                endif
            endif    
        else
            rs.sql:="select * from movimento_bancario where 1=2"
            rs.Open()
            form_dados.tbox_001.value := Date()
            form_dados.tbox_000.value := hb_ntos( form_movban.cbo_001.cargo[ form_movban.cbo_001.value])+" . "+ form_movban.cbo_001.displayvalue
        endif
        form_dados.tbox_002.setfocus()
        form_dados_tbox_003_Onchange( )
        form_dados_tbox_004_Onchange( )        
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    return(nil)    
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=Form_movban.Grid_Pesquisa.Item(Form_movban.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    if !msgYesNo("Historico :"+Form_movban.Grid_Pesquisa.Item(Form_movban.Grid_Pesquisa.value)[3],"Excluir")
        Return .F.
    endif
    Rs.Execute("Delete from movimento_bancario where codigo="+cId)
    if Rs.ErrorSQL()
        Return .F.
    endif
    atualizar()
    return(nil) 
    *-------------------------------------------------------------------------------
static function gravar(parametro)
    if form_movban.cbo_001.value=0
        MsgStop("Não existe um banco selecionado !")
        Return .F.
    endif
    if empty(form_dados.tbox_001.value)
        msginfo('Preencha a data','Atenção')
        form_dados.tbox_001.setfocus()
        return(nil)
    endif
    
    if empty(form_dados.tbox_002.value)
        msginfo('Preencha o histórico','Atenção')
        form_dados.tbox_002.setfocus()
        return(nil)
    endif
    
    if parametro == 1
        Rs.Addnew()
    endif
    Rs.field.banco.value       := form_movban.cbo_001.cargo[form_movban.cbo_001.value]
    Rs.Field.dtMovimento.value := form_dados.tbox_001.value
    Rs.Field.historico.value   := form_dados.tbox_002.value
    Rs.Field.entrada.value     := form_dados.tbox_003.value
    Rs.Field.saida.value       := form_dados.tbox_004.value
    Rs.Update()
    if Rs.ErrorSQL()
        Return .F.
    endif
    form_dados.release
    atualizar()
    return(nil)
*--------------------------------------------------------------------
static function atualizar()
    if form_movban.cbo_001.value=0
        MsgStop("Não existe um banco selecionado !")
        Return .F.
    endif
    form_movban.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_movban
    Rs.SQL:="Select * from movimento_bancario where banco="+hb_ntos(form_movban.cbo_001.cargo[form_movban.cbo_001.value])+" and dtMovimento>="+Rs:DataSQL(form_movban.dp_inicio.value)+" and dtMovimento<="+Rs:DataSQL(form_movban.dp_final.value)+" order by dtmovimento,codigo"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value,10),;
                  dtoc(Rs.Field.dtMovimento.value),;
                  Rs.Field.historico.value,;
                  trans(Rs.Field.entrada.value,'@E 999,999.99'),;
                  trans(Rs.Field.saida.value,'@E 999,999.99')} to Grid_Pesquisa of form_movban
        Rs.MoveNext()
    end
    form_movban.Grid_Pesquisa.ColumnsAutoFit()
    form_movban.Grid_Pesquisa.ColumnsAutoFitH()    
    form_movban.Grid_Pesquisa.enableupdate
    return(nil)
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_003_Onchange( )
    form_dados.tbox_004.enabled := form_dados.tbox_003.value=0
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_004_Onchange( )
    form_dados.tbox_003.enabled := form_dados.tbox_004.value=0
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_movban_cbo_001_Onchange( )
    Atualizar()
    Return .T.
