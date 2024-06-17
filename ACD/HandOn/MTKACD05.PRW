#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTKACD05  บAutor  ณAnderson            บ Data ณ  24/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de Geracao de CB0 para nota de importacao            บฑฑ
ฑฑ           ณe transferencia entre filiais onde nao existe conferencia   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multi-Tek                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MTKACD05

cCadastro := "Geracao de CB0 NFe Importacao"

aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;
{ "Visualizar"   ,"AxVisual" , 0, 2},;
{ "Gerar CB0"    ,'ExecBlock("MTKGERCB0",.F.,.F.)', 0, 3} }


If SuperGetMV("MV_CONFFIS") == "S"
	
	aCores    := {{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. Empty(F1_STATUS)', 'ENABLE' },;	// NF Nao Classificada
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="N"'	 , 'DISABLE'},;		// NF Normal
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="P"'	 , 'BR_AZUL'},;		// NF de Compl. IPI
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="I"'	 , 'BR_MARRON'},;	// NF de Compl. ICMS
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="C"'	 , 'BR_PINK'},;		// NF de Compl. Preco/Frete
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="B"'	 , 'BR_CINZA'},;	// NF de Beneficiamento
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="D"'    , 'BR_AMARELO'},;	// NF de Devolucao
	{ 'F1_STATCON<>"1" .AND. !EMPTY(F1_STATCON)', 'BR_PRETO'}}
	
Else

	aCores    := {{ 'Empty(F1_STATUS)', 'ENABLE' },; // NF Nao Classificada
	{'F1_TIPO=="N"', 'DISABLE'   },; // NF Normal
	{'F1_TIPO=="P"', 'BR_AZUL'   },; // NF de Compl. IPI
	{'F1_TIPO=="I"', 'BR_MARRON' },;	 // NF de Compl. ICMS
	{'F1_TIPO=="C"', 'BR_PINK'   },;	 // NF de Compl. Preco/Frete
	{'F1_TIPO=="B"', 'BR_CINZA'  },;	 // NF de Beneficiamento
	{'F1_STATCON<>"1"', 'BR_PRETO'  },;	 // NF em Conferencia
	{'F1_TIPO=="D"', 'BR_AMARELO'} }	 // NF de Devolucao

EndIf

dbSelectArea("SF1")
dbSetOrder(1)

mBrowse(6,1,22,75,"SF1",,,,,,aCores)

Return()
                                                                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTKACD02  บAutor  ณAnderson            บ Data ณ  24/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma complementar ao MTKACD01 o qual ira verif.  se a NFบฑฑ
ฑฑบ          ณescolhida pode ter o status mudado ou nao qto. a conferenciaบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multi-Tek                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTKGERCB0
Local _nVolume := 0
Local _cCodEsp := ""
Local _cEspecie := ""
Local _nPesoBrt := 0
Local _cEspecie := ""


//
// E uma nota de Exportacao que por algum motivo gerou etiqueta sem estar conferida temos que deletar esta etiqueta.
//
//If !Empty(SF1->F1_HAWB) .AND.  SF1->F1_STATCON<> "1"
//   DBSelectArea("CB0")
//   DBSetOrder(6)
//   If Dbseek(xFilial("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
//   	  While !EOF() .and.  xFilial("CB0")+(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA) = CB0->(CB0_FILIAL+CB0_NFENT+CB0_SERIEE+CB0_FORNEC+CB0_LOJAFO)
//         	    //xFilial("CB0") == CB0->CB0_FILIAL .and. SF1->F1_DOC ==  CB0->CB0_NFENT .and. SF1->F1_SERIE == CB0->CB0_SERIEE .and. SF1->F1_FORNECE == CB0->CB0_FORNEC .and. SF1->F1_LOJA == CB0->CB0_LOJAFO 
//				RECLOCK("CB0",.F.)
//				DbDelete()
//				MsUnlock()
//				CB0->(DbSkip())
//     Enddo
//   Endif
//Endif

DbSelectArea("SA2") 
DbSetorder(1)
Dbseek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)

	
If !Empty(SF1->F1_HAWB) .OR. "49093834" $ SA2->A2_CGC

    DBSelectArea("CB0")
    DBSetOrder(6)
    If Dbseek(xFilial("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	   Aviso("ATENCAO", "As etiquetas para esta NFe "+SF1->F1_DOC+" ja foram geradas. "+chr(13)+;
	         "Caso nao tenha impressa pode utilizar a rotina  de Impressใo Etq Cb0 ",{"&Ok"})
       Return
    Endif
	
	
	DbSelectArea("SD1")
	DbSetOrder(1)
	If Dbseek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		
		While !EOF() .AND. xFilial("SD1") == SD1->D1_FILIAL .AND. SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
			
			//Gerando as etiquetas no CB0 para a NF do SIGAEIC
			
			//Verifica se o produto nao eh Granel
			If !CBProdUnit(SD1->D1_COD)
				
				//Gera somente uma etiqueta do produto a granel com a quantidade movimentada.
				CBGrvEti('01',{SD1->D1_COD,SD1->D1_QUANT,NIL,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_HAWB,NIL,SD1->D1_LOCAL,NIL,SD1->D1_NUMSEQ,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL})
				
			Else
				
				//Gera o numero de etiquetas necessarias
				For _n := 1 to SD1->D1_QUANT
					CBGrvEti('01',{SD1->D1_COD,1,NIL,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_HAWB,NIL,SD1->D1_LOCAL,NIL,SD1->D1_NUMSEQ,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL})
				Next
				
			EndIf
			
			DbSelectArea("SD1")
			DbSkip()
			
		EndDo

        If !Empty(SF1->F1_HAWB)
           Aviso("ATENCAO", "Gerada Etiquetas para NFE de Importacao...",{"&Ok"})
		Else
           Aviso("ATENCAO", "Gerada Etiquetas para NFE de Transferencia...",{"&Ok"})
		Endif
	EndIf

Else


   Aviso("ATENCAO", "Rotina apenas utilizada para NFE de Importacao ou Transferencia de Filiais...",{"&Ok"})

	
EndIf

Return

