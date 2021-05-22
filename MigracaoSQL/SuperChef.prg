/*
  sistema     : superchef pizzaria
  programa    : principal
  compilador  : xharbour 1.2
  lib gráfica : minigui extended
  programador : marcelo neves
*/

#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

#include 'super.ch'


function main()
    Local rs
    local aColors
    App.cargo := Hash()
    App.cargo["demonstracao"]     := TRUE
    App.cargo["limiteregistro"]   := 10
    App.cargo["datalimite"]       := ctod('01/02/2022')
    
    App.cargo["usuario"]           := hash()
    App.cargo["usuario"]["codigo"] := 0
    App.cargo["usuario"]["nome"]   := ""
    App.Cargo["usuario"]["acesso"] := Replicate("0",43)
    
    App.cargo["empresa"]:=hash()
    App.cargo["empresa"]["nome"]    := "CÓPIA DEMONSTRAÇÃO"
    App.cargo["empresa"]["telefone"]:= ""
    App.cargo["empresa"]["endereco"]:= ""
    App.cargo["empresa"]["bairro"]  := ""
    App.cargo["empresa"]["cidade"]  := ""
    App.cargo["empresa"]["cep"]     := ""
    App.cargo["empresa"]["numero_serie"]:="SCP-----------------"
    
    //Facilmente burlável...
    if date() > App.Cargo["datalimite"]
        MsgStop("Produto expirado em "+dtoc(App.cargo["datalimite"] ))
        Return .F.
    endif
    
    #include <superchef.ch>
    
    set browsesync on
    
    //Banco de dados
    Private Connection //Variáveis globais de conexão
    Connection := TadoConnection():New() //Cria o objeto ADO
    Connection:ConnectString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\Database.mdb;Persist Security Info=False' //String de Conexão
    if !Connection:Open() //Abre o banco de dados
        Return .F.
    Endif
    
    rs.new()
    rs.sql := "select * from  empresa"
    rs.Open()
    if rs.eof()
        MsgInfo("Empresa não licenciada!")
        return .F.
    endif
    App.cargo["empresa"]["nome"]    := rs.field.nome.value
    App.cargo["empresa"]["telefone"]:= rs.field.fixo_1.value
    App.cargo["empresa"]["endereco"]:= rs.field.endereco.value+","+rs.field.numero.value
    App.cargo["empresa"]["bairro"]  := rs.field.bairro.value
    App.cargo["empresa"]["cidade"]  := rs.field.cidade.value
    App.cargo["empresa"]["cep"]     := Transform(rs.field.cep.value,"@R 99999-999")
    App.cargo["empresa"]["web"]     := rs.field.site.value
    
    
    aColors := GetMenuColors()
    
    aColors[ MNUCLR_SEPARATOR1 ] := RGB( 128, 128, 128 ) //linha separadora
    aColors[ MNUCLR_IMAGEBACKGROUND1 ] := RGB( 236, 233, 216 ) //RGB( 226, 234, 247 ) //fundo bmp do ítem
    aColors[ MNUCLR_IMAGEBACKGROUND2 ] := RGB( 236, 233, 216 ) //RGB( 226, 234, 247 ) //fundo bmp do ítem
    aColors[ MNUCLR_MENUBARBACKGROUND1 ] := GetSysColor(15)
    aColors[ MNUCLR_MENUBARBACKGROUND2 ] := GetSysColor(15)
    aColors[ MNUCLR_MENUBARSELECTEDITEM1 ] := RGB( 198, 211, 239 ) //GetSysColor(15)
    aColors[ MNUCLR_MENUBARSELECTEDITEM2 ] := RGB( 198, 211, 239 ) //GetSysColor(15)
    aColors[ MNUCLR_MENUITEMSELECTEDTEXT ] := RGB( 000, 000, 000 )
    aColors[ MNUCLR_MENUITEMBACKGROUND1 ] := RGB( 255, 255, 255 ) //fundo geral menu
    aColors[ MNUCLR_MENUITEMBACKGROUND2 ] := RGB( 255, 255, 255 ) //fundo geral menu
    aColors[ MNUCLR_SELECTEDITEMBORDER1 ] := RGB( 049, 105, 198 ) //bordas do ítem
    aColors[ MNUCLR_SELECTEDITEMBORDER2 ] := RGB( 049, 105, 198 ) //bordas do ítem
    aColors[ MNUCLR_SELECTEDITEMBORDER3 ] := RGB( 049, 105, 198 ) //bordas do ítem
    aColors[ MNUCLR_SELECTEDITEMBORDER4 ] := RGB( 049, 105, 198 ) //bordas do ítem
    aColors[ MNUCLR_MENUITEMSELECTEDBACKGROUND1 ] := RGB( 198, 211, 239 ) //fundo ítem menu
    aColors[ MNUCLR_MENUITEMSELECTEDBACKGROUND2 ] := RGB( 198, 211, 239 ) //fundo ítem menu
    
    SetMenuColors( aColors )
    
    Load Window SuperChef_Main as form_main
        form_main.img_wallpaper.row    := 0
        form_main.img_wallpaper.col    := 0
        form_main.img_wallpaper.height := getdesktopheight()
        form_main.img_wallpaper.width  := getdesktopwidth()
        form_main.img_wallpaper.picture:= "wallpaper"
        //se não form demonstração
        if !App.cargo["demonstracao"]
            form_main.label_demo.visible := FALSE
        endif
        
        on key F10    OF form_main  action mostra_entregas()
        on key escape OF form_main  action form_main.release
    form_main.maximize
    form_main.activate
    
    return(nil)
    *-------------------------------------------------------------------------------
static function login()
    Load Window SuperChef_Login as form_login
        form_login.setfocus
        form_login.oUsuario.setfocus
    form_login.center
    form_login.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function confirma_entrada()
    Local rs.new()
    if form_login.oUsuario.value = 0 .or. empty(form_login.oSenha.value)
        MsgStop("Usuário ou senha Inválido ")
        return .F.
    endif
    rs.sql := "Select * from Operadores where codigo="+hb_ntos(form_login.oUsuario.cargo[form_login.oUsuario.value])
    rs.Open()
    if rs.eof()
        Return .F.
    endif
    if !rs.field.senha.value==form_login.oSenha.value
        MsgStop("Usuário ou senha Inválido ")
        return .F.
    endif
    App.Cargo["usuario"]["acesso"] := rs.field.acesso.value

    Form_Main.MnuFornecedores.Enabled            := Libera(06) //MENUITEM "Fornecedores" 
    Form_Main.MnuGrupoFornecedores.Enabled       := Libera(07) //MENUITEM "Grupo de Fornecedores" 
    Form_Main.MnuMateriaPrima.Enabled            := Libera(08) //MENUITEM "Matéria Prima"
    Form_Main.MnuCatprodutos.Enabled             := Libera(09) //MENUITEM "Categorias de Produtos"
    Form_Main.MnuSubCatProdutos.Enabled          := Libera(10) //MENUITEM "Sub-Categorias de Produtos" 
    Form_Main.MnuFormaRecebimento.Enabled        := Libera(11) //MENUITEM "Formas de Recebimento" 
    Form_Main.MnuFormaPagamento.Enabled          := Libera(12) //MENUITEM "Formas de Pagamento"   IMAGE "img_formas_pagamento"
    Form_Main.MnuUnidadesMedida.Enabled          := Libera(13) //MENUITEM "Unidades de Medida"  IMAGE "img_medidas"
    Form_Main.MnuContasBancarias.Enabled         := Libera(14) //MENUITEM "Contas Bancárias"   IMAGE "img_contas_bancarias"
    Form_Main.MnuImpostos.Enabled                := Libera(15) //MENUITEM "Impostos e Alíquotas"  IMAGE "img_impostos"
    Form_Main.MnuMesas.Enabled                   := Libera(16) //MENUITEM "Mesas da Pizzaria"   IMAGE "img_mesas"
    Form_Main.MnuAtendentes.Enabled              := Libera(17) //MENUITEM "Atendentes ou Garçons"  IMAGE "img_atendentes"
    Form_Main.MnuMotoboys.Enabled                := Libera(18) //MENUITEM "Motoboys ou Entregadores"  IMAGE "img_motoboys"
    Form_Main.MnuOperadores.Enabled              := Libera(19) //MENUITEM "Operadores do Programa"  IMAGE "img_operadores"
    Form_Main.MnuFechamentoDiario.Enabled        := Libera(20) //MENUITEM "Fechamento do dia de trabalho"  IMAGE "img_relatorios"
    Form_Main.MnuMovimentoCaixa.Enabled          := Libera(21) //MENUITEM "Movimentação do Caixa"  IMAGE "img_relatorios"
    Form_Main.MnuMovimentoBancario.Enabled       := Libera(22) //MENUITEM "Movimentação Bancária"  IMAGE "img_relatorios"
    Form_Main.MnuContasPagarPeriodo.Enabled      := Libera(23) //MENUITEM "Contas a Pagar por período"  IMAGE "img_relatorios"
    Form_Main.MnuContasPagarFornecedores.Enabled := Libera(24) //MENUITEM "Contas a Pagar por fornecedor"  IMAGE "img_relatorios"
    Form_Main.MnuContasReceberPeriodo.Enabled    := Libera(25) //MENUITEM "Contas a Receber por período"  IMAGE "img_relatorios"
    Form_Main.MnuContasReceberCliente.Enabled    := Libera(26) //MENUITEM "Contas a Receber por cliente"  IMAGE "img_relatorios"
    Form_Main.MnuPizzaMaisVendidas.Enabled       := Libera(27) //MENUITEM "Pizzas mais vendidas"   IMAGE "img_relatorios"
    Form_Main.MnuProdutosMaisVendidos.Enabled    := Libera(28) //MENUITEM "Produtos mais vendidos"  IMAGE "img_relatorios"
    Form_Main.MnuEstoqueMinimo.Enabled           := Libera(29) //MENUITEM "Relação estoque mínimo"   IMAGE "img_relatorios"
    Form_Main.MnuEstoqueProduto.Enabled          := Libera(30) //MENUITEM "Posição do estoque (produtos)"  IMAGE "img_relatorios"
    Form_Main.MnuEstoqueMateriaPrima.Enabled     := Libera(31) //MENUITEM "Posição do estoque (matéria prima)"  IMAGE "img_relatorios"
    Form_Main.MnuComissaoMotoboys.Enabled        := Libera(32) //MENUITEM "Comissão Motoboys/Entregadores"   IMAGE "img_relatorios"
    Form_Main.MnuComissaoAtendentes.Enabled      := Libera(33) //MENUITEM "Comissão Atendentes/Garçons"   IMAGE "img_relatorios"
    Form_Main.MnuMovCaixa.Enabled                := Libera(34) //MENUITEM "Movimentação do Caixa"  IMAGE "img_mov_caixa"
    Form_Main.MnuMovBancos.Enabled               := Libera(35) //MENUITEM "Movimentação Bancária"  IMAGE "img_mov_bancaria"
    Form_Main.MnuCompras.Enabled                 := Libera(36) //MENUITEM "Compras / Entrada Estoque"   IMAGE "img_compras"
    Form_Main.MnuContasaPagar.Enabled            := Libera(37) //MENUITEM "Contas a Pagar"   IMAGE "img_pagar_receber"
    Form_Main.MnuContasaReceber.Enabled          := Libera(38) //MENUITEM "Contas a Receber"   IMAGE "img_pagar_receber"
    Form_Main.MnuCadPizzaria.Enabled             := Libera(40) //MENUITEM "Cadastro da Pizzaria"  IMAGE "img_cadastro"
    Form_Main.MnuTamanhoPizzas.Enabled           := Libera(39) //MENUITEM "Tamanhos de Pizza"   IMAGE "img_tamanhos"
    Form_Main.MnuBordasPizza.Enabled             := .T. //Libera()   //MENUITEM "Bordas de Pizza"   IMAGE "img_borda"
    Form_Main.MnuConfiguraVenda.Enabled          := .T. //Libera()   //MENUITEM "Configurar Venda de Pizza"   IMAGE "img_prevda"
    Form_Main.MnuPromocoes.Enabled               := Libera(41) //  MENUITEM "Incluir ou Excluir Promoção"   IMAGE "img_promocoes"
    Form_Main.MnuPrecoes.Enabled                 := Libera(42) //  MENUITEM "Reajustar Preços de Produtos"  IMAGE "img_reajustar"
    Form_Main.MnuBackup.Enabled                  := Libera(43) //  MENUITEM "Backup do Banco de Dados"  IMAGE "img_backup"

    //Botoes do topo e Teclas de Atalho
    Form_Main.venda_delivery.enabled := Libera(1)
    on key F5 OF form_main  action IIF( libera(1),venda_delivery(),Nil)
    Form_Main.venda_mesas.enabled    := Libera(2)
    on key F6 OF form_main  action IIF( Libera(2),venda_mesas()   ,Nil)
    Form_Main.venda_balcao.enabled   := Libera(3)
    on key F7 OF form_main  action IIF( Libera(3),venda_balcao()  ,Nil)
    Form_Main.clientes.enabled       := Libera(4)
    on key F8 OF form_main  action IIF( Libera(4),clientes()      ,Nil)
    Form_Main.produtos.enabled       := Libera(5)
    on key F9 OF form_main  action IIF( Libera(5),produtos()      ,Nil)
    
    form_login.release
    show window form_main
    return(nil)
    *-------------------------------------------------------------------------------
static function libera(nItem)
    Return Substr(App.Cargo["usuario"]["acesso"] ,nItem,1) == "1"
    *-------------------------------------------------------------------------------


    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_login_oUsuario_Onlistdisplay( )
    Local rs.new()
    rs.sql := "select top 30 codigo,nome from operadores where nome like '"+form_login.oUsuario.displayvalue+"%' order by nome"
    rs.open()
    form_login.oUsuario.cargo:={}
    form_login.oUsuario.deleteallItems()
    While !rs.eof()
        form_login.oUsuario.addItem(rs.field.nome.value)
        AADD(form_login.oUsuario.cargo,rs.field.codigo.value)
        rs.moveNext()
    enddo
    Return .T.

    ***********************************************
    ///////////////////////////////////////////////
    ***********************************************
Static Function form_login_oUsuario_Onenter( )
    if form_login.oUsuario.value >0
        return TRUE
    Endif
    PostMessage(form_login.oUsuario.handle,(320+15),1,0)
    form_login.oUsuario.setfocus()       
    Return .T.
