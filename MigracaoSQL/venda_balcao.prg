/*
  sistema     : superchef pizzaria
  programa    : venda balcão
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
    Última alteração : 14/05/2021-08:23:04 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

function venda_balcao()
    Load Window venda_balcao_form_balcao as form_balcao
        on key     F5 OF form_balcao action fecha_pizza()
        on key     F9 OF form_balcao action fecha_pedido()
        on key escape OF form_balcao action thiswindow.release
        form_balcao.maximize
    form_balcao.activate
    return(nil)
    *-------------------------------------------------------------------------------
Static Function form_balcao_tbox_telefone_Onlistdisplay( )
    Local rs.new()
    Local cValue := form_balcao.tbox_telefone.DisplayValue
    Local hItem
    form_balcao.tbox_telefone.DeleteAllItems()
    form_balcao.tbox_telefone.cargo:={}
    if empty(cValue)
        Return FALSE
    endif
    rs.sql := "Select top 30 codigo,nome,fixo,celular,endereco,numero,complem,bairro,cep,email from clientes"
    rs.sql += "where fixo='"+cValue+"' or celular='"+cValue+"' or nome like '"+cValue+"%' or email like '"+cValue+"%'"
    rs.Open()
    form_balcao.tbox_telefone.disableUpdate
    While !rs.Eof()
        form_balcao.tbox_telefone.addItem(rs.field.nome.value+" - "+rs.field.endereco.value)
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
        AADD(form_balcao.tbox_telefone.cargo,hItem)
        rs.MoveNext()
    Enddo
    form_balcao.tbox_telefone.enableUpdate
    Return .T.
    *-------------------------------------------------------------------------------
Static Function form_balcao_tbox_telefone_Onenter( )
    if form_balcao.tbox_telefone.value>0
        return .T.
    endif
    PostMessage(form_balcao.tbox_telefone.handle,(320+15),1,0)
    form_balcao.tbox_telefone.setfocus()    
    Return .T.
    *-------------------------------------------------------------------------------
Static Function form_balcao_tbox_telefone_Onchange( )
    Local hItem
    if form_balcao.tbox_telefone.value>0
        hItem := form_balcao.tbox_telefone.cargo[form_balcao.tbox_telefone.value]
        form_balcao.label_nome_cliente.value := hItem["nome"]
        form_balcao.label_endereco_001.value := hItem["endereco"
        form_balcao.label_endereco_002.value := hItem["complem"
        form_balcao.label_endereco_003.value := hItem["bairro"]+"-"+hItem["cep"]
    else
        form_balcao.label_nome_cliente.value := ""
        form_balcao.label_endereco_001.value := ""
        form_balcao.label_endereco_002.value := ""
        form_balcao.label_endereco_003.value := ""
    endif
    Return .T.    
    *-------------------------------------------------------------------------------
Static Function form_balcao_tbox_produto_Onlistdisplay( )
    Local rs.new()
    Local cValue := form_balcao.tbox_produto.DisplayValue
    Local hItem
    form_balcao.tbox_produto.DeleteAllItems()
    form_balcao.tbox_produto.cargo:={}
    if empty(cValue)
        Return FALSE
    endif
    rs.sql := "Select top 30 codigo,nome_longo,vlr_venda,promocao from produtos"
    rs.sql += "where not pizza and nome_longo like '"+cValue+"%'"
    rs.Open()
    form_balcao.tbox.tbox_produto.disableUpdate
    While !rs.Eof()
        form_balcao.tbox_produto.addItem(rs.field.nome_longo.value)
        hItem:=hash()
        hItem["codigo"]    := rs.field.codigo.value
        hItem["nome"]      := rs.field.nome_longo.value
        hItem["vlr_venda"] := rs.field.vlr_venda.value
        hItem["promocao"]  := rs.field.promocao.value
        AADD(form_balcao.tbox_produto.cargo,hItem)
        rs.MoveNext()
    Enddo
    form_balcao.tbox_produto.enableUpdate    
    Return .T.
    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_balcao_tbox_produto_Onenter( )
    if form_balcao.tbox_produto.value>0
        return .T.
    endif
    PostMessage(form_balcao.tbox_produto.handle,(320+15),1,0)
    form_balcao.tbox_produto.setfocus()       
    Return .T.

    *-------------------------------------------------------------------------------
Static Function form_balcao_tbox_pizza_Onlistdisplay( )
    Local rs.new()
    Local cValue := form_balcao.tbox_pizza.DisplayValue
    Local hItem
    form_balcao.tbox_pizza.DeleteAllItems()
    form_balcao.tbox_pizza.cargo:={}
    if empty(cValue)
        Return FALSE
    endif
    rs.sql := "Select top 30 codigo,nome_longo,vlr_venda,promocao from produtos"
    rs.sql += "where pizza and nome_longo like '"+cValue+"%'"
    rs.Open()
    form_balcao.tbox.tbox_pizza.disableUpdate
    While !rs.Eof()
        form_balcao.tbox_pizza.addItem(rs.field.nome_longo.value+IIF(rs.field.promocao.value," *PROMOÇÃO",""))
        hItem:=hash()
        hItem["codigo"]    := rs.field.codigo.value
        hItem["nome"]      := rs.field.nome_longo.value
        hItem["vlr_venda"] := rs.field.vlr_venda.value
        hItem["promocao"]  := rs.field.promocao.value
        AADD(form_balcao.tbox_pizza.cargo,hItem)
        rs.MoveNext()
    Enddo
    form_balcao.tbox_pizza.enableUpdate    
    Return .T.
    *-------------------------------------------------------------------------------
Static Function form_balcao_tbox_pizza_Onenter( )
    if form_balcao.tbox_pizza.value>0
        return .T.
    endif
    PostMessage(form_balcao.tbox_pizza.handle,(320+15),1,0)
    form_balcao.tbox_pizza.setfocus()     
    Return .T.    
    *-------------------------------------------------------------------------------
static function cadastrar_novo_cliente()
    clientes(TRUE)
    Return .T.
    *-------------------------------------------------------------------------------
static function gravar_adicionar()
    
    dbselectarea('tmp_pizza')
    tmp_pizza->(dbappend())
    tmp_pizza->id_produto := form_balcao.tbox_pizza.value
    tmp_pizza->nome       := form_balcao.label_nome_pizza.value
    tmp_pizza->(dbcommit())
    tmp_pizza->(dbgotop())
    
    form_balcao.grid_pizzas.refresh
    form_balcao.grid_pizzas.setfocus
    form_balcao.grid_pizzas.value := recno()
    
    form_balcao.tbox_pizza.value := ''
    form_balcao.tbox_pizza.setfocus
    
    return(nil)
    *-------------------------------------------------------------------------------
static function gravar_produto()
    
    dbselectarea('tmp_produto')
    tmp_produto->(dbappend())
    tmp_produto->produto  := form_balcao.tbox_produto.value
    tmp_produto->nome     := form_balcao.label_nome_produto.value
    tmp_produto->qtd      := form_balcao.tbox_quantidade.value
    tmp_produto->unitario := form_balcao.tbox_preco.value
    tmp_produto->subtotal := (form_balcao.tbox_preco.value*form_balcao.tbox_quantidade.value)
    tmp_produto->(dbcommit())
    tmp_produto->(dbgotop())
    
    form_balcao.grid_produtos.refresh
    form_balcao.grid_produtos.setfocus
    form_balcao.grid_produtos.value := recno()
    
    form_balcao.tbox_produto.value := ''
    form_balcao.tbox_produto.setfocus
    
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir_pizza()
    
    if empty(tmp_pizza->nome)
        msgalert('Escolha o que deseja excluir primeiro','Atenção')
        return(nil)
    endif
    
    if msgyesno('Excluir : '+alltrim(tmp_pizza->nome),'Excluir')
        tmp_pizza->(dbdelete())
    endif
    
    form_balcao.grid_pizzas.refresh
    form_balcao.grid_pizzas.setfocus
    form_balcao.grid_pizzas.value := recno()
    
    return(nil)
    *-------------------------------------------------------------------------------
static function excluir_produto()
    
    if empty(tmp_produto->nome)
        msgalert('Escolha o que deseja excluir primeiro','Atenção')
        return(nil)
    endif
    
    if msgyesno('Excluir : '+alltrim(tmp_produto->nome),'Excluir')
        tmp_produto->(dbdelete())
    endif
    
    form_balcao.grid_produtos.refresh
    form_balcao.grid_produtos.setfocus
    form_balcao.grid_produtos.value := recno()
    
    return(nil)
    *-------------------------------------------------------------------------------
static function fecha_pizza()
    
    dbselectarea('tmp_pizza')
    tmp_pizza->(dbgotop())
    if eof()
        msgexclamation('Nenhuma pizza foi selecionada ainda','Atenção')
        return(nil)
    endif
    
    Load Window venda_balcao_form_finaliza_pizza as form_finaliza_pizza
    /*
    define window form_finaliza_pizza;
            at 000,000;
            width 1000;
            height 400;
            title 'Finalizar pizza';
            icon path_imagens+'icone.ico';
            modal;
            nosize
        
        @ 005,005 label lbl_001;
            of form_finaliza_pizza;
            value '1- Selecione o tamanho da pizza';
            autosize;
            font 'tahoma' size 010;
            bold;
            fontcolor _preto_001;
            transparent
        @ 025,005 label lbl_002;
            of form_finaliza_pizza;
            value '2- Você poderá escolher entre o menor e o maior preço à ser cobrado, no caso de ter mais de 1 sabor na mesma pizza';
            autosize;
            font 'tahoma' size 010;
            bold;
            fontcolor _preto_001;
            transparent
        @ 045,005 label lbl_003;
            of form_finaliza_pizza;
            value '3- Caso deseje, ao fechamento deste pedido, poderá conceder um desconto especial ao cliente';
            autosize;
            font 'tahoma' size 010;
            bold;
            fontcolor _preto_001;
            transparent
        @ 065,005 label lbl_004;
            of form_finaliza_pizza;
            value '4- Para finalizar esta pizza e continuar vendendo, dê duplo-clique ou enter sobre o tamanho/preço escolhido';
            autosize;
            font 'tahoma' size 010;
            bold;
            fontcolor BLUE;
            transparent
        @ 085,005 label lbl_005;
            of form_finaliza_pizza;
            value '5- ESC fecha esta janela e retorna para a tela de vendas';
            autosize;
            font 'tahoma' size 010;
            bold;
            fontcolor _vermelho_002;
            transparent
        
        define grid grid_finaliza_pizza
            parent form_finaliza_pizza
            col 005
            row 105
            width 985
            height 260
            headers {'id','Pizza',_tamanho_001,_tamanho_002,_tamanho_003,_tamanho_004,_tamanho_005,_tamanho_006}
            widths {001,250,120,120,120,120,120,120}
            value 1
            celled .T.
            fontname 'verdana'
            fontsize 010
            fontbold .T.
            backcolor _cinza_005
            fontcolor _preto_001
            ondblclick pega_tamanho_valor_pizza()
        end grid
        
        on key escape action thiswindow.release
        
    end window
    */
    
    monta_informacao_pizza()
    
    form_finaliza_pizza.center
    form_finaliza_pizza.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function monta_informacao_pizza()
    
    dbselectarea('tmp_pizza')
    tmp_pizza->(dbgotop())
    
    delete item all from grid_finaliza_pizza of form_finaliza_pizza
    
    while .not. eof()
        dbselectarea('produtos')
        produtos->(ordsetfocus('codigo'))
        produtos->(dbgotop())
        produtos->(dbseek(tmp_pizza->id_produto))
        if found()
            add item {produtos->codigo,alltrim(produtos->nome_longo)+iif(produtos->promocao,' (promoção)',''),trans(produtos->val_tm_001,'@E 99,999.99'),trans(produtos->val_tm_002,'@E 99,999.99'),trans(produtos->val_tm_003,'@E 99,999.99'),trans(produtos->val_tm_004,'@E 99,999.99'),trans(produtos->val_tm_005,'@E 99,999.99'),trans(produtos->val_tm_006,'@E 99,999.99')} to grid_finaliza_pizza of form_finaliza_pizza
        endif
        dbselectarea('tmp_pizza')
        tmp_pizza->(dbskip())
    end
    
    return(nil)
    *-------------------------------------------------------------------------------
static function pega_tamanho_valor_pizza()
    
    local valor_do_grid  := form_finaliza_pizza.grid_finaliza_pizza.value
    local item_valor     := form_finaliza_pizza.grid_finaliza_pizza.cell(getproperty('form_finaliza_pizza','grid_finaliza_pizza','value')[1],getproperty('form_finaliza_pizza','grid_finaliza_pizza','value')[2])
    local x_preco        := val(strtran(item_valor,','))/100
    local x_coluna       := valor_do_grid[2]
    local x_nome_tamanho := space(30)
    
    if x_coluna == 1
        return(nil)
    elseif x_coluna == 2
        return(nil)
    elseif x_coluna == 3
        x_nome_tamanho := alltrim(_tamanho_001)+' '+alltrim(str(_pedaco_001))+'ped'
    elseif x_coluna == 4
        x_nome_tamanho := alltrim(_tamanho_002)+' '+alltrim(str(_pedaco_002))+'ped'
    elseif x_coluna == 5
        x_nome_tamanho := alltrim(_tamanho_003)+' '+alltrim(str(_pedaco_003))+'ped'
    elseif x_coluna == 6
        x_nome_tamanho := alltrim(_tamanho_004)+' '+alltrim(str(_pedaco_004))+'ped'
    elseif x_coluna == 7
        x_nome_tamanho := alltrim(_tamanho_005)+' '+alltrim(str(_pedaco_005))+'ped'
    elseif x_coluna == 8
        x_nome_tamanho := alltrim(_tamanho_006)+' '+alltrim(str(_pedaco_006))+'ped'
    endif
    
    dbselectarea('tmp_pizza')
    tmp_pizza->(dbgotop())
    while .not. eof()
        if empty(tmp_pizza->sequencia)
            replace sequencia with 'pizza '+alltrim(str(_conta_pizza))
            replace tamanho with x_nome_tamanho
            replace preco with x_preco
        endif
        tmp_pizza->(dbskip())
    end
    
    _conta_pizza ++
    
    form_finaliza_pizza.release
    form_balcao.grid_pizzas.refresh
    form_balcao.grid_pizzas.setfocus
    form_balcao.tbox_observacoes.setfocus
    
    return(nil)
    *-------------------------------------------------------------------------------
static function verifica_zero()
    
    local x_qtd := form_balcao.tbox_quantidade.value
    
    if empty(x_qtd)
        form_balcao.tbox_quantidade.setfocus
        return(nil)
    endif
    
    return(nil)
    *-------------------------------------------------------------------------------
static function fecha_pedido()
    
    local x_old_pizza      //:= space(10)
    local x_old_valor      //:= 0
    *       local x_total_pedido   //:= 0
    *       local x_total_recebido //:= 0
    private x_valor_pizza  //:= 0
    private x_valor_prod   //:= 0
    
    dbselectarea('tmp_pizza')
    tmp_pizza->(dbgotop())
    if eof()
        msgstop('Nenhuma pizza foi vendida','Atenção')
    else
        while .not. eof()
            x_old_pizza := tmp_pizza->sequencia
            x_old_valor := tmp_pizza->preco
            tmp_pizza->(dbskip())
            if tmp_pizza->sequencia <> x_old_pizza
                x_valor_pizza := (x_valor_pizza+x_old_valor)
            endif
        end
    endif
    
    dbselectarea('tmp_produto')
    tmp_produto->(dbgotop())
    if eof()
        msgstop('Nenhum produto foi vendido','Atenção')
    else
        while .not. eof()
            x_valor_prod := (x_valor_prod+tmp_produto->subtotal)
            tmp_produto->(dbskip())
        end
    endif
    
    Load Window venda_balcao_form_fecha_pedido as form_fecha_pedido
    /*
    define window form_fecha_pedido;
            at 000,000;
            width 500;
            height 540;
            title 'Fechamento do pedido';
            icon path_imagens+'icone.ico';
            modal;
            nosize
        
        * linhas para separar os elementos na tela
        define label label_sep_001
            col 000
            row 190
            value ''
            width 500
            height 002
            transparent .F.
            backcolor _cinza_002
        end label
        define label label_sep_002
            col 000
            row 390
            value ''
            width 500
            height 002
            transparent .F.
            backcolor _cinza_002
        end label
        
        @ 010,020 label label_001;
            of form_fecha_pedido;
            value 'SUBTOTAL PIZZAS';
            autosize;
            font 'verdana' size 012;
            bold;
            fontcolor BLUE;
            transparent
        @ 010,250 label label_001_valor;
            of form_fecha_pedido;
            value trans(x_valor_pizza,'@E 999,999.99');
            autosize;
            font 'courier new' size 016;
            bold;
            fontcolor BLUE;
            transparent
        *--------
        @ 040,020 label label_002;
            of form_fecha_pedido;
            value 'SUBTOTAL PRODUTOS';
            autosize;
            font 'verdana' size 012;
            bold;
            fontcolor BLUE;
            transparent
        @ 040,250 label label_002_valor;
            of form_fecha_pedido;
            value trans(x_valor_prod,'@E 999,999.99');
            autosize;
            font 'courier new' size 016;
            bold;
            fontcolor BLUE;
            transparent
        *--------
        @ 110,020 label label_004;
            of form_fecha_pedido;
            value 'DESCONTO';
            autosize;
            font 'verdana' size 012;
            bold;
            fontcolor _vermelho_002;
            transparent
        @ 110,250 getbox tbox_desconto;
            of form_fecha_pedido;
            height 030;
            width 130;
            value 0;
            font 'courier new' size 016;
            bold;
            backcolor _fundo_get;
            fontcolor _vermelho_002;
            picture '@E 9,999.99';
            on change setproperty('form_fecha_pedido','label_005_valor','value',trans((x_valor_pizza+x_valor_prod)-form_fecha_pedido.tbox_desconto.value,'@E 999,999.99'));
            on lostfocus setproperty('form_fecha_pedido','label_005_valor','value',trans((x_valor_pizza+x_valor_prod)-form_fecha_pedido.tbox_desconto.value,'@E 999,999.99'))
        *--------
        @ 150,020 label label_005;
            of form_fecha_pedido;
            value 'TOTAL DESTE PEDIDO';
            autosize;
            font 'verdana' size 012;
            bold;
            fontcolor BLUE;
            transparent
        @ 150,250 label label_005_valor;
            of form_fecha_pedido;
            value '';
            autosize;
            font 'courier new' size 016;
            bold;
            fontcolor BLUE;
            transparent
        
        * escolher formas de recebimento
        @ 200,020 label label_006;
            of form_fecha_pedido;
            value 'Você pode escolher até 3 formas de recebimento';
            autosize;
            font 'verdana' size 012;
            bold;
            fontcolor _preto_001;
            transparent
        * formas de recebimento
        * 1º
        @ 230,020 combobox combo_1;
            itemsource formas_recebimento->nome;
            valuesource formas_recebimento->codigo;
            value 1;
            width 250;
            font 'courier new' size 010
        @ 230,300 getbox tbox_fr001;
            of form_fecha_pedido;
            height 030;
            width 130;
            value 0;
            font 'courier new' size 014;
            bold;
            backcolor _fundo_get;
            fontcolor _letra_get_1;
            picture '@E 99,999.99'
        * 2º
        @ 270,020 combobox combo_2;
            itemsource formas_recebimento->nome;
            valuesource formas_recebimento->codigo;
            value 1;
            width 250;
            font 'courier new' size 010
        @ 270,300 getbox tbox_fr002;
            of form_fecha_pedido;
            height 030;
            width 130;
            value 0;
            font 'courier new' size 014;
            bold;
            backcolor _fundo_get;
            fontcolor _letra_get_1;
            picture '@E 99,999.99'
        * 3º
        @ 310,020 combobox combo_3;
            itemsource formas_recebimento->nome;
            valuesource formas_recebimento->codigo;
            value 1;
            width 250;
            font 'courier new' size 010
        @ 310,300 getbox tbox_fr003;
            of form_fecha_pedido;
            height 030;
            width 130;
            value 0;
            font 'courier new' size 014;
            bold;
            backcolor _fundo_get;
            fontcolor _letra_get_1;
            picture '@E 99,999.99';
            on lostfocus calcula_final()
        
        @ 360,020 label label_011;
            of form_fecha_pedido;
            value 'TOTAL RECEBIDO';
            autosize;
            font 'verdana' size 012;
            bold;
            fontcolor BLUE;
            transparent
        @ 360,250 label label_011_valor;
            of form_fecha_pedido;
            value '';
            autosize;
            font 'courier new' size 016;
            bold;
            fontcolor BLUE;
            transparent
        
        *--------
        @ 400,020 label label_012;
            of form_fecha_pedido;
            value 'TROCO';
            autosize;
            font 'verdana' size 012;
            bold;
            fontcolor _vermelho_002;
            transparent
        @ 400,250 label label_012_valor;
            of form_fecha_pedido;
            value '';
            autosize;
            font 'courier new' size 016;
            bold;
            fontcolor BLUE;
            transparent
        
        * botões
        @ 460,115 buttonex botao_ok;
            parent form_fecha_pedido;
            caption 'Fechar pedido';
            width 150 height 040;
            picture path_imagens+'img_pedido.bmp';
            action fechamento_geral();
            tooltip 'Clique aqui para finalizar o pedido'
        @ 460,270 buttonex botao_voltar;
            parent form_fecha_pedido;
            caption 'Voltar para tela anterior';
            width 220 height 040;
            picture path_imagens+'img_sair.bmp';
            action form_fecha_pedido.release;
            tooltip 'Clique aqui para voltar a vender'
        
        on key escape action thiswindow.release
        
    end window
    */
    
    form_fecha_pedido.center
    form_fecha_pedido.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function calcula_final()
    
    local x_val_001 // := 0
    local x_val_002 // := 0
    local x_val_003 // := 0
    local x_val_004 // := 0
    local x_val_005 // := 0
    local x_val_006 // := 0
    local x_val_007 // := 0
    local x_total   // := 0
    local x_recebido// := 0
    local x_troco   // := 0
    
    x_val_001 := x_valor_pizza
    x_val_002 := x_valor_prod
    x_val_003 := 0
    x_val_004 := form_fecha_pedido.tbox_desconto.value
    x_val_005 := form_fecha_pedido.tbox_fr001.value
    x_val_006 := form_fecha_pedido.tbox_fr002.value
    x_val_007 := form_fecha_pedido.tbox_fr003.value
    
    x_total    := (x_val_001+x_val_002+x_val_003)-(x_val_004)
    x_recebido := (x_val_005+x_val_006+x_val_007)
    x_troco    := (x_recebido-x_total)
    
    setproperty('form_fecha_pedido','label_011_valor','value',trans(x_recebido,'@E 999,999.99'))
    setproperty('form_fecha_pedido','label_012_valor','value',trans(x_troco,'@E 999,999.99'))
    
    return(nil)
    *-------------------------------------------------------------------------------
static function fechamento_geral()
    
    local x_val_001 // := 0
    local x_val_002 // := 0
    local x_val_003 // := 0
    local x_val_004 // := 0
    local x_val_005 // := 0
    local x_val_006 // := 0
    local x_val_007 // := 0
    local x_total   // := 0
    local x_recebido// := 0
    local x_cod_forma_1// := 0
    local x_cod_forma_2// := 0
    local x_cod_forma_3// := 0
    local x_dias //:= 0
    
    ******************************
    
    x_val_001     := x_valor_pizza
    x_val_002     := x_valor_prod
    x_val_003     := 0
    x_val_004     := form_fecha_pedido.tbox_desconto.value
    x_cod_forma_1 := form_fecha_pedido.combo_1.value
    x_cod_forma_2 := form_fecha_pedido.combo_2.value
    x_cod_forma_3 := form_fecha_pedido.combo_3.value
    x_val_005     := form_fecha_pedido.tbox_fr001.value
    x_val_006     := form_fecha_pedido.tbox_fr002.value
    x_val_007     := form_fecha_pedido.tbox_fr003.value
    
    x_total    := (x_val_001+x_val_002+x_val_003)-(x_val_004)
    x_recebido := (x_val_005+x_val_006+x_val_007)
    
    *********************************************
    
    * formas de recebimento
    * 1
    if .not. empty(x_val_005)
        dbselectarea('formas_recebimento')
        formas_recebimento->(ordsetfocus('codigo'))
        formas_recebimento->(dbgotop())
        formas_recebimento->(dbseek(x_cod_forma_1))
        if found()
            x_dias := formas_recebimento->dias_receb
        endif
        dbselectarea('contas_receber')
        contas_receber->(dbappend())
        contas_receber->id      := substr(alltrim(str(HB_RANDOM(0001240003,9999999999))),1,10)
        contas_receber->data    := date() + x_dias
        contas_receber->valor   := x_val_005
        contas_receber->forma   := x_cod_forma_1
        contas_receber->cliente := __codigo_cliente
        contas_receber->(dbcommit())
    endif
    * 2
    if .not. empty(x_val_006)
        dbselectarea('formas_recebimento')
        formas_recebimento->(ordsetfocus('codigo'))
        formas_recebimento->(dbgotop())
        formas_recebimento->(dbseek(x_cod_forma_2))
        if found()
            x_dias := formas_recebimento->dias_receb
        endif
        dbselectarea('contas_receber')
        contas_receber->(dbappend())
        contas_receber->id      := substr(alltrim(str(HB_RANDOM(0001240003,9999999999))),1,10)
        contas_receber->data    := date() + x_dias
        contas_receber->valor   := x_val_006
        contas_receber->forma   := x_cod_forma_2
        contas_receber->cliente := __codigo_cliente
        contas_receber->(dbcommit())
    endif
    * 3
    if .not. empty(x_val_007)
        dbselectarea('formas_recebimento')
        formas_recebimento->(ordsetfocus('codigo'))
        formas_recebimento->(dbgotop())
        formas_recebimento->(dbseek(x_cod_forma_3))
        if found()
            x_dias := formas_recebimento->dias_receb
        endif
        dbselectarea('contas_receber')
        contas_receber->(dbappend())
        contas_receber->id      := substr(alltrim(str(HB_RANDOM(0001240003,9999999999))),1,10)
        contas_receber->data    := date() + x_dias
        contas_receber->valor   := x_val_007
        contas_receber->forma   := x_cod_forma_3
        contas_receber->cliente := __codigo_cliente
        contas_receber->(dbcommit())
    endif
    
    * caixa
    
    dbselectarea('caixa')
    caixa->(dbappend())
    caixa->id        := substr(alltrim(str(HB_RANDOM(0010023003,9999999999))),1,10)
    caixa->data      := date()
    caixa->historico := 'Venda Balcão'
    caixa->entrada   := x_recebido
    caixa->saida     := 0
    caixa->(dbcommit())
    
    * baixar os produtos
    
    dbselectarea('tmp_produto')
    tmp_produto->(dbgotop())
    while .not. eof()
        dbselectarea('produtos')
        produtos->(ordsetfocus('codigo'))
        produtos->(dbgotop())
        produtos->(dbseek(tmp_produto->produto))
        if found()
            if lock_reg()
                produtos->qtd_estoq := produtos->qtd_estoq - tmp_produto->qtd
                produtos->(dbcommit())
            endif
        endif
        dbselectarea('tmp_produto')
        tmp_produto->(dbskip())
    end
    
    * baixar matéria prima
    
    x_old := space(10)
    
    dbselectarea('tmp_pizza')
    tmp_pizza->(dbgotop())
    while .not. eof()
        dbselectarea('produto_composto')
        produto_composto->(ordsetfocus('id_produto'))
        produto_composto->(dbgotop())
        produto_composto->(dbseek(tmp_pizza->id_produto))
        if found()
            while .T.
                x_old := produto_composto->id_produto
                dbselectarea('materia_prima')
                materia_prima->(ordsetfocus('codigo'))
                materia_prima->(dbgotop())
                materia_prima->(dbseek(produto_composto->id_mprima))
                if found()
                    if lock_reg()
                        materia_prima->qtd := materia_prima->qtd - produto_composto->quantidade
                        materia_prima->(dbcommit())
                        materia_prima->(dbunlock())
                    endif
                endif
                dbselectarea('produto_composto')
                produto_composto->(dbskip())
                if produto_composto->id_produto <> x_old
                    exit
                endif
            end
        endif
        dbselectarea('tmp_pizza')
        tmp_pizza->(dbskip())
    end
    
    * ultimas compras do cliente
    
    x_hora := space(08)
    x_hora := time()
    
    dbselectarea('ultimas_compras')
    ultimas_compras->(dbappend())
    ultimas_compras->id_cliente := __codigo_cliente
    ultimas_compras->data       := date()
    ultimas_compras->hora       := x_hora
    ultimas_compras->onde       := 3 //1=delivery 2=mesa 3=balcão
    ultimas_compras->valor      := x_total
    ultimas_compras->(dbcommit())
    
    * detalhamento - ultimas compras do cliente
    
    dbselectarea('tmp_produto')
    tmp_produto->(dbgotop())
    while .not. eof()
        dbselectarea('detalhamento_compras')
        detalhamento_compras->(dbappend())
        detalhamento_compras->id_cliente := __codigo_cliente
        detalhamento_compras->data       := date()
        detalhamento_compras->hora       := x_hora
        detalhamento_compras->id_prod    := tmp_produto->produto
        detalhamento_compras->qtd        := tmp_produto->qtd
        detalhamento_compras->unitario   := tmp_produto->unitario
        detalhamento_compras->subtotal   := tmp_produto->subtotal
        detalhamento_compras->(dbcommit())
        dbselectarea('tmp_produto')
        tmp_produto->(dbskip())
    end
    dbselectarea('tmp_pizza')
    tmp_pizza->(dbgotop())
    while .not. eof()
        dbselectarea('detalhamento_compras')
        detalhamento_compras->(dbappend())
        detalhamento_compras->id_cliente := __codigo_cliente
        detalhamento_compras->data       := date()
        detalhamento_compras->hora       := x_hora
        detalhamento_compras->id_prod    := tmp_pizza->id_produto
        detalhamento_compras->subtotal   := tmp_pizza->preco
        detalhamento_compras->(dbcommit())
        dbselectarea('tmp_pizza')
        tmp_pizza->(dbskip())
    end
    
    * jogar para acompanhamento
    
    dbselectarea('clientes')
    clientes->(ordsetfocus('codigo'))
    clientes->(dbgotop())
    clientes->(dbseek(__codigo_cliente))
    dbselectarea('entrega')
    entrega->(dbappend())
    entrega->cliente  := alltrim(clientes->nome)
    entrega->endereco := alltrim(clientes->endereco)+', '+alltrim(clientes->numero)
    if empty(clientes->fixo)
        entrega->telefone := clientes->celular
    else
        entrega->telefone := clientes->fixo
    endif
    entrega->hora     := x_hora
    entrega->origem   := 'Balcão'
    entrega->situacao := 'Montando'
    entrega->vlr_taxa := 0
    entrega->(dbcommit())
    
    * fechar as janelas
    
    form_fecha_pedido.release
    form_balcao.release
    
    return(nil)
    *-------------------------------------------------------------------------------
static function historico_cliente_2(parametro)
    
    delete item all from grid_historico of form_balcao
    
    dbselectarea('ultimas_compras')
    ultimas_compras->(ordsetfocus('id_cliente'))
    ultimas_compras->(dbgotop())
    ultimas_compras->(dbseek(parametro))
    
    if found()
        while .T.
            add item {str(ultimas_compras->id_cliente,6),a_onde[ultimas_compras->onde],dtoc(ultimas_compras->data),alltrim(ultimas_compras->hora),trans(ultimas_compras->valor,'@E 999,999.99')} to grid_historico of form_balcao
            ultimas_compras->(dbskip())
            if ultimas_compras->id_cliente <> parametro
                exit
            endif
        end
    endif
    
    return(nil)
    *-------------------------------------------------------------------------------
static function mostra_detalhamento_2()
    
    local x_id      := valor_coluna('grid_historico','form_balcao',1)
    local x_data    := valor_coluna('grid_historico','form_balcao',3)
    local x_hora    := alltrim(valor_coluna('grid_historico','form_balcao',4))
    local x_data_2  := ctod(x_data)
    local x_chave   := x_id+dtos(x_data_2)+x_hora
    local parametro := val(x_id)
    
    delete item all from grid_detalhamento of form_balcao
    
    dbselectarea('detalhamento_compras')
    detalhamento_compras->(ordsetfocus('id'))
    detalhamento_compras->(dbgotop())
    detalhamento_compras->(dbseek(x_chave))
    
    if found()
        while .T.
            add item {str(detalhamento_compras->qtd,6),acha_produto(detalhamento_compras->id_prod),trans(detalhamento_compras->subtotal,'@E 999,999.99')} to grid_detalhamento of form_balcao
            detalhamento_compras->(dbskip())
            if detalhamento_compras->id_cliente <> parametro
                exit
            endif
        end
    endif
    
    return(nil)



