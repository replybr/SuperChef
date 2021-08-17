/*
  sistema     : superchef pizzaria
  programa    : venda delivery
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
    Última alteração : 15/05/2021-09:37:35 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs ,hPedido

function venda_delivery()
    Vendas("DELIVERY")
    Return .T.
    
function venda_balcao()
    Vendas("BALCAO")
    Return .T.
    *-------------------------------------------------------------------------------
Static function Vendas(cType)
    Local rs.new(),hItem
    Private hPedido
    Load Window vendas_form as form_vendas
        DEFINE LABEL telefone
            PARENT form_vendas
            COL 10
            FONTBOLD TRUE
            FONTCOLOR { 0 , 0 , 255 }
            FONTNAME "courier new"
            FONTSIZE 16
            HEIGHT 24
            ROW 30
            VISIBLE FALSE
            VALUE ""
            WIDTH 150
            TRANSPARENT TRUE
        END LABEL

        form_Vendas.tbox_telefone.Setfocus()
        form_vendas.title := "Venda "+cType
        rs.sql := "select * from bordas order by codigo"
        rs.Open()
        form_vendas.cbo_bordas.cargo:={}
        form_vendas.grid_montagem.cargo:={}
        While !Rs.Eof()
            hItem:=hash()
            form_vendas.cbo_bordas.addItem(rs.field.nome.value)
            hItem["codigo"]:= rs.field.codigo.value
            hItem["nome"]  := rs.field.nome.value
            hItem["valor"] := rs.field.preco.value
            AADD(form_vendas.cbo_bordas.cargo,hItem)
            rs.MoveNext()
        enddo
        rs.sql := "select * from tamanhos order by pedacos"
        rs.open()
        form_vendas.cbo_tamanhos.cargo := {}
        While !rs.eof()
            form_vendas.cbo_tamanhos.addItem(rs.field.nome.value+" (Fatias:"+hb_ntos(rs.field.pedacos.value)+"/Sabores:"+hb_ntos(rs.field.sabores.value)+")")
            hItem:=hash()
            hItem["codigo"]  := rs.field.codigo.value
            hItem["nome"]    := rs.field.nome.value
            hItem["pedacos"] := rs.field.pedacos.value
            hItem["sabores"] := rs.field.sabores.value
            AADD(form_vendas.cbo_tamanhos.cargo,hItem)
            rs.MoveNext()
        enddo
        on key F9     of form_vendas action fecha_pedido()
        on key escape of form_vendas action thiswindow.release
        form_Vendas_tbox_telefone_Onchange( )
        form_vendas.maximize
    form_vendas.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
Static Function form_Vendas_tbox_telefone_Onlistdisplay( )
    Local rs.new()
    Local cValue := form_Vendas.tbox_telefone.DisplayValue
    Local hItem
    form_Vendas.tbox_telefone.DeleteAllItems()
    form_Vendas.tbox_telefone.cargo:={}
    if empty(cValue)
        Return FALSE
    endif
    rs.sql := "Select top 30 codigo,nome,fixo,celular,endereco,numero,complem,bairro,cep,email from clientes "
    rs.sql += "where fixo='"+cValue+"' or celular='"+cValue+"' or nome like '"+cValue+"%' or email like '"+cValue+"%'"
    rs.Open()
    form_Vendas.tbox_telefone.disableUpdate
    While !rs.Eof()
        form_Vendas.tbox_telefone.addItem(rs.field.nome.value+" - "+rs.field.endereco.value)
        hItem:=hash()
        hItem["codigo"]  := rs.field.codigo.value
        hItem["nome"]    := rs.field.nome.value
        hItem["fixo"]    := rs.field.fixo.value
        hItem["celular"] := rs.field.celular.value
        hItem["endereco"]:= rs.field.endereco.value+","+rs.field.numero.value
        hItem["complem"] := rs.field.complem.value
        hItem["bairro"]  := rs.field.bairro.value
        hItem["cep"]     := rs.field.cep.value
        hItem["email"]   := rs.field.email.value
        AADD(form_Vendas.tbox_telefone.cargo,hItem)
        rs.MoveNext()
    Enddo
    form_Vendas.tbox_telefone.enableUpdate
    Return .T.
    *-------------------------------------------------------------------------------
Static Function form_Vendas_tbox_telefone_Onenter( )
    local hItem
    if form_Vendas.tbox_telefone.value>0
        hItem := form_vendas.tbox_telefone.cargo[form_vendas.tbox_telefone.value]
        form_Vendas.tbox_telefone.visible := FALSE
        form_Vendas.telefone.visible      := TRUE
        form_Vendas.telefone.value        := Default(hItem["fixo"],hItem["celular"])
        form_Vendas.oCancela.Enabled      := TRUE
        form_Vendas.botao_cadastrar_cliente.enabled := .F.
        form_vendas.cbo_tamanhos.setfocus()
        Reset_Pedido(hItem)
        historico_cliente()
        return .T.
    endif
    PostMessage(form_Vendas.tbox_telefone.handle,(320+15),1,0)
    form_Vendas.tbox_telefone.setfocus()    
    Return .T.
    *-------------------------------------------------------------------------------
Static Function form_vendas_tbox_telefone_Onlostfocus( )
    Local hItem
    if form_Vendas.tbox_telefone.value>0 .and.form_Vendas.tbox_telefone.visible
        hItem := form_vendas.tbox_telefone.cargo[form_vendas.tbox_telefone.value]
        form_Vendas.tbox_telefone.visible := FALSE
        form_Vendas.telefone.visible      := TRUE
        form_Vendas.oCancela.Enabled      := TRUE
        form_Vendas.telefone.value        := Default(hItem["fixo"],hItem["celular"])
        form_Vendas.botao_cadastrar_cliente.enabled := .F.
        Reset_Pedido(hItem)
        historico_cliente()
        return .T.
    endif
    *form_Vendas.tbox_telefone.Setfocus()
    Return .T.
    *-------------------------------------------------------------------------------
Static Function form_Vendas_tbox_telefone_Onchange( )
    Local hItem
    form_vendas.cbo_bordas.enabled               := FALSE
    form_vendas.cbo_produtos.enabled             := FALSE
    form_vendas.botao_exclui_sabor.enabled       := FALSE
    form_vendas.cbo_sabores.enabled              := FALSE
    form_vendas.tbox_obs_1.enabled               := FALSE
    form_vendas.tbox_obs_2.enabled               := FALSE
    form_vendas.botao_fecha_pizza.enabled        := FALSE
    form_vendas.botao_exclui_item_pedido.enabled := FALSE
    form_vendas.botao_cupom.enabled              := FALSE
    form_Vendas.botao_cadastrar_cliente.enabled  := TRUE
    
    if form_Vendas.tbox_telefone.value>0
        hItem := form_vendas.tbox_telefone.cargo[form_vendas.tbox_telefone.value]
        form_Vendas.label_nome_cliente.value := hItem["nome"]
        form_Vendas.label_endereco_001.value := hItem["endereco"]
        form_Vendas.label_endereco_002.value := hItem["complem"]
        form_Vendas.label_endereco_003.value := hItem["bairro"]+"-"+hItem["cep"]


    else
        form_Vendas.label_nome_cliente.value := ""
        form_Vendas.label_endereco_001.value := ""
        form_Vendas.label_endereco_002.value := ""
        form_Vendas.label_endereco_003.value := ""
        hPedido := Nil
    endif
    Return .T.    
    *-------------------------------------------------------------------------------   
Static Function form_vendas_cbo_tamanhos_Onchange( )
    form_vendas.cbo_sabores.enabled := (form_vendas.cbo_tamanhos.value > 0)
    Return .T.    
    *-------------------------------------------------------------------------------   
Static Function form_vendas_cbo_produtos_Onlistdisplay( )
    Local rs.new()
    Local cValue := form_vendas.cbo_produtos.DisplayValue
    Local hItem
    form_vendas.cbo_produtos.DeleteAllItems()
    form_vendas.cbo_produtos.cargo:={}
    
    rs.sql := "SELECT top 30 P.codigo, P.nome_longo, P.vlr_venda, P.promocao, A.nome, P.medida,P.Qtd_estoque "  
    rs.sql += "FROM grupo_apoio as A INNER JOIN produtos as P ON (A.codigo = P.unidade) "
    rs.sql += "where not pizza and nome_longo like '"+cValue+"%' order by nome_longo"

    rs.Open()
    form_vendas.cbo_produtos.disableUpdate()
    While !rs.Eof()
        form_vendas.cbo_produtos.addItem(rs.field.nome_longo.value+" ("+hb_ntos(rs.field.medida.value)+" "+rs.field.nome.value +") R$"+Transform(rs.field.vlr_venda,"@R 999,999.99"))
        hItem:=NewHash()
        hItem["tipo"]        := "PR"
        hItem["codigo"]      := rs.field.codigo.value
        hItem["nome"]        := rs.field.nome_longo.value
        hItem["valor"]       := rs.field.vlr_venda.value
        hItem["promocao"]    := rs.field.promocao.value
        hItem["estoque"]     := rs.field.qtd_estoque.value
        AADD(form_vendas.cbo_produtos.cargo,hItem)
        rs.MoveNext()
    Enddo
    form_vendas.cbo_produtos.enableUpdate    
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_vendas_cbo_produtos_Onenter( )
    Local hItem ,nQtde
    if form_vendas.cbo_produtos.value>0
        hItem := hb_HClone(form_vendas.cbo_produtos.cargo[ form_vendas.cbo_produtos.value])
        nQtde := Pede_Quantidade()
        if hItem["qtde"] > hItem["estoque"]
            MsgStop("Quantidade será reajustada de acordo com o estoque !"+CRLF+;
                     "Informado :"+hb_ntos(hItem["qtde"])+CRLF+;
                     "Estoque :"+hb_ntos(hitem["estoque"])+CRLF+;
                     "Ajustado para :"+hb_ntos(hItem["estoque"]))
            hItem["qtde"] := hItem["estoque"]
        endif
        hPedido["sequencia"] ++
        // { "SEQ" , "Item" , "Qtd" , "Unit.R$" , "SubTotal R$" }
        form_vendas.grid_pedido.addItem({hb_ntos(hPedido["sequencia"]),;
                                         hItem["nome"],;
                                         hb_ntos(nQtde),;
                                         Transform(hItem["valor"],"@E 999,999.99"),;
                                         Transform(hItem["valor"]*nQtde,"@E 999,999.99"),;
                                         "PR"})
        hItem["qtde"] := nQtde
        AADD(hPedido["produtos"],hItem)
        form_vendas.label_total.value := transform(Calcula(),'@E 99,999.99')
        return .T.
    endif
    PostMessage(form_vendas.cbo_produtos.handle,(320+15),1,0)
    form_vendas.cbo_produtos.setfocus()       
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
    
static function cadastrar_novo_cliente()
    Clientes(TRUE)
    return(nil)
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_vendas_cbo_sabores_Onlistdisplay( )
    Local rs.New(),hItem,nPos:=form_vendas.cbo_tamanhos.value
    if nPos = 0
        MsgStop("Selecione um tamanho de pizza antes de sabor...")
        form_vendas.cbo_tamanhos.setfocus()
        Return .F.
    endif
    rs.sql := "SELECT top 30  P.codigo, P.nome_longo, P.vlr_venda as valor, P.promocao "
    rs.sql += "FROM  produtos as P "
    rs.sql += "where pizza and P.pedacos="+hb_ntos(form_vendas.cbo_tamanhos.cargo[nPos]["codigo"])
    rs.sql += " and nome_longo like '"+form_vendas.cbo_sabores.displayValue+"%' order by nome_longo"
    rs.open()
    form_vendas.cbo_sabores.cargo := {}
    form_vendas.cbo_sabores.DeleteAllItems()
    While !rs.eof()
        form_vendas.cbo_sabores.additem(rs.field.nome_longo.value+" R$ "+Transform(rs.field.valor.value,"@R 999.99"))
        hItem:=hash()
        hItem["codigo"]    := rs.field.codigo.value
        hItem["nome"]      := rs.field.nome_longo.value
        hItem["promocao"]  := rs.field.promocao.value
        hItem["valor"]     := rs.field.valor.value
        AADD(form_vendas.cbo_sabores.cargo,hItem)
        rs.MoveNext()
    enddo
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_vendas_cbo_sabores_Onenter( )
    Local nPos:=form_vendas.cbo_sabores.value
    Local hItem,h,hTamanho
    if nPos = 0
        PostMessage(form_vendas.cbo_sabores.handle,(320+15),1,0)
        form_vendas.cbo_sabores.setfocus()  
        return .F.
    endif
    hItem    := form_vendas.cbo_sabores.cargo[nPos]
    hTamanho := form_vendas.cbo_tamanhos.cargo[form_vendas.cbo_tamanhos.value]
    for each h in form_vendas.grid_montagem.cargo
        if h["codigo"]==hItem["codigo"]
            MsgInfo("Sabor já foi incluido !")
            PostMessage(form_vendas.cbo_sabores.handle,(320+15),1,0)
            form_vendas.cbo_sabores.setfocus()  
            return .F.
        endif
    next
    if hTamanho["sabores"] <= form_vendas.grid_montagem.itemcount
        MsgStop("Número de máximo de sabores já escolhidos !")
        Return .F.
    endif
    form_vendas.grid_montagem.additem({hb_ntos(hItem["codigo"]),hItem["nome"]+" "+IIF(hItem["promocao"],"* PROMOÇÃO","")})
    AADD(form_vendas.grid_montagem.cargo,hItem)
    form_vendas.botao_fecha_pizza.enabled  := (form_vendas.grid_montagem.itemcount > 0)
    form_vendas.grid_montagem.value := form_vendas.grid_montagem.itemcount 
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_vendas_cbo_sabores_Onchange( )

    Return TRUE
    *-------------------------------------------------------------------------------
Static Function form_vendas_grid_montagem_Onchange( )
    form_vendas.botao_exclui_sabor.enabled := (form_vendas.grid_montagem.value >0)
    form_vendas.cbo_bordas.enabled         := (form_vendas.grid_montagem.itemcount >0)
    form_vendas.botao_fecha_pizza.enabled  := (form_vendas.grid_montagem.itemcount >0)
    Return .T.
    *-------------------------------------------------------------------------------
static function form_vendas_botao_exclui_sabor_Action( )
    Local nPos:=form_vendas.grid_montagem.value
    if nPos = 0
        msgalert('Escolha o que deseja excluir primeiro','Atenção')
        return(nil)
    endif
    if msgyesno('Excluir : '+form_vendas.grid_montagem.item(nPos)[2],'Excluir')
        
        form_vendas.grid_montagem.deleteItem(nPos)
        hb_adel(form_vendas.grid_montagem.cargo,nPos,TRUE)
        form_vendas.grid_montagem.value := Max(nPos-1,1)
    endif
    form_vendas.botao_fecha_pizza.enabled  := (form_vendas.grid_montagem.itemcount > 0)
    form_vendas.grid_montagem.setfocus()
    form_vendas_grid_montagem_Onchange( )
    return(nil)
    *-------------------------------------------------------------------------------
static function fecha_montagem_pizza()
    Local i,nTot:= form_vendas.grid_montagem.itemcount,hItem,hPizza
    Local rs.new()
    Local nTipoCobranca:=1 //1.Cobra pelo maior valor,2.Cobra pelo valor medio
    Local nValorPizzaInteira:=0
    if nTot = 0
        msginfo('Não existe(m) sabor(es) selecionado(s), tecle ENTER','Atenção')
        return(nil)
    endif
    if form_vendas.cbo_bordas.value=0
        MsgInfo("Selecione o tipo de borda !")
        form_vendas.cbo_bordas.setfocus()
        return .f.
    endif
    //aqui vamos obter o tipo de cobranca definido na conviguração da empresa
    rs.sql := "select forma_pagamento from empresa"
    rs.open()
    if !rs.eof()
        nTipoCobranca := rs.field.forma_pagamento.value
    endif

    hPedido["sequencia"] ++ //vamos criar um id para poder navegar 
    hpizza := Newhash()
    hpizza["tipo"]   := "PI"
    hpizza["codigo"] :=  Nil //deteminante da pizza são os sabores.
    hpizza["borda"]  :=  form_vendas.cbo_bordas.cargo[form_vendas.cbo_bordas.value]  //hash das bordas
    hpizza["qtde"]   :=  Pede_Quantidade()

    //vamos varrer a montagem de pizza para determinar o valor
    
    For i=1 to nTot
        hItem := form_vendas.grid_montagem.cargo[i]
        if nTipoCobranca=1
            nValorPizzaInteira:=Max(nValorPizzaInteira , hItem["valor"])
        else
            nValorPizzaInteira += hItem["valor"]
        endif
        AADD(hPizza["partes"],hItem)
        // { "SEQ" , "Item" , "Qtd" , "Unit.R$" , "SubTotal R$" }
        if i=1
            form_vendas.grid_pedido.addItem({hb_ntos(hPedido["sequencia"]),;
                                            "BORDA "+hpizza["borda"]["nome"],;
                                            hb_ntos(hpizza["qtde"]),;
                                            Transform(hpizza["borda"]["valor"],"@E 9,999.99"),;
                                            Transform(hpizza["borda"]["valor"]*hpizza["qtde"],"@E 9,999.99"),"PI"})
        endif
        form_vendas.grid_pedido.addItem({hb_ntos(hPedido["sequencia"]),'1/'+hb_ntos(nTot)+" - "+hItem["nome"],"","","","PI"})
    next
    
    //determinando o valor, caso seja cobrado pelo valor medio.
    if nTipoCobranca=2
        nValorPizzaInteira := nValorPizzaInteira/nTot
    endif
    //guardando o valor integral da pizza
    hpizza["valor"]          := nValorPizzaInteira
    hPedido["subtotalpizza"] += nValorPizzaInteira
    hPedido["subtotalborda"] += hpizza["borda"]["valor"]
    
    //Totalizando a pizza montada/apenas visual
    form_vendas.grid_pedido.addItem({hb_ntos(hPedido["sequencia"]),;
                                    " TOTAL Pizza ID:"+hb_ntos(hPedido["sequencia"]),;
                                    hb_ntos(hpizza["qtde"]),;
                                    Transform(nValorPizzaInteira,"@E 99,999.99"),;
                                    Transform(nValorPizzaInteira*hpizza["qtde"],"@E 999,999.99"),;
                                    "PI"})
    
    form_vendas.grid_montagem.deleteAllItems()
    form_vendas.grid_montagem.cargo:={}
    AADD(hPedido["produtos"],hpizza)
    form_vendas.label_total.value := transform(Calcula(),'@E 99,999.99')
    form_vendas_grid_montagem_Onchange( )
    return(nil)
    *-------------------------------------------------------------------------------
static function fecha_pedido()
    if empty(hPedido) .or. len(hpedido["produtos"])=0
        MsgStop("Não existe um pedido com produtos/pizza selecionados!")
        Return .F.
    endif
    Load Window vendas_form_fecha_pedido as form_fecha_pedido
        form_fecha_pedido.oFormaPagto2.enabled    := .F.
        form_fecha_pedido.oFormaPagto3.enabled    := .F.
        form_fecha_pedido.tbox_fr002.enabled := .F.
        form_fecha_pedido.tbox_fr003.enabled := .F.        
        form_fecha_pedido.center
    form_fecha_pedido.activate
    return(nil)
    *-------------------------------------------------------------------------------
Static Function form_fecha_pedido_Oninit( )
    form_fecha_pedido.label_001_valor.value := transform(hPedido["subtotalpizza"]   ,'@E 999,999.99')
    form_fecha_pedido.label_b002.value      := transform(hPedido["subtotalborda"]   ,'@E 999,999.99') 
    form_fecha_pedido.label_002_valor.value := transform(hPedido["subtotalproduto"] ,'@E 999,999.99') 
    form_fecha_pedido_tbox_taxa_Onchange()
    Return .T.    
    *-------------------------------------------------------------------------------
Static Function form_fecha_pedido_tbox_taxa_Onchange( )
    hPedido["taxaentrega"] := form_fecha_pedido.tbox_taxa.value
    hPedido["desconto"]    := form_fecha_pedido.tbox_desconto.value
    form_vendas.label_total.value := transform(Calcula(),'@E 99,999.99')
    form_fecha_pedido.label_005_valor.value := Transform(hPedido["totalpedido"],"@R 999,999.99")
    form_fecha_pedido.tbox_fr001.value      := hPedido["totalpedido"]
    Return .T.
    *-------------------------------------------------------------------------------
Static Function form_fecha_pedido_tbox_desconto_Onchange( )
    form_fecha_pedido_tbox_taxa_Onchange()
    Return .T.
    *-------------------------------------------------------------------------------
Static Function form_fecha_pedido_tbox_fr001_Onchange( )
    Local lValid    := (form_fecha_pedido.tbox_fr001.value < hPedido["totalpedido"])
    Local nRecebido := form_fecha_pedido.tbox_fr001.value + form_fecha_pedido.tbox_fr002.value + form_fecha_pedido.tbox_fr003.value
    form_fecha_pedido.oFormaPagto2.enabled    := lValid
    form_fecha_pedido.oFormaPagto3.enabled    := lValid
    form_fecha_pedido.tbox_fr002.enabled := lValid
    form_fecha_pedido.tbox_fr003.enabled := lValid
    if !lValid
        form_fecha_pedido.tbox_fr002.value := 0
        form_fecha_pedido.oFormaPagto2.value    := 0
        form_fecha_pedido.tbox_fr003.value := 0
        form_fecha_pedido.oFormaPagto3.value    := 0
    endif
    form_fecha_pedido.oRecebido.value := Transform(nRecebido,'@E 999,999.99')
    form_fecha_pedido.oTroco.value    := Transform(nRecebido-hPedido["totalpedido"],'@E 999,999.99')
    Return .T.
    *-------------------------------------------------------------------------------
Static Function form_fecha_pedido_tbox_fr002_Onchange( )
    Local lValid := ((form_fecha_pedido.tbox_fr001.value + form_fecha_pedido.tbox_fr002.value) < hPedido["totalpedido"]) .and. form_fecha_pedido.tbox_fr001.value > 0
    Local nRecebido := form_fecha_pedido.tbox_fr001.value + form_fecha_pedido.tbox_fr002.value + form_fecha_pedido.tbox_fr003.value
    form_fecha_pedido.tbox_fr003.enabled := lValid
    form_fecha_pedido.oFormaPagto3.enabled    := lValid
    if !lValid
        form_fecha_pedido.tbox_fr003.value := 0
        form_fecha_pedido.oFormaPagto3.value    := 0
    endif
    form_fecha_pedido.oRecebido.value := Transform(nRecebido,'@E 999,999.99')
    form_fecha_pedido.oTroco.value    := Transform(nRecebido-hPedido["totalpedido"],'@E 999,999.99')
    Return .T.
    *-------------------------------------------------------------------------------
Static Function form_fecha_pedido_tbox_fr003_Onchange( )
    Local nRecebido := form_fecha_pedido.tbox_fr001.value + form_fecha_pedido.tbox_fr002.value + form_fecha_pedido.tbox_fr003.value
    form_fecha_pedido.oRecebido.value := Transform(nRecebido,'@E 999,999.99')
    form_fecha_pedido.oTroco.value    := Transform(nRecebido-hPedido["totalpedido"],'@E 999,999.99')
    Return .T.
    *-------------------------------------------------------------------------------
static function fechamento_geral()
    Local rs.new(),hItem,nId,nItem,i,nFatias,cSQL,nDias,tFechamento:=Datetime()
    IF hPedido["finalizado"]
        Return .T.
    endif
    rs:BeginTrans()
    
    //abrindo um cursor vazio para iniciar a transação
    rs.sql := "select * from vendas where 1=2"
    rs.open()
    rs.addNew()
    
    rs.field.cliente.value     := form_Vendas.tbox_telefone.cargo[form_Vendas.tbox_telefone.value]["codigo"]
    rs.field.datahora.value    := tFechamento
    rs.field.onde.value        :=  1 //1=delivery 2=mesa 3=balcão
    rs.field.valor.value       := hPedido["subtotalpizza"] + hPedido["subtotalproduto"] + hPedido["subtotalborda"]
    rs.field.taxaentrega.value := hPedido["taxaentrega"]
    rs.field.desconto.value    := hPedido["desconto"]
    if  form_fecha_pedido.oEntrega.value >0
        rs.field.motoboy.value := form_fecha_pedido.oEntrega.cargo[ form_fecha_pedido.oEntrega.value]["codigo"]
    endif
    Rs.Update()
    if rs.ErrorSQL(rs.sql)
        rs:Rollbacktrans()
        Return FALSE
    endif
    
    //obtendo o codigo gerado automaticamente
    rs.sql:="select @@IDENTITY as [ID]"
    rs.Open()
    nId := rs.field.id.value
    
    rs.sql := "Select * from vendas_detalhe where 1=2"
    rs.Open()
    
    nItem:=0
    
    For each hItem in hPedido["produtos"]
        if !hItem["ativo"]
            Loop
        endif
        nItem++
        rs.addNew()
        rs.field.venda.value   := nId
        rs.field.ordem.value   := nItem
        rs.field.produto.value := hItem["codigo"]
        rs.field.qtde.value    := hItem["qtde"]
        rs.field.valor.value   := hItem["valor"]
        rs.Update()
        if rs.ErrorSQL(rs.sql)
            rs:RoolbackTrans()
            Return .F.
        endif
        if hItem["tipo"]="PI"
            nFatias := len(hItem["partes"])
            For i=1 to nFatias
                cSQL := "Insert into vendas_detalhe_pizza (venda,ordem,produto,fator,valor) values ("
                cSQL += hb_ntos(nId)+","
                cSQL += hb_ntos(nItem) +","
                cSQL += hb_ntos(hItem["partes"][i]["codigo"]) +","
                cSQL += hb_ntos(nFatias)+","
                cSQL += hb_ntos(hItem["partes"][i]["valor"])
                cSQL+=");"
                rs.Execute(cSQL)
                if Rs.ErrorSQL(rs.sql)
                    rs:RoolbackTrans()
                    Return .F.
                endif
                cSQL := "UPDATE materia_prima INNER JOIN produto_composto ON materia_prima.codigo = produto_composto.materia_prima SET "
                cSQL += "qtd_estoque = (qtd_estoque - (quantidade/"+hb_ntos(nFatias)+"*"+hb_ntos(hItem["qtde"])+"))"
                cSQL += " where codigo="+hb_ntos(hItem["partes"][i]["codigo"])
                rs.execute(cSQL)
                if Rs.ErrorSQL(cSQL)
                    rs:RoolbackTrans()
                    Return .F.
                endif
            Next
            cSQL := "insert into vendas_detalhe_borda (venda,ordem,borda,valor) values ("
            cSQL += hb_ntos(nId) + ","
            cSQL += hb_ntos(nitem) +","
            cSQL += hb_ntos(hItem["borda"]["codigo"]) +","
            cSQL += hb_ntos(hitem["borda"]["valor"])
            cSQL += ");"
            rs.Execute(cSQL)
            if Rs.ErrorSQL(cSQL)
                rs:RoolbackTrans()
                Return .F.
            endif
        else
            rs.execute("update produtos set qtd_estoque=(qtd_estoque-"+hb_ntos( hItem["qtde"])+") where codigo="+hb_ntos( hItem["codigo"])+" and baixa")
            if Rs.ErrorSQL(rs.sql)
                rs:RoolbackTrans()
                Return .F.
            endif

        endif
    Next
    For i=1 to 3 //3 formas de pagamento
        if form_fecha_pedido.&("oFormaPagto"+hb_ntos(i)).value >0 .and. form_fecha_pedido.&("tbox_fr00"+hb_ntos(i)).value >0
            nDias :=  form_fecha_pedido.&("oFormaPagto"+hb_ntos(i)).cargo[form_fecha_pedido.&("oFormaPagto"+hb_ntos(i)).value]["dias"]
            if nDias > 0 //Lancamento contas a receber
                rs.sql := "Select * from contas where 1=2"
                rs.open()
                rs.addNew()
                rs.field.cod_origem.value   := nID
                rs.field.tipo.value         := "R"
                rs.field.num_doc.value      := nID
                rs.field.vencimento.value   := date() + form_fecha_pedido.&("oFormaPagto"+hb_ntos(i)).cargo[form_fecha_pedido.&("oFormaPagto"+hb_ntos(i)).value]["dias"]
                rs.field.valor.value        := form_fecha_pedido.&("tbox_fr00"+hb_ntos(i)).value
                rs.field.forma.value        := form_fecha_pedido.&("oFormaPagto"+hb_ntos(i)).cargo[form_fecha_pedido.&("oFormaPagto"+hb_ntos(i)).value]["codigo"]
                rs.field.fornecliente.value := form_Vendas.tbox_telefone.cargo[form_Vendas.tbox_telefone.value]["codigo"]
                rs.field.obs.value          := "DELIVERY"
            else
                rs.sql := "Select * from caixa where 1=2"
                rs.Open()
                rs.AddNew()
                rs.field.dtmovimento.value := tFechamento
                rs.field.forma.value       := form_fecha_pedido.&("oFormaPagto"+hb_ntos(i)).cargo[form_fecha_pedido.&("oFormaPagto"+hb_ntos(i)).value]["codigo"]
                rs.field.historico.value   := "DELIVERY:"+hb_ntos(nID)
                rs.field.entrada.value     := form_fecha_pedido.&("tbox_fr00"+hb_ntos(i)).value
                rs.field.saida.value       := 0
                rs.field.usuario.value     := App.cargo["usuario"]["codigo"]
                rs.field.editavel.value    := FALSE
            endif
            rs.Update()
            if Rs.ErrorSQL(rs.SQL)
                rs:RoolbackTrans()
                Return .F.
            endif
        endif
    Next
    rs:CommitTrans()
    hPedido["finalizado"] := TRUE
    return TRUE
    *-------------------------------------------------------------------------------
static function historico_cliente()
    Local rs.New(),aOnde:={"DELIVERY","MESA","BALCÃO"}
    form_vendas.grid_historico.deleteAllItems()
    form_vendas.grid_detalhamento.deleteallItems()
    if form_Vendas.tbox_telefone.value=0
        return FALSE
    Endif
    rs.sql := "Select top 10 codigo,onde,datahora,valor from vendas where Cliente="+hb_ntos(form_Vendas.tbox_telefone.cargo[form_Vendas.tbox_telefone.value]["codigo"])
    rs.sql += " order by datahora desc"
    rs.open()
    While !rs.eof()
        form_vendas.grid_historico.addItem({str(rs.field.codigo.value,10),;
                                            aOnde[rs.field.onde.value],;
                                            Padr(HB_TTOC(rs.field.datahora.value,"DD/MM/YYYY HH:MM:SS"),16),;
                                            Transform(rs.field.valor.value,"@E 99,999.99")})
        rs.moveNext()
    enddo
    return(nil)
    *-------------------------------------------------------------------------------
    *-------------------------------------------------------------------------------
static function excluir_item_pedido()
    Local nPos := form_vendas.grid_pedido.value,aItem,nTot
    Local nId,i
    if nPos = 0
        MsgInfo("Necessário selecionar um item para excluir ")
        Return .F.
    endif
    aItem := form_vendas.grid_pedido.item(nPos)
    nID   := Val(aItem[1])
    nTot := form_vendas.grid_pedido.itemcount
    for i=0 to nTot-1
        aItem := form_vendas.grid_pedido.item(nTot - i)
        if val(aItem[1]) = nID
            form_vendas.grid_pedido.deleteItem(nTot - i)
        endif
    Next
    hPedido["produtos"][nId]["ativo"] := FALSE //Marca como excluido
    form_vendas.label_total.value := transform(Calcula(),'@E 99,999.99')
    form_vendas.grid_pedido.value := 1
    Return(Nil)
    *-------------------------------------------------------------------------------
    *-------------------------------------------------------------------------------
static function imprimir_cupom()
    Local cTextCupom:="",hItem:=App.Cargo["empresa"],cBordas:=""
    Local nItem
    IF !fechamento_geral()
        Return .F.
    endif
    cTextCupom := Padr(hItem["nome"],48) + CRLF
    cTextCupom += Padr(hItem["endereco"],48) + CRLF
    cTextCupom += Padr(hItem["bairro"] +"/"+hItem["cidade"],48) + CRLF
    cTextCupom += Padr(hItem["web"] + "/"+hItem["telefone"],48) + CRLF
    cTextCupom += '------------------------------------------------' + CRLF
    cTextCupom += '         CUPOM PARA SIMPLES CONFERENCIA         ' + CRLF
    cTextCupom += '             NAO E DOCUMENTO FISCAL             ' + CRLF
    cTextCupom += '================================================' + CRLF
        
    hItem := form_Vendas.tbox_telefone.cargo[form_Vendas.tbox_telefone.value]
    cTextCupom += Padr("CLIENTE : "+default(hItem["fixo"],hItem["celular"])+"-"+hItem["nome"],48) + CRLF
    cTextCupom += Padr(hItem["endereco"],48) + CRLF
    cTextCupom += Padr(hItem["complem"]+","+hItem["bairro"],48) + CRLF
    cTextCupom += Padr("CEP : "+hItem["cep"],48) + CRLF
        
    hItem := form_fecha_pedido.oEntrega.cargo[form_fecha_pedido.oEntrega.value]
    cTextCupom += Padr('ENTREGADOR: '+hb_ntos(hItem["codigo"])+"."+hItem["nome"],48) + CRLF
        
    cTextCupom += Padr('DATA      : '+dtoc(date())+'           HORA: '+time(),48) + CRLF
    cTextCupom += '------------------------------------------------' + CRLF
    cTextCupom += 'PRODUTO                  QTD UNITARIO SUB-TOTAL ' + CRLF
    
    cTextCupom += CRLF
        
    For each hItem in hPedido["produtos"]
        if hItem["tipo"]="PI"
            if hItem["borda"]["codigo"]>1
                if at(hItem["borda"]["nome"],cBordas)=0
                    cBordas += hItem["borda"]["nome"]+"/"
                endif
            endif
            For nItem=1 to len(hItem["partes"])
                cTextCupom += Padr("1/"+hb_ntos(len(hItem["partes"]))+" "+hItem["partes"][nItem]["nome"],48) + CRLF
            Next
            cTextCupom += Padl("TOTAL",24)+" "+Transform(hItem["qtde"],"@R 999") + " "+Transform(hItem["valor"],"@E 9,999.99")+" "+Transform(hItem["valor"] * hItem["qtde"],"@E 99,999.99") + CRLF
        else
            cTextCupom += Padr(hItem["nome"],24)+" "+Transform(hItem["qtde"],"@R 999") + " "+Transform(hItem["valor"],"@E 9,999.99")+" "+Transform(hItem["valor"] * hItem["qtde"],"@E 99,999.99") + CRLF
        endif
    Next
    cBordas := substr(cBordas,1,len(cBordas)-1)
    cTextCupom += CRLF
    if hPedido["subtotalborda"] > 0
        cTextCupom += "BORDA"+CRLF
        cTextCupom += Padr("***" + cBordas +" ***",48) + CRLF
    endif
    cTextCupom += CRLF
    cTextCupom += '================================================'+CRLF
    cTextCupom += PadL("TOTAL PEDIDO :"   ,28)+" "+Transform(hPedido["subtotalpizza"] + hPedido["subtotalproduto"] ,"@E 999,999.99")+CRLF
    cTextCupom += PadL("TAXA DE ENTREGA :",28)+" "+Transform(hPedido["taxaentrega"],'@E 999,999.99')+CRLF
    cTextCupom += PadL("BORDA :"          ,28)+" "+Transform(hPedido["subtotalborda"],'@E 999,999.99')+CRLF
    cTextCupom += PadL("DESCONTO :"       ,28)+" "+Transform(hPedido["desconto"],'@E 999,999.99')+CRLF
    cTextCupom += PadL("TOTAL :"          ,28)+" "+Transform(hPedido["totalpedido"],'@E 999,999.99')+CRLF
    
    cTextCupom += CRLF
    cTextCupom +=  '------------------------------------------------' + CRLF
    cTextCupom +=  'Agradecemos a preferencia, Volte Sempre !'+ CRLF
    cTextCupom +=  ''+ CRLF
    cTextCupom +=  ''+ CRLF
    cTextCupom +=  '------------------------------------------------'+ CRLF
    cTextCupom +=  ''+ CRLF
    if !Empty(form_vendas.tbox_obs_1.value) .or. !Empty(form_vendas.tbox_obs_1.value)
        cTextCupom +=  'Observacoes deste pedido'+ CRLF
    endif
    if !Empty(form_vendas.tbox_obs_1.value)
        cTextCupom +=  '( '+form_vendas.tbox_obs_1.value+' )'+ CRLF
    endif
    if !Empty(form_vendas.tbox_obs_2.value)
        cTextCupom +=  '( '+form_vendas.tbox_obs_2.value+' )'+ CRLF
    endif
    cTextCupom += CRLF + CRLF + CRLF + CRLF + CRLF + CRLF + CRLF + CRLF + CRLF + CRLF + CRLF
    MemoWrite("Cupom.txt",cTextCupom)
    Fclose(FCreate("LPT1",cTextCupom))
    ShellExecute( 0,"Cupom.txt",,, , 0 )
    form_fecha_pedido.release()
    
    //Atualiza a tela
    Reset_Pedido()
    return(nil)
    *-------------------------------------------------------------------------------
Function Pede_Quantidade()
    Local nQtde:=0
    Load window vendas_form_pquantidade as Form_Qtde
        Form_Qtde.OnInteractiveClose := {||Form_Qtde.tbox_quantidade.value>0}
        Form_Qtde.onRelease := {||nQtde:= Form_Qtde.tbox_quantidade.value}
        Form_Qtde.tbox_quantidade.onEnter := {||Form_Qtde.release()}
        Form_Qtde.center()
    form_Qtde.Activate()
    Return nQtde
    *-------------------------------------------------------------------------------
Static function Calcula()
    Local h
    if empty(hPedido)
        Return 0
    endif
    hPedido["subtotalpizza"]   := 0
    hPedido["subtotalborda"]   := 0
    hPedido["subtotalproduto"] := 0
    for each h in hPedido["produtos"]
        if h["ativo"] //exclusão?
            if h["tipo"]="PI" //PI=Pizza PR=Produto
                hPedido["subtotalpizza"] += h["valor"] * h["qtde"]
                hPedido["subtotalborda"] += h["borda"]["valor"] *  h["qtde"]
            else
                hPedido["subtotalproduto"] += h["valor"] * h["qtde"]
            endif
        endif
    next
    hPedido["totalpedido"] := hPedido["subtotalpizza"] + hPedido["subtotalborda"] + hPedido["subtotalproduto"] + hPedido["taxaentrega"] - hPedido["desconto"]
    Return (hPedido["totalpedido"])
    *-------------------------------------------------------------------------------
Static function NewHash()
    Local hItem:=Hash()
    hItem["tipo"]        := "" //Produto ou Pizza
    hItem["codigo"]      := 0 //codigo do produto ou Pizza
    hItem["nome"]        := "" //Nome do produto
    hItem["valor"]       := 0 //valor
    hItem["borda"]       := Nil //hash de borda de for pizza
    hItem["partes"]      := {} //composicao fracionaria da pizza (sabores)
    hItem["promocao"]    := FALSE //é promocao
    hItem["ativo"]       := TRUE //excluido ?
    hItem["qtde"]        := 0 //Quantidade do pedido
    hItem["estoque"]     := 0 //quantidade em estoque
    HB_hCaseMatch(hItem,.F.) //Desliga a Maiuscula/Minuscula
    hb_hAutoAdd(hItem, .F.) //Não permite incluir  uma chave automaticamente, isso garante chave escrita errada
    Return hItem
    
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_vendas_oCancela_Action( )
    if msgyesno("Tem certeza que deseja cancelar este pedido ?")
        form_Vendas.tbox_telefone.visible := TRUE
        form_Vendas.telefone.visible      := FALSE
        form_Vendas.tbox_telefone.value:=0
        form_Vendas.tbox_telefone.setfocus()
        form_Vendas.oCancela.Enabled := .F.
        Reset_Pedido()
    endif
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static function Reset_Pedido(hItem)
    hPedido:=hash()
    hPedido["cliente"]          := hItem
    hPedido["subtotalpizza"]    := 0
    hPedido["subtotalborda"]    := 0
    hPedido["subtotalproduto"]  := 0
    hPedido["sequencia"]        := 0
    hPedido["taxaentrega"]      := 0
    hPedido["desconto"]         := 0
    hPedido["totalpedido"]      := 0
    hPedido["produtos"]         := {}
    hPedido["finalizado"]       := FALSE
    HB_hCaseMatch(hPedido,.F.) //Desliga a Maiuscula/Minuscula
    hb_hAutoAdd(hPedido, .F.) //Não permite incluir  uma chave automaticamente, isso garante chave escrita errada
    form_vendas.cbo_bordas.value := 0
    form_vendas.cbo_tamanhos.value := 0
    
    form_vendas.cbo_tamanhos.enabled       := !Empty(hItem)
    form_vendas.cbo_produtos.enabled       := !Empty(hItem)
    
    form_vendas.cbo_produtos.DeleteAllItems()
    form_vendas.cbo_sabores.DeleteAllItems()
    form_vendas.grid_pedido.DeleteAllItems()
    form_vendas.label_total.value := transform(Calcula(),'@E 99,999.99')
    form_vendas.grid_historico.deleteAllItems()
    Form_vendas.grid_detalhamento.deleteAllItems()
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_vendas_grid_pedido_Onchange( )
    form_vendas.botao_exclui_item_pedido.enabled := (form_vendas.grid_pedido.value > 0)
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
  
static function mostra_detalhamento()
    Local rs.new(),aItem,nOrd,nSeq
    form_vendas.grid_detalhamento.deleteallitems()
    if form_vendas.grid_historico.value = 0
        return .F.
    endif
    rs.sql := "SELECT V.venda, V.ordem, V.produto, P1.nome_longo as Nome, V.qtde, V.valor, PI.produto as pizza, PI.fator, PI.valor as valorpizza, P2.nome_longo as nomepizza "
    rs.sql += "FROM produtos AS P2 "
    rs.sql += "RIGHT JOIN ((produtos as P1 RIGHT JOIN vendas_detalhe AS V ON P1.codigo = V.produto) "
    rs.SQL += "LEFT JOIN vendas_detalhe_pizza as PI ON (V.ordem = PI.ordem) AND (V.venda = PI.venda)) ON P2.codigo = PI.produto "
    rs.SQL += "where V.venda="+form_vendas.grid_historico.item(form_vendas.grid_historico.value)[1]
    rs.Open()
    While !Rs.eof()
        aItem := {"","",""}
        if !empty(rs.field.produto.value)
            aItem[1] := hb_ntos(rs.field.qtde.value)
            aItem[2] := rs.field.nome.value
            aItem[3] := Transform(rs.field.valor.value*rs.field.qtde.value,"@E 99,999.99")
        else
            if rs.field.fator.value=1
                aItem[1] := hb_ntos(rs.field.qtde.value)
                aItem[2] := "1."+rs.field.nomepizza.value
                aItem[3] := Transform(rs.field.valor.value*rs.field.qtde.value,"@E 99,999.99")
            else
                nOrd:=rs.field.ordem.value
                nSeq:=1
                aItem[1] := hb_ntos(rs.field.qtde.value)
                aItem[2] := "PIZZA SABORES VARIADOS"
                aItem[3] := Transform(rs.field.valor.value*rs.field.qtde.value,"@E 99,999.99")
                form_vendas.grid_detalhamento.addItem(aItem)
                aItem[1]:="----------"
                aItem[3]:="----------"
                While !rs.eof .and. nOrd=rs.field.ordem.value
                    aItem[2] := hb_ntos(nSeq)+" - 1/"+hb_ntos(rs.field.fator.value)+"."+rs.field.nomepizza.value
                    form_vendas.grid_detalhamento.addItem(aItem)
                    rs.moveNext()
                    nSeq++
                enddo
                Loop
            endif
        endif
        form_vendas.grid_detalhamento.addItem(aItem)
        rs.MoveNext()
    Enddo
    return(nil)
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_fecha_pedido_oFormaPagto_Onlistdisplay( )
    Local cName:=This.Name
    Local rs.new()
    Local hItem
    form_fecha_pedido.&(cName).deleteAllItems()
    form_fecha_pedido.&(cName).cargo := {}
    rs.sql := "Select top 100 codigo,nome,dias_paga from forma_pag_rec where tipo='R' and nome like '"+form_fecha_pedido.&(cName).displayValue+"%'"
    rs.Open()
    While !rs.Eof()
        hItem := hash()
        hItem["codigo"] := rs.field.codigo.value
        hItem["nome"]   := rs.field.nome.value
        hItem["dias"]   := rs.field.dias_paga.value
        form_fecha_pedido.&(cName).additem(hItem["nome"])
        AADD(form_fecha_pedido.&(cName).cargo,hItem)
        rs.MoveNext()
    Enddo    
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_fecha_pedido_oFormaPagto_Onenter( )
    Local cName:=This.Name
    if form_fecha_pedido.&(cName).value>0
        return .T.
    endif
    PostMessage(form_fecha_pedido.&(cName).handle,(320+15),1,0)
    form_fecha_pedido.&(cName).setfocus()
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_fecha_pedido_oEntrega_Onlistdisplay( )
    Local rs.New() , hItem
    rs.sql := "Select codigo,nome from motoboys where ativo and nome like '"+form_fecha_pedido.oEntrega.displayValue+"%' order by nome"
    rs.Open()
    form_fecha_pedido.oEntrega.deleteAllItems()
    form_fecha_pedido.oEntrega.cargo := {}
    While !rs.Eof()
        hItem := hash()
        hItem["codigo"] := rs.field.codigo.value
        hItem["nome"]   := rs.field.nome.value
        form_fecha_pedido.oEntrega.addItem(hItem["nome"])
        AADD(form_fecha_pedido.oEntrega.cargo,hItem)
        rs.MoveNext()
    Enddo
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_fecha_pedido_oEntrega_Onenter( )
    if form_fecha_pedido.oEntrega.value >0
        Return .T.
    endif
    PostMessage(form_fecha_pedido.oEntrega.handle,(320+15),1,0)
    form_fecha_pedido.oEntrega.setfocus()
    Return .T.
