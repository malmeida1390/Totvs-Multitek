#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GRAVA_SA7 ³ Autor ³ Marcelo               ³ Data ³ 22-08-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Importacao SA5 - Cliente  x Produto                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GRAVA_S7()

Aviso("Importacao de projetos","Atencao! Certifique-se de que o arquivo foi gerado com este formato EVENTOS - CSV (MS-DOS)  e que as configuracoes regionais do windows utilizam '.' para decimais.",{"Ok"})

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
		cCliente := strzero(val(aTxt[nX][02]),06) // A5_CLIENTE
		cLoja    := strzero(val(aTxt[nX][03]),02) // A5_LOJA
		cProduto := strzero(val(aTxt[nX][04]),06) // A5_PRODUTO
		cCodCli  := alltrim(aTxt[nX][05]) // A5_CODCLI
		
		
		PmsIncProc(.T.)
		
		DbSelectArea("SA1")
		DbSetORder(1)
		If Dbseek(xFilial+cCliente+cLoja)
		   lRet	:= .t.
		Else
           Aviso("ATENCAO", "Linha "+ strzero(nX,3) + " Filial+Clente+Loja nao encontrado. ( "+xFilial+cCliente+cLoja+" )", {"&Ok"})
		   lRet	:= .f.
		   EXIT
		Endif

 
        If lRet
			DbSelectArea("SB1")
			DbSetORder(1)
			If Dbseek(xFilial("SB1")+cProduto)
			   lRet	:= .t.
			Else
       		   Aviso("ATENCAO", "Linha "+ strzero(nX,3) + " Filial+Produto Nao encontrado. ( "+xFilial+cProduto+" )", {"&Ok"})
			   lRet	:= .f.
			   EXIT
			Endif
		Endif   
		   
		If lRet   
			
			DbSelectArea("SA7")
			DbSetORder(1)
			If Dbseek(xFilial+cCliente+cLoja+cProduto)
				Reclock("SA7",.F.)
				SA7->A7_CODCLI  := cCodCli   // A7_cCodCli
				MsUnlock()
			Else
				Reclock("SA7",.T.)
				SA7->A7_FILIAL  := xFilial   // A7_FILIAL
				SA7->A7_CLIENTE := cCliente  // A7_CLIENTE
				SA7->A7_LOJA    := cLoja     // A7_LOJA
				SA7->A7_PRODUTO := cProduto  // A7_PRODUTO
				SA7->A7_CODCLI  := cCodCli   // A7_CODCLI
				MsUnlock()
			Endif
			
		Endif
		
	Next nX
	
EndIf



Return



