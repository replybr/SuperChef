/*
  sistema     : superchef pizzaria
  programa    : contas a receber
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
    Última alteração : 12/05/2021-20:01:12 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */


#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
Declare Cursor SQLADO rs1
memvar Rs

function cRec()
    contas_a_Pagar_Receber("R")
    return Nil
function cPag()
    contas_a_Pagar_Receber("P")
    return Nil    
    *-------------------------------------------------------------------------------
function Contas_a_Pagar_Receber(cFlag)
    Private rs:=rs.new()
    Load window contas_PagRec_form as form_crec
        form_crec.cargo := cFlag
        form_crec.title := IIF(cFlag="P","Contas a Pagar","Contas a Receber")
        form_crec.Grid_Pesquisa.caption(3) := IIF(cFlag="P","Fornecedores","Clientes")
        form_crec.ofiltroPag.addItem("valores a pagar")
        form_crec.ofiltroPag.addItem("valores Pagos")
        form_crec.ofiltroPag.addItem("todos lançamentos")
        form_crec.ofiltroPag.value:=1
        on key escape of form_crec action thiswindow.release
        form_crec.center
    form_crec.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := form_crec.Grid_Pesquisa.Item(form_crec.Grid_Pesquisa.value)[1]
    Local rs1.new()
    if parametro=2 .and. val(cId)=0
        return .F.
    endif
    Load Window contas_PagRec_form_dados as form_dados
        form_dados.oVrTotal.enabled := .F.
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        Form_dados.oFlag.Picture := "img_pedido"
        if parametro=2 .or. Parametro=3
            Rs.SQL:="Select * from contas where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_003.value  := rs.field.vencimento.value
                form_dados.tbox_004.value  := rs.field.valor.value
                form_dados.tbox_002.value  := rs.field.forma.value
                form_dados.tbox_001.value  := rs.field.fornec.value
                form_dados.tbox_005.value  := rs.field.num_doc.value
                form_dados.tbox_006.value  := rs.field.obs.value
                form_dados.oMulta.value    := Default(rs.field.multa.value,0)
                form_dados.oJuros.value    := Default(rs.field.juros.value,0)
                form_dados.odesconto.value := Default(rs.field.desconto.value,0)
                form_dados.oPagamento.value:= IIF(empty(rs.field.pagamento.value),ctod(""),rs.field.pagamento.value)
                form_dados.oVrTotal.value  := (form_dados.tbox_004.value + form_dados.oMulta.value + form_dados.oJuros.value - form_dados.odesconto.value)
                rs1.sql := "select codigo,nome from forma_pag_rec where codigo="+hb_ntos(rs.field.forma.value)
                rs1.Open()
                if !Rs1.Eof()
                    form_dados.tbox_002.DeleteAllItems()
                    form_dados.tbox_002.addItem(rs1.field.nome.value)
                    form_dados.tbox_002.cargo:={rs.field.forma.value}
                    form_dados.tbox_002.value := 1
                endif
                rs1.sql:="select codigo,nome from "+IIF(form_crec.cargo="P","Fornecedores","Clientes")+" where codigo="+hb_ntos(rs.field.fornec.value)
                rs1.open()
                if !rs1.Eof()
                    form_dados.tbox_001.DeleteAllItems()
                    form_dados.tbox_001.addItem(rs1.field.nome.value)
                    form_dados.tbox_001.cargo:={rs.field.fornec.value}
                    form_dados.tbox_001.value := 1
                endif
            endif    
        else
            rs.sql:="Select * from contas where 1=2"
            rs.Open()
        endif
        if parametro=2.or. parametro=3 .and.!Empty(rs.field.cod_origem)
            //cod_origem é um lancamento automatico
            if !Empty(rs.field.cod_origem)
                form_dados.title:="lançamento automático : "+hb_ntos(rs.field.cod_origem)
            endif
            form_dados.tbox_001.enabled  := .F.
            form_dados.tbox_002.enabled  := .F.
            form_dados.tbox_003.enabled  := .F.
            form_dados.tbox_004.enabled  := .F.
            form_dados.tbox_005.enabled  := .F.
            form_dados.tbox_006.enabled  := .F.
            if Empty(Form_dados.oPagamento.value)
                Form_dados.oPagamento.value := date()
                Form_dados.oPagamento.FontBold := TRUE
                Form_dados.oPagamento.fontcolor := RED
                Form_dados.oFlag.Picture := "img_pedido"
            else
                form_dados.oMulta.enabled      := .F.
                form_dados.oJuros.enabled      := .F.
                form_dados.odesconto.enabled   := .F.
                form_dados.oPagamento.enabled  := .F.
                Form_dados.oFlag.Picture       := "check"
                Form_dados.button_ok.enabled   := .F.
            endif
        endif
        sethandcursor(getcontrolhandle('button_ok','form_dados'))
        sethandcursor(getcontrolhandle('button_cancela','form_dados'))
        form_dados.center
    form_dados.activate
    
    return(nil)    
    *-------------------------------------------------------------------------------
static function excluir()
    local cId :=form_crec.Grid_Pesquisa.Item(form_crec.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    if !msgYesNo("Confirma: "+form_crec.Grid_Pesquisa.Item(form_crec.Grid_Pesquisa.value)[6],"Exclui")
        return .F.
    endif
    Rs.Execute("Delete from contas where codigo="+cId)
    if Rs.ErrorSQL()
        Return .F.
    endif
    atualizar()
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar(parametro)
    local cMsg:="",cFocus
    
    if empty(form_dados.tbox_001.value)
        cMsg += "Falta selecionar o "+IIF(form_cRec.cargo="P","Fornecedor","Cliente")+CRLF
        cFocus:="tbox_001"
    endif
    if empty(form_dados.tbox_002.value)
        cMsg += "Falta selecionar a forma de pgamento "+CRLF
        if empty(cFocus)
            cFocus:="tbox_002"
        endif
    endif
    if empty(form_dados.tbox_003.value)
        cMsg += "Falta infomar a data de vencimento"+CRLF
        if empty(cFocus)
            cFocus:="tbox_003"
        endif
    endif
    if empty(form_dados.tbox_004.value)
        cMsg += "Falta preencher o valor"+CRLF
        if empty(cFocus)
            cFocus:="tbox_004"
        endif
    endif
    if empty(form_dados.tbox_005.value)
        cMsg += "Falta preencher o número do documento"+CRLF
        if empty(cFocus)
            cFocus:="tbox_005"
        endif
    endif    
    if !Empty(Form_dados.oPagamento.value) .and. Form_dados.oPagamento.value>Date()
        cMsg += "Data de pagamento não pode ser maior que a data atual"+CRLF
        if !Empty(cFocus)
            cFocus:="oPagamento"
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
    Rs.Field.fornec.value      := form_dados.tbox_001.cargo[form_dados.tbox_001.value]
    Rs.Field.forma.value       := form_dados.tbox_002.cargo[form_dados.tbox_002.value]
    Rs.Field.vencimento.value  := form_dados.tbox_003.value
    Rs.Field.valor.value       := form_dados.tbox_004.value
    Rs.Field.num_doc.value     := form_dados.tbox_005.value
    Rs.Field.obs.value         := form_dados.tbox_006.value
    Rs.Field.multa.value       := form_dados.oMulta.value
    Rs.Field.juros.value       := form_dados.oJuros.value
    Rs.Field.desconto.value    := form_dados.oDesconto.value
    Rs.Field.Tipo.value        := form_crec.cargo
    if !Empty(Form_dados.oPagamento.value)
        Rs.field.pagamento.value := Form_dados.oPagamento.value
    else
        Rs.field.pagamento.value := Nil
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
    Local rs1:=rs.new()
    form_crec.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_crec
    rs1.sql := "SELECT PR.codigo, PR.vencimento, CF.nome as clifor, FO.nome as nomeforma, PR.valor, PR.Num_doc,PR.obs "
    rs1.sql += " FROM forma_pag_rec as FO INNER JOIN (clientes as CF INNER JOIN contas as PR ON CF.codigo = PR.fornec) ON FO.codigo = PR.forma"
    rs1.SQL += " where PR.tipo='"+form_crec.cargo+"' and vencimento>="+Rs:DataSQL(form_crec.dp_inicio.value)+" and vencimento<="+Rs:DataSQL(form_crec.dp_final.value)
    if form_crec.ofiltroPag.value=1
        rs.sql += " and pagamento is null"
    elseif form_crec.ofiltroPag.value=2
        rs.sql += " and not pagamento is null"
    endif
    rs.sql +=" order by vencimento,PR.codigo"
    Rs1.Open()
    if Rs1.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs1.Field.codigo.value,10),;
                  dtoc(Rs1.Field.vencimento.value),;
                  Rs1.Field.clifor.value,;
                  rs1.field.nomeforma.value,;
                  trans(Rs1.Field.valor.value,'@E 999,999.99'),;
                  rs1.field.num_doc.value,;
                  Rs1.Field.obs.value} to Grid_Pesquisa of form_crec
        Rs1.MoveNext()
    end
    form_crec.Grid_Pesquisa.ColumnsAutoFit()
    form_crec.Grid_Pesquisa.ColumnsAutoFitH()    
    form_crec.Grid_Pesquisa.enableupdate
    return(nil)


    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_001_Onenter( )
    if form_dados.tbox_001.value>0
        return .T.
    endif
    PostMessage(form_dados.tbox_001.handle,(320+15),1,0)
    form_dados.tbox_001.setfocus()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_001_Onlistdisplay( )
    Local rs1.new()
    form_dados.tbox_001.disableupdate()
    form_dados.tbox_001.deleteAllItems()
    form_dados.tbox_001.cargo :={}
    rs1.sql := "select top 100 codigo,nome from "+iif(form_crec.cargo="P","Fornecedores","Clientes") +" where nome like '"+form_dados.tbox_001.Displayvalue+"%'"
    rs1.Open()
    While !rs1.Eof()
        form_dados.tbox_001.addItem(rs1.field.nome.value)
        AADD(form_dados.tbox_001.cargo,rs1.field.codigo.value)
        rs1.MoveNext()
    enddo
    form_dados.tbox_001.enableupdate()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_002_Onlistdisplay( )
    Local rs1.new()
    form_dados.tbox_002.disableupdate()
    form_dados.tbox_002.deleteAllItems()
    form_dados.tbox_002.cargo :={}
    rs1.sql := "select top 100 codigo,nome from forma_pag_rec where tipo='"+form_crec.cargo+"' and nome like '"+form_dados.tbox_002.Displayvalue+"%'"
    rs1.Open()
    While !rs1.Eof()
        form_dados.tbox_002.addItem(rs1.field.nome.value)
        AADD(form_dados.tbox_002.cargo,rs1.field.codigo.value)
        rs1.MoveNext()
    enddo
    form_dados.tbox_002.enableupdate()    
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_002_Onenter( )
    if form_dados.tbox_002.value>0
        return .T.
    endif
    PostMessage(form_dados.tbox_002.handle,(320+15),1,0)
    form_dados.tbox_002.setfocus()    
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_dados_tbox_Onchange( )
    form_dados.oVrTotal.value := (form_dados.tbox_004.value + form_dados.oMulta.value + form_dados.oJuros.value - form_dados.oDesconto.value)
    Return .T.
