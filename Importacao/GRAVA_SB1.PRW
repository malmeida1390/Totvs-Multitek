#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GRAVA_SB1 ³ Autor ³ Marcelo               ³ Data ³ 22-08-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de importacao de projetos no AF8 atraves de arquivo ³±±
±±³          ³ texto.                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GRAVA2SB1()

Aviso("Importacao de projetos","Atencao! Certifique-se de que o arquivo foi gerado com este formato EVENTOS - CSV (MS-DOS)  e que as configuracoes regionais do windows utilizam '.' para decimais.",{"Ok"})

// Fase I   - Atualizacao do SB1
// Fase II  - Compartilhar o SB1
// Fase III - Com SB1 atualizado atualizado apenas atualizo o Cadastro de Produtos.
//              Rodando na Daynatec pois ja estara tambem compartilhado.

Processa({||A001Import()},"Importando CSV. Aguarde...")


Return



Static Function A001Import()

Local nx := 0

Local cCodEDT
Local cCodTrf


Private cCadastro   := "Importar arquivo .CSV de SB1"
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
	
	
	//
	// Estrutura dos campos no Banco sera usado para predefinir a estrutura do Array Import
	//
	AADD(aSB1,{"B1_X_CDDAY"})
	AADD(aSB1,{"B1_X_CDIBE"})
	AADD(aSB1,{"B1_X_CDNEW"})
	
	nSB1_X_CDDAY  := aScan(aSB1,{|x| AllTrim(x[1])=="B1_X_CDDAY"})
	nSB1_X_CDIBE  := aScan(aSB1,{|x| AllTrim(x[1])=="B1_X_CDIBE"})
	nSB1_X_CDNEW  := aScan(aSB1,{|x| AllTrim(x[1])=="B1_X_CDNEW"})
	
	
	For nX := 2 to Len(aTxt)
		
		PmsIncProc(.T.)
		
		aadd(aImport,Array(Len(aSB1)))
		
		aImport[Len(aImport)][nSB1_X_CDDAY] := strzero(val(aTxt[nX][1]),6) // Cod Dynatch.
		//aImport[Len(aImport)][nSB1_X_CDIBE] := aTxt[nX][3] 
		aImport[Len(aImport)][nSB1_X_CDIBE] := aTxt[nX][6]// peso
		
	Next nX
	
EndIf


//
// Grava SB1
//
/*
DbselectArea("SB1")
DbGotop()
While !SB1->(EOF())

   	  Reclock("SB1",.F.)
	  SB1->B1_X_CDIBE  := ""
	  MsUnlock()
//
//	  SB1->(DBSKIP())
//
//Enddo
*/


/*
DbSelectArea("SB1")
DbGotop()
While !SB1->(EOF())
	
	
	If !Empty(SB1->B1_X_CDIBE)
		nPos := aScan(aImport,{|x| AllTrim(x[1])==Alltrim(SB1->B1_X_CDIBE)})
		
		If nPos # 0
			Reclock("SB1",.F.) 
		    SB1->B1_PAUTFET:= 1
			//SB1->B1_X_CDIB2:= STRZERO(VAL(aImport[nPos][nSB1_X_CDIBE]),6)+STRZERO(VAL(aImport[nPos][nSB1_X_CDNEW]),2)
			MsUnlock()
		Endif
	Endif
	
	SB1->(dBSKIP())
Enddo
*/
/*
/*
For nY:= 2 to Len(aImport)
	
	cCodDay := ALLTRIM(aImport[nY][nSB1_X_CDDAY])

	
	DbselectArea("SB1")
	DbSetorder(1)
	If DBSEEK(xFilial("SB1")+cCodDay)
		Reclock("SB1",.F.)
		    SB1->B1_PAUTFET:= 1
		//SB1->B1_X_CDIBE  := STRZERO(VAL(aImport[nY][nSB1_X_CDIBE]),6)+STRZERO(VAL(aImport[nY][nSB1_X_CDNEW]),2)
		MsUnlock()
	Endif
	
Next
*/



// Importando o Novo codigo da Dynatec.
DbSelectArea("SB9")
DbGotop()
While !SB9->(EOF())
	
//	If  Empty(SB1->B1_QE)
		nPos := aScan(aImport,{|x| AllTrim(x[1])==Alltrim(SB1->B1_COD)})
		
		If nPos # 0
			Reclock("SB1",.F.) 
			SB1->B1_PESO := val(aImport[nPos][nSB1_X_CDIBE])
			//STRZERO(VAL(aImport[nPos][nSB1_X_CDIBE]),6)+STRZERO(VAL(aImport[nPos][nSB1_X_CDNEW]),2)
			MsUnlock()
		Endif
//	Endif
	
	SB1->(dBSKIP())

Enddo




Return



