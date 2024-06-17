/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ IMPETIHOF³ Autor ³ Anderson Rodrigues    ³ Data ³ 17/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao de etiquetas de produto baseado na tabela SBF    ³±±
±±³          ³	conforme os parametros informados pelo usuario             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Hofmann do Brasil                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function IMPETIHF()

If IsTelNet()
   IMPETISBF()
Else
   Processa({||IMPETISBF()})
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³IMPETISBF ³ Autor ³ Anderson Rodrigues    ³ Data ³ 17/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Execucao da  Funcao Chamada pelo programa IMPETIHOF		     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPETISBF
Local   nQtde,nQE
Local   cPerg := If(IsTelNet(),'VTPERGUNTE','PERGUNTE')
Private cEndSBF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Produto de                                   ³
//³ mv_par02     // Produto ate                                  ³
//³ mv_par03     // Armazem de                                   ³
//³ mv_par04     // Endereco de                                  ³
//³ mv_par05     // Armazem Ate                                  ³
//³ mv_par06     // Endereco Ate                                 ³
//³ mv_par07     // Local de Impressao                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AjustaSX1()
IF ! &(cPerg)("IMPETI",.T.)
   Return
EndIF
If IsTelNet()
   VtMsg('Imprimindo') 
EndIF

If ! CB5SetImp(MV_PAR07,IsTelNet())
	IF ! IsTelNet()
		MSGAlert('Codigo do tipo de impressao invalido')   
	Else
		VTAlert('Codigo do tipo de impressao invalido')           
	EndIf
	Return .f.
EndIF

SBF->(DbSetOrder(2))
SBF->(DbSeek(xFilial("SBF")+MV_PAR01+MV_PAR03,.t.))
While ! SBF->(Eof()).and. SBF->BF_PRODUTO >= MV_PAR01 .and. SBF->BF_PRODUTO <= MV_PAR02 
   If SBF->BF_LOCAL < MV_PAR03 .or. SBF->BF_LOCAL > MV_PAR05 
      SBF->(DbSkip())	
      Loop
   Endif   
	If SBF->BF_LOCALIZ < MV_PAR04 .or. SBF->BF_LOCALIZ > MV_PAR06 
	   SBF->(DbSkip())	 
	   Loop
	Endif
	If CBProdUnit(SBF->BF_PRODUTO)  	
	   If CBQtdVar(SBF->BF_PRODUTO)  	
	      nQtde := 1
	      nQE   := SBF->BF_QUANT
	   Else
	      nQE   := IF(Empty(SB1->B1_QE),1,SB1->B1_QE)
	      nQtde := SBF->BF_QUANT/nQE	   
	   Endif   
	Else
	   nQtde := 1
	   nQE   := SBF->BF_QUANT
	EndIf
	If ! CBImpEti(SBF->BF_PRODUTO)  	
	   SBF->(DbSkip())
	   Loop
	EndIf 
   SB1->(DbSetOrder(1))
   If SB1->(DbSeek(xFilial("SB1")+SBF->BF_PRODUTO))
	   cEndSBF:= SBF->BF_LOCALIZ 
	   If ExistBlock('IMG01')
	      ExecBlock('IMG01',,,{nQE,NIL,NIL,nQtde,NIL,NIL,NIL,NIL,SBF->BF_LOCAL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,SBF->BF_LOCALIZ})
	   EndIf
	Endif   
	SBF->(DbSkip())	
Enddo      	
If ExistBlock('IMG00')
   ExecBlock('IMG00',,,{"U_IMPETIHF",MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06})
EndIf
MSCBCLOSEPRINTER()   
Return
	   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³ Anderson Rodrigues   ³Data³ 17/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Cria o grupo de perguntas no SX1 caso o mesmo nao exista   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()
Local cAlias := Alias()
Local aRegistros:={}
Local i,j:=0

aadd(aRegistros,{"IMPETI","01","Produto de          ","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aadd(aRegistros,{"IMPETI","02","Produto ate         ","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aadd(aRegistros,{"IMPETI","03","Armazem de          ","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})
aadd(aRegistros,{"IMPETI","04","Endereco de        ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SBE",""})
aadd(aRegistros,{"IMPETI","05","Armazem ate         ","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})
aadd(aRegistros,{"IMPETI","06","Endereco ate       ?","","","mv_ch6","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SBE",""})
aadd(aRegistros,{"IMPETI","07","Local de Impressao ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CB5",""})

DbSelectArea("SX1")
For i:=1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next j
		MsUnlock()
	EndIf
Next I
dbSelectArea(cAlias)
Return