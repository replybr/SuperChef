/*
  sistema     : superchef pizzaria
  programa    : funções genéricas
  compilador  : xharbour 1.2 simplex
  lib gráfica : minigui 1.7 extended
  programador : marcelo neves
*/

#include <hmg.ch>

//Add
******************************************************
Declare window &(cName)
function MontaGrid(aHeader,bFunc)
   Local cCaption,nColIndex,cName:=ThisWindow.Name
   For nColIndex=0 to &(cName).Grid_Pesquisa.ColumnCount 
      &(cName).Grid_Pesquisa.DeleteColumn(nColIndex)
   Next
   nColIndex:=0
   For each cCaption in aHeader
      nColIndex++
      &(cName).Grid_Pesquisa.AddColumn(nColIndex,cCaption,10,0)
   Next
   if valtype(bFunc)="B"
      Eval(bFunc)
   endif
   Return .T.
*________________________________________________________________________________________________
function check_window()

         local largura := getdesktopwidth()
         local altura  := getdesktopheight()
         local ret

         if largura < 1000 .and. altura < 750
            msgstop('Este programa é melhor visualizado e operado com a resolução de vídeo 1024 x 768','Atenção')
            ret := .F.
         elseif largura > 1030 .and. altura > 780
            msgstop('Este programa é melhor visualizado e operado com a resolução de vídeo 1024 x 768','Atenção')
            ret := .F.
         else
            ret := .T.
         endif

         return(ret)
*________________________________________________________________________________________________
function LOCK_REG()
Return NIl
function VALOR_COLUNA() //' referenced from E:\PRGPLUS\GIT\SUPERCHEF\MIGRACAOSQL\OBJ\ENTREGAS.OBJ
Return NIl
function ACHA_FORNECEDOR() //' referenced from E:\PRGPLUS\GIT\SUPERCHEF\MIGRACAOSQL\OBJ\REL_CPAG_FORN.OBJ
Return NIl
function ACHA_FORMA_PAGAMENTO() //' referenced from E:\PRGPLUS\GIT\SUPERCHEF\MIGRACAOSQL\OBJ\REL_CPAG_FORN.OBJ
Return NIl
Function ACHA_CLIENTE() //' referenced from E:\PRGPLUS\GIT\SUPERCHEF\MIGRACAOSQL\OBJ\REL_CREC_CLI.OBJ
Return NIl
Function ACHA_FORMA_RECEBIMENTO() //' referenced from E:\PRGPLUS\GIT\SUPERCHEF\MIGRACAOSQL\OBJ\REL_CREC_CLI.OBJ
Return NIl
Function ACHA_PRODUTO() //' referenced from E:\PRGPLUS\GIT\SUPERCHEF\MIGRACAOSQL\OBJ\REL_FECHAMENTO_DIA.OBJ
Return NIl
Function ACHA_MOTOBOY() //' referenced from E:\PRGPLUS\GIT\SUPERCHEF\MIGRACAOSQL\OBJ\REL_FECHAMENTO_DIA.OBJ
Return NIl
Function ACHA_ATENDENTE() //' referenced from E:\PRGPLUS\GIT\SUPERCHEF\MIGRACAOSQL\OBJ\REL_FECHAMENTO_DIA.OBJ
Return NIl
Function ACHA_BANCO() //' referenced from E:\PRGPLUS\GIT\SUPERCHEF\MIGRACAOSQL\OBJ\REL_MOV_BANCO.OBJ
Return NIl
Function ACHA_UNIDADE() //' referenced from E:\PRGPLUS\GIT\SUPERCHEF\MIGRACAOSQL\OBJ\REL_POSICAO_MPRIMA.OBJ 
Return NIl
