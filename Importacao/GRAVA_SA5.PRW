#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GRAVA_SA5 ³ Autor ³ Marcelo               ³ Data ³ 22-08-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Importacao SA5 - Cliente x Produto                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GRAVA_S5()

Aviso("Importacao de projetos","Atencao! Certifique-se de que o arquivo foi gerado com este formato EVENTOS - CSV (MS-DOS)  e que as configuracoes regionais do windows utilizam '.' para decimais." ,{"Ok"})

Processa({||A001Import()},"Importando CSV. Aguarde...")


Return



Static Function A001Import()

Local nx := 0

Local cCodEDT
Local cCodTrf
Local _dData:=cTod("31/12/12")


Private cCadastro   := "Ajustando Saldos Iniciais com base no  "
Private aTxt        := {}
Private aRet        := {}


Private aSB1 := {}
//Private nSB1_X_CDNEW  := 0
Private nSB1_X_CDDAY  := 0
Private nSB1_X_CDIBE  := 0

Private aImport := {}
Private aRotina 	:= {	{ "", "AxPesqui"  , 0 , 1},;
{ "","PMS200Dlg", 0 , 2},;
{ "",   "PMS200Dlg", 0 , 3},;
{ "",   "PMS200Alt", 0 , 4},;
{ "",   "PMS200Dlg", 0 , 4} }

Inclui   := .T.
Altera   := .F.
lRefresh := .T.



If ParamBox({	{6,"Arquivo",SPACE(50),"","FILE(mv_par01)","", 55 ,.T.,"Arquivo .CSV |*.CSV"}},;
	"Atualizar Projeto",@aRet,,)
	//{1,"Importar .CSV",SPACE(10),"","dbSeek(xFilial('AF8')+AllTrim(mv_par03))","AF8","", 45 ,.F.},;
	//{3,"Versao do Project",1 ,{"Portugues","Ingles"},70,,.F.},;
	
	If (nHandle := FT_FUse(AllTrim(aRet[1])))== -1
		Help(" ",1,"NOFILEIMPOR")
		Return
	EndIf
	
	
	FT_FGOTOP()
	While !FT_FEOF()
		PmsIncProc(.T.)
		cLinha := FT_FREADLN()
		AADD(aTxt,{})
		nCampo := 1
		While At(";",cLinha)>0
			aAdd(aTxt[Len(aTxt)],Substr(cLinha,1,At(";",cLinha)-1))
			nCampo ++
			cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
		Enddo
		If Len(AllTrim(cLinha)) > 0
			aAdd(aTxt[Len(aTxt)],StrTran(Substr(cLinha,1,Len(cLinha)),'"','') )
		Else
			aAdd(aTxt[Len(aTxt)],"")
		Endif
		FT_FSKIP()
	Enddo
	FT_FUSE()
	
	
	For nX := 2 to Len(aTxt)
		
		xFilial  := strzero(val(aTxt[nX][01]),02) // A5_FILIAL
		cFornece := strzero(val(aTxt[nX][02]),06) // A5_FORNECE
		cLoja    := strzero(val(aTxt[nX][03]),02) // A5_LOJA
		cProduto := strzero(val(aTxt[nX][04]),06) // A5_PRODUTO
		cCodPRF  := alltrim(aTxt[nX][05])         // A5_CODPRF
		cCliMtk  := strzero(val(aTxt[nX][06]),6)  // A5_XCLIMTK
		cPreMtk  := troca(aTxt[nX][07])           // A5_XPREMTK
		                                          
		
		cDescProd:= ""                             // A5_NOMPROD
		
		PmsIncProc(.T.)
		
		DbSelectArea("SA2")
		DbSetORder(1)
		If Dbseek(xFilial+cFornece+cLoja)
		   cDescProd:= SB1->B1_DESC                // A5_NOMPROD
		   lRet	:= .t.
		Else
           Aviso("ATENCAO", "Linha "+ strzero(nX,3) + " Filial+Fornecedor+Loja nao encontrado. ( "+xFilial+cFornece+cLoja+" )", {"&Ok"})
		   lRet	:= .f.
		   Exit
		Endif

        If lRet
			DbSelectArea("SB1")
			DbSetORder(1)
			If Dbseek(xFilial("SB1")+cProduto)
			   cDescProd:= SB1->B1_DESC                // A5_NOMPROD
			   lRet	:= .t.
			Else
    	   	    Aviso("ATENCAO", "Linha "+ strzero(nX,3) + " Filial+Produto Nao encontrado. ( "+xFilial+cProduto+" )", {"&Ok"})
			   lRet	:= .f.
			   Exit
		    Endif
	    Endif   

		If Alltrim(xFilial) <> Alltrim(xFilial("SA5"))
   	   	   Aviso("ATENCAO", "Linha "+ strzero(nX,3) + " A Filial corrente diferente da Filial da Planilha...", {"&Ok"})
		   lRet	:= .f.
		   Exit
		Endif
		   
		If lRet   
			DbSelectArea("SA5")
    		DbOrderNickname("CLIFOR02")  //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_FABR+A5_FALOJA+A5_REFGRD                                                                                                                                                                                       
			If Dbseek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+SB1->B1_COD+cCliMtk)
				Reclock("SA5",.F.)
				SA5->A5_CODPRF  := cCodPRF         // A5_CODPRF
		        SA5->A5_XCLIMTK := cCliMtk  
		        SA5->A5_FABR    := cCliMtk         // A5_PRODUTO
		        SA5->A5_XPREMTK := cPreMtk
				MsUnlock()
			Else
				Reclock("SA5",.T.)
				SA5->A5_FILIAL  := xFilial("SA5")   // A5_FILIAL
				SA5->A5_FORNECE := cFornece         // A5_FORNECE
				SA5->A5_LOJA    := cLoja            // A5_LOJA
				SA5->A5_PRODUTO := cProduto         // A5_PRODUTO
		        SA5->A5_FABR    := cCliMtk          // A5_PRODUTO

				SA5->A5_NOMEFOR := SA2->A2_NOME
				SA5->A5_CODPRF  := cCodPRF   // A5_CODPRF
				SA5->A5_NOMPROD := cDescProd // A5_NOMPROD
		        SA5->A5_XCLIMTK := cCliMtk  
		        SA5->A5_XPREMTK := cPreMtk
				MsUnlock()
			Endif
		Endif
		
	Next nX
	
EndIf



Return



Static Function Troca(cCampo)
Local nCampo := 0

cCampo := StrTran(cCampo,".","")

cCampo := StrTran(cCampo,",",".")

nCampo := Val(cCampo)

Return(nCampo)
                                           


