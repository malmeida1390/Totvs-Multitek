#include "rwmake.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MFATC15  ³ Autor ³                       ³ Data ³ 19/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida se pode ser utilizado o Tes.                        ³±±
±±³          ³                                                            ³±±
±±³          ³ Segundo  informado a inclusao de pedidos Normais fora      ³±±
±±³          ³ do simulador somente pode ocorrer quando utilizamos        ³±±
±±³          ³ um TES que nao gere duplitadas.   Mas existe excessoes.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Multitek                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATC15(cTes)

Local aGetArea := GetArea()           
Local cNome    :=  Upper(Funname())
Local cDupl    := GetAdvFval("SF4","F4_DUPLIC",xFilial("SF4") + cTes , 1)
Local lRet     := .T.
Local lContinue:= .T.
                   
Local nProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})

If "MATA415" $ Upper(Funname()) // Defido trabalhar com Temporario.
	Return (lRet)
Endif


//
//  Este For tem como objetivo indentificar se esta sendo criado um PV para Ativo Imobilizado
//  pois neste caso nao e necessario consistir a TES.
//
For nY:= 1 to len(Acols)

    IF !aCols[nY][Len(aHeader)+1] 
                                  
       if substr(aCols[nY][nProduto],1,2) $ "AF|MC"
          lContinue:=.F.
       Endif  
    
    Endif

Next
          
//ALTERADO NASSER 21-06-2007 --NF -- FAG
//If "MATA410" $ cNome .and. cDupl = "S" .and. M->C5_TIPO = "N" .and. M->C5_MOEDA = 1 .and. lContinue
//   
//	Aviso("ATENCAO", "Nao sera possivel utilizar este TES com o Tipo de Pedido NORMAL pois o mesmo gera Duplicata. "+;
//	                 "Caso deseje efetuar esta operacao utilize o Orcamento para gerar o Pedido.",{"&Ok"})
//
//   lRet := .F.
//   
//Endif


If Alltrim(SA1->A1_X_ALMOX) $ "03|02" .AND. cTes # "516"  // SE DESTINO DEPOSITO FECHADO 

	Aviso("ATENCAO", "O envio de Mercadoria para o Deposito Fechado somente e possivel utilizando a TES 516.",{"&Ok"})

   lRet := .F.
   
Endif

RestArea(aGetArea)

Return (lRet)
    


