/*
  sistema     : superchef pizzaria
  programa    : movimentação do caixa
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
    Última alteração : 12/05/2021-12:03:38 Máquina: IMA2018 Usuário:ivani
    Código do formulário ajustado
    ----------------------------------------------------------------------------------------------
    Projeto : SuperChefSQL
    */
    
#include <hmg.ch>
#include <SQLAdo.ch>
Declare Cursor SQLADO rs
memvar Rs

function caixa()
    Local aHeader:={'Código','Data','Histórico','Entradas','Saídas'}
    Private Rs:=Rs.New()
    Load Window form_pesquisa as form_caixa
        form_caixa.title:="Movimentação do Caixa"
        form_caixa.tbox_pesquisa.release
        form_caixa.button_imprimir.release        
        form_caixa.rodape_001.value     := "Escolha o período"
        form_caixa.rodape_002.value     := "até"
        form_caixa.rodape_002.col       := 250
        form_caixa.button_atualizar.col := 311
        form_caixa.button_sair.col      := 413
        
        
        DEFINE DATEPICKER dp_inicio
            parent form_caixa
            COL 140
            FONTNAME "verdana"
            FONTSIZE 10
            HEIGHT 24
            ROW 540
            VALUE date()
            WIDTH 100
        END DATEPICKER

        DEFINE DATEPICKER dp_final
            parent form_caixa
            COL 280
            FONTNAME "verdana"
            FONTSIZE 10
            HEIGHT 24
            ROW 540
            VALUE date()
            WIDTH 100
        END DATEPICKER
        DEFINE BUTTONEX botao_filtrar
            parent form_caixa
            ACTION (atualizar())
            CAPTION "Filtrar"
            COL 390
            FONTBOLD TRUE
            HEIGHT 30
            ROW 540
            TOOLTIP "Clique aqui para mostrar as informações com base no período selecionado"
            WIDTH 100
        END BUTTONEX
    
        DEFINE LABEL rodape_003
            parent form_caixa
            AUTOSIZE TRUE
            COL 530
            FONTBOLD TRUE
            FONTCOLOR { 0 , 89 , 45 }
            FONTNAME "verdana"
            FONTSIZE 10
            HEIGHT 24
            ROW 545
            TRANSPARENT TRUE
            VALUE "DUPLO CLIQUE : Alterar informação"
            WIDTH 120
        END LABEL        
        on key F5      of form_caixa action dados(1)
        on key F6      of form_caixa  action dados(2)
        on key F7      of form_caixa  action excluir()
        on key escape  of form_caixa action thiswindow.release
        
    form_caixa.center
    form_caixa.activate
    return(nil)
    *-------------------------------------------------------------------------------
static function dados(parametro)
    local cId := Form_Caixa.Grid_Pesquisa.Item(Form_Caixa.Grid_Pesquisa.value)[1]
    Load Window caixa_form_dados as form_dados
        form_dados.title := IIF(parametro=1,"Incluir","Alterar")
        if parametro=2
            Rs.SQL:="Select * from caixa where codigo="+cId
            Rs.Open()
            if !Rs.ErrorSQL().and.!Rs.Eof()
                form_dados.tbox_001.value := Rs.Field.dtMovimento.value
                form_dados.tbox_002.value := Rs.Field.historico.value
                form_dados.tbox_003.value := Rs.Field.entrada.value
                form_dados.tbox_004.value := Rs.Field.saida.value
            endif    
        else
            rs.sql:="select * from caixa where 1=2"
            rs.Open()
            form_dados.tbox_001.value := Date()
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
    local cId :=Form_caixa.Grid_Pesquisa.Item(Form_caixa.Grid_Pesquisa.value)[1]
    if val(cId)=0
        Return .F.
    endif
    if !msgYesNo("Historico :"+Form_caixa.Grid_Pesquisa.Item(Form_caixa.Grid_Pesquisa.value)[3],"Excluir")
        Return .F.
    endif
    Rs.Execute("Delete from caixa where codigo="+cId)
    if Rs.ErrorSQL()
        Return .F.
    endif
    atualizar()
    return(nil)    
    *-------------------------------------------------------------------------------
static function gravar(parametro)
    
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
    *-------------------------------------------------------------------------------
static function atualizar()
    form_caixa.grid_Pesquisa.disableupdate
    delete item all from grid_Pesquisa of form_caixa
    Rs.SQL:="Select * from caixa where dtMovimento>="+Rs:DataSQL(form_caixa.dp_inicio.value)+" and dtMovimento<="+Rs:DataSQL(form_caixa.dp_final.value)+" order by dtMovimento,codigo"
    Rs.Open()
    if Rs.ErrorSQL()
        Return .F.
    Endif
    while !Rs.Eof()
        add item {str(Rs.Field.codigo.value,10),;
                  dtoc(Rs.Field.dtMovimento.value),;
                  Rs.Field.historico.value,;
                  trans(Rs.Field.entrada.value,'@E 999,999.99'),;
                  trans(Rs.Field.saida.value,'@E 999,999.99')} to Grid_Pesquisa of form_caixa
        Rs.MoveNext()
    end
    form_caixa.Grid_Pesquisa.ColumnsAutoFit()
    form_caixa.Grid_Pesquisa.ColumnsAutoFitH()    
    form_caixa.Grid_Pesquisa.enableupdate
    return(nil)
    *-------------------------------------------------------------------------------
static function relacao()
    Return Nil
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
