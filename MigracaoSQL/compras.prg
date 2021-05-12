/*
  sistema     : superchef pizzaria
  programa    : compras - entradas no estoque de produtos e matéria prima
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
    Última alteração : 11/05/2021-11:21:13 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
Declare Cursor SQLADO rs1
memvar Rs

function compras()
    
    Load Window compras_form_compras as form_compras
        form_compras.cargo:=hash()
        form_compras.cargo["total_doc"] := 0
        form_compras.oTipoProduto.value := 1
        form_compras.tbox_001.Setfocus()
    form_compras.center
    form_compras.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar_produto()
    if form_compras.tbox_001.value=0
        MsgStop("Selecione o fornecedor...")
        form_compras.tbox_001.setfocus()
        return .F.
    endif
    if form_compras.tbox_004.value=0
        MsgStop("selecione a forma de pagamento...")
        form_compras.tbox_004.setfocus()
        return .F.
    endif
    if form_compras.tbox_produto.value=0
        MsgStop("Selecione "+IIF(form_compras.oTipoProduto.value=1,"um produto","uma matéria prima")+"...")
        form_compras.oTipoProduto.setfocus()
        return .F.
    endif
    if form_compras.tbox_002.value=0
        MsgStop("Você deve fornecer a quantidade...")
        form_compras.tbox_002.setfocus()
        return .F.
    endif
    if form_compras.tbox_003.value=0
        MsgStop("Você deve fornecer o valor unitário...")
        form_compras.tbox_003.setfocus()
        return .F.
    endif
    
    add item {"-",;
              hb_ntos(form_compras.tbox_produto.cargo[form_compras.tbox_produto.value]),;
              form_compras.tbox_produto.displayValue,;
              trans(form_compras.tbox_002.value,'@R 999999'),;
              trans(form_compras.tbox_003.value,'@E 99,999.99'),;
              trans(form_compras.tbox_002.value*form_compras.tbox_003.value,'@E 999,999.99')};
              to grid_produtos of form_compras
              
    form_compras.cargo["total_doc"] := (form_compras.cargo["total_doc"] + (form_compras.tbox_002.value * form_compras.tbox_003.value))
    
    form_compras.tbox_produto.deleteAllItems()
    form_compras.tbox_produto.value := 0
    form_compras.tbox_002.value     := 0
    form_compras.tbox_003.value     := 0
    
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir_produto()
    Local cValor,nPos:=form_compras.grid_produtos.value
    if nPos = 0
        return .F.
    endif
    if !msgYesno("Confirma a exclusão da linha selecionada ?","Excluir")
        return .F.
    endif
    cValor := form_compras.grid_produtos.item(nPos)[6]
    cValor := StrTran(StrTran(cValor,".",""),",",".")
    form_compras.cargo["total_doc"] := (form_compras.cargo["total_doc"]-val(cValor))
    form_compras.grid_produtos.deleteItem(nPos)
    form_compras.grid_produtos.value := Min(nPos-1,1)
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar_compras()
    Local nItem,aItem,nId,nValorParcela,nDifArredondamento,dVencimento
    if form_compras.oValor_doc.value=0
        MsgStop("Documento deve ter um valor de lancamento...")
        form_compras.oValor_doc.setfocus()
        return .F.
    endif
    if form_compras.oValor_doc.value <> form_compras.cargo["total_doc"]
        MsgStop("Verique o lançamento, valor do documento não confere com o valor detalhado !")
        return .F.
    endif
    if form_compras.tbox_001.value=0
        MsgStop("Selecione o fornecedor...")
        form_compras.tbox_001.setfocus()
        return .F.
    endif
    if form_compras.tbox_004.value=0
        MsgStop("selecione a forma de pagamento...")
        form_compras.tbox_004.setfocus()
        return .F.
    endif
    if empty(form_compras.tbox_documento.displayValue)
        MsgStop("Numero documento deve ser fornecido..")
        form_compras.tbox_documento.setfocus()
        return .F.
    endif
    if form_compras.tbox_005.value = 0
        MsgStop("Numero de parcelas deve ser informado...")
        form_compras.tbox_documento.setfocus()
        return .F.
    endif
    if form_compras.tbox_005.value>1 .and. form_compras.tbox_008.value=0
        MsgStop("Forneça os dias entre uma parcela e outra...")
        form_compras.tbox_008.setfocus()
        return .F.
    endif
    if empty(form_compras.tbox_006.value)
        MsgSTop("Data de vencimento deve ser fornecida...")
        form_compras.tbox_006.setfocus()
        return .F.
    endif
    
    rs.New()
    rs:BeginTrans()
    rs.SQL := "Select * from compras where 1=2"
    rs.Open()
    rs.AddNew()
    rs.field.fornecedor.value := form_compras.tbox_001.cargo[form_compras.tbox_001.value]
    rs.field.forma_pag.value  := form_compras.tbox_004.cargo[form_compras.tbox_004.value]
    rs.field.num_parc.value   := form_compras.tbox_005.value
    rs.field.data_venc.value  := form_compras.tbox_006.value
    rs.field.dias_parc.value  := form_compras.tbox_008.value
    rs.field.tipo.value       := IIF(form_compras.oTipoProduto.value=1,"P","M") //Produto/Materia_Prima
    rs.field.num_doc.value    := form_compras.tbox_documento.displayValue
    rs.field.valor_doc.value  := form_compras.ovalor_doc.value
    rs.Update()
    if rs.ErrorSQL()
        rs:RollbackTrans()
        Return .F.
    endif
    
    //obtendo o codigo gerado automaticamente
    rs.sql:="select @@IDENTITY as [ID]"
    rs.Open()
    nId := rs.field.id.value
    
    rs.sql:="Select * from compras_detalhe where 1=2"
    rs.Open()
    For nItem=1 to form_compras.grid_produtos.itemcount
        aItem   := form_compras.grid_produtos.item(nItem)
        aItem[5]:=strtran(strtran(aItem[5],".",""),",",".")
        rs.AddNew()
        rs.field.codigo.value   := nId
        rs.field.ordem.value    := nItem
        rs.field.produto.value  := aItem[2]
        rs.field.qtd.value      := val(aItem[4])
        rs.field.vlr_unit.value := val(aItem[5])
        rs.Update()
        if rs.ErrorSQL()
            rs:RollbackTrans()
            Return .F.
        endif    
        //Se for produto
        if form_compras.oTipoProduto.value=1
            rs.execute("update produtos set qtd_estoq=(qtd_estoq+"+aItem[4]+") where codigo="+aItem[2])
        else
            rs.execute("update materia_prima set qtd=(qtd+"+aItem[4]+") where codigo="+aItem[2])
        endif
        if rs.ErrorSQL()
            rs:RollbackTrans()
            Return .F.
        endif
    Next
    
    rs.sql := "Select * from contas where 1=2"
    rs.Open()

    nValorParcela      := Round(form_compras.ovalor_doc.value / form_compras.tbox_005.value,2)
    nDifArredondamento := form_compras.ovalor_doc.value - (nValorParcela *  form_compras.tbox_005.value)
    dVencimento        := form_compras.tbox_006.value
    For nItem=1 to form_compras.tbox_005.value 
        rs.addNew()
        rs.field.cod_origem.value := nID
        rs.field.vencimento.value := dVencimento
        rs.field.forma.value      := form_compras.tbox_004.cargo[form_compras.tbox_004.value]
        rs.field.fornec.value     := form_compras.tbox_001.cargo[form_compras.tbox_001.value]
        if nItem < form_compras.tbox_005.value
            rs.field.valor.value      := nValorParcela
        else
            rs.field.valor.value      := nValorParcela + nDifArredondamento
        endif
        dVencimento += form_compras.tbox_008.value
        rs.Update()
        if rs.ErrorSQL()
            rs:RollbackTrans()
            Return .F.
        endif        
    Next
    rs:commitTrans()
    msginfo('Informações gravadas com sucesso, tecle ENTER','Mensagem')
    form_compras.release
    
    return(nil)
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_compras_tbox_001_Onlistdisplay( )
    Local rs1.new()
    form_compras.tbox_001.deleteAllItems()
    form_compras.tbox_001.cargo:={}
    rs1.sql := "Select top 100 codigo,nome from fornecedores where nome like '"+form_compras.tbox_001.displayValue+"%'"
    rs1.Open()
    While !rs1.Eof()
        form_compras.tbox_001.additem(rs1.field.nome.value)
        AADD(form_compras.tbox_001.cargo,rs1.field.codigo.value)
        rs1.MoveNext()
    Enddo
    
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_compras_tbox_001_Onenter( )
    if form_compras.tbox_001.value>0
        return .T.
    endif
    PostMessage(form_compras.tbox_001.handle,(320+15),1,0)
    form_compras.tbox_001.setfocus()
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_compras_tbox_004_Onlistdisplay( )
    Local rs1.new()
    form_compras.tbox_004.deleteAllItems()
    form_compras.tbox_004.cargo := {}
    rs1.sql := "Select top 100 codigo,nome from forma_pag_rec where tipo='P' and nome like '"+form_compras.tbox_004.displayValue+"%'"
    rs1.Open()
    While !rs1.Eof()
        form_compras.tbox_004.additem(rs1.field.nome.value)
        AADD(form_compras.tbox_004.cargo,rs1.field.codigo.value)
        rs1.MoveNext()
    Enddo    
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_compras_tbox_004_Onenter( )
    if form_compras.tbox_004.value>0
        return .T.
    endif
    PostMessage(form_compras.tbox_004.handle,(320+15),1,0)
    form_compras.tbox_004.setfocus()
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_compras_tbox_produto_Onlistdisplay( )
    Local rs1.new()
    form_compras.tbox_produto.deleteAllItems()
    form_compras.tbox_produto.cargo:={}
    if form_compras.oTipoProduto.value=1
        rs1.sql := "Select top 100 codigo,nome_longo as nome from produtos where not pizza and nome_longo like '"+form_compras.tbox_produto.displayValue+"%'"
    else
        rs1.sql := "Select top 100 codigo,nome from materia_prima where  nome like '"+form_compras.tbox_produto.displayValue+"%'"
    endif
    rs1.Open()
    While !rs1.Eof()
        form_compras.tbox_produto.additem(rs1.field.nome.value)
        AADD(form_compras.tbox_produto.cargo,rs1.field.codigo.value)
        rs1.MoveNext()
    Enddo     
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************    
Static Function form_compras_tbox_produto_Onenter( )
    if form_compras.tbox_produto.value>0
        return .T.
    endif
    PostMessage(form_compras.tbox_produto.handle,(320+15),1,0)
    form_compras.tbox_produto.setfocus()
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_compras_oTipoProduto_Onchange( )
    form_compras.tbox_produto.deleteAllItems()
    form_compras.tbox_produto.value := 0
    form_compras.grid_produtos.deleteAllItems()
    form_compras.label_produto.value := IIF(form_compras.oTipoProduto.value=1,"Produto","Matéria Prima")
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_compras_tbox_documento_Onlistdisplay( )
    Local rs1.new()
    rs1.SQL:="Select top 100 codigo,num_doc,valor_doc from compras where num_doc like '"+ form_compras.tbox_documento.displayValue+"%'"
    rs1.Open()
    form_compras.tbox_documento.deleteAllItems()
    form_compras.tbox_documento.Cargo:={}
    While !rs1.eof()
        form_compras.tbox_documento.additem(rs1.Field.num_doc.value+":"+hb_ntos(rs1.field.valor_doc.value))
        AADD(form_compras.tbox_documento.cargo,rs1.field.codigo.value)
        rs1.Movenext()
    enddo
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function Form_compras_Enabled( lFlag )
    form_compras.tbox_001.enabled              := lFlag
    form_compras.tbox_004.enabled              := lFlag
    form_compras.tbox_005.enabled              := lFlag
    form_compras.tbox_006.enabled              := lFlag
    form_compras.tbox_008.enabled              := lFlag
    form_compras.tbox_produto.enabled          := lFlag
    form_compras.tbox_002.enabled              := lFlag
    form_compras.tbox_003.enabled              := lFlag
    form_compras.botao_confirmar_001.enabled   := lFlag
    form_compras.botao_excluir_produto.enabled := lFlag
    form_compras.botao_gravar.enabled          := lFlag
    form_compras.oValor_Doc.enabled            := lFlag
    form_compras.oExcluiDoc.enabled            := !lFlag
    Return .F.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_compras_tbox_documento_Onchange( )
    Local rs1.new(),nCod
    Form_compras_Enabled(form_compras.tbox_documento.value = 0)
    if form_compras.tbox_documento.value >0
        nCod := form_compras.tbox_documento.cargo[form_compras.tbox_documento.value]
        rs1.SQL:=" SELECT C.fornecedor, F.nome as nomefornecedor, C.forma_pag, P.nome as nomeforma, C.num_parc, C.data_venc, C.dias_parc, C.tipo, C.num_doc, C.valor_doc "
        rs1.SQL += "FROM forma_pag_rec as P INNER JOIN (fornecedores as F INNER JOIN compras as C ON F.codigo = C.fornecedor) ON P.codigo = C.forma_pag "
        rs1.SQL += "Where C.codigo="+hb_ntos(nCod)
        rs1.Open()
        if !Rs1.Eof()
            form_compras.tbox_001.deleteAllItems()
            form_compras.tbox_001.addItem(rs1.field.nomefornecedor.value)
            form_compras.tbox_001.value := 1
            
            form_compras.tbox_004.deleteAllItems()
            form_compras.tbox_004.addItem(rs1.field.nomeforma.value)
            form_compras.tbox_004.value := 1
            
            form_compras.tbox_005.value              := rs1.field.num_parc.value
            form_compras.tbox_006.value              := rs1.field.data_venc.value
            form_compras.tbox_008.value              := rs1.field.dias_parc.value
            form_compras.oTipoProduto.value          := IIF(rs1.field.tipo.value="P",1,2)
            form_compras.ovalor_doc.value            := rs1.field.valor_doc.value
            *form_compras.tbox_documento.displayValue := rs1.field.num_doc.value
        Endif
        form_compras.grid_produtos.deleteAllItems()
        if form_compras.oTipoProduto.value=1
            rs1.sql:="SELECT C.ordem, C.produto, P.nome_longo as nome, C.qtd, C.vlr_unit FROM produtos as P INNER JOIN compras_detalhe as C ON P.codigo = C.produto"
        else
            rs1.sql:="SELECT C.ordem, C.produto, P.nome, C.qtd, C.vlr_unit FROM materia_prima as P INNER JOIN compras_detalhe as C ON P.codigo = C.produto"
        endif
        rs1.sql+=" where C.codigo="+hb_ntos(nCod)
        rs1.Open()
        form_compras.grid_produtos.disableUpdate()
        While !Rs1.Eof()
            form_compras.grid_produtos.addItem({hb_ntos(rs1.field.ordem.value),;
                                                hb_ntos(rs1.field.produto.value),;
                                                rs1.field.nome.value,;
                                                transform(rs1.field.qtd.value,"@R 999"),;
                                                transform(rs1.field.vlr_unit.value,"@R 999,999.99"),;
                                                transform(rs1.field.qtd.value*rs1.field.vlr_unit.value,"@R 999,999.99")})
            rs1.MoveNext()
        Enddo
        form_compras.grid_produtos.enableUpdate()
    endif
    Return .T.
