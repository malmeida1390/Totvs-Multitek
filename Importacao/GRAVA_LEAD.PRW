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
User Function GRAVA_LEAD()

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
Private cQuery := ""

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
	AADD(aSB1,{"SIMIL"})
	AADD(aSB1,{"EIS"})
	AADD(aSB1,{"LEADTIME"})

	nSIMIL := aScan(aSB1,{|x| AllTrim(x[1])==Alltrim("SIMIL")})
	nEIS   := aScan(aSB1,{|x| AllTrim(x[1])==Alltrim("EIS")})
    nLead  := aScan(aSB1,{|x| AllTrim(x[1])==Alltrim("LEADTIME")})
	
	
	For nX := 1 to Len(aTxt)
		
		PmsIncProc(.T.)
		
		If !Empty(aTxt[nX][1])
			aadd(aImport,Array(Len(aSB1)))
		
			aImport[Len(aImport)][nSIMIL] := aTxt[nX][1]       // SImil
			aImport[Len(aImport)][nEis]   := aTxt[nX][2]       // EIs
			aImport[Len(aImport)][nLead]  := aTxt[nX][3] //Lead Time
		Endif
		
	Next nX
	
EndIf


For nPos:= 1 to len(aImport)

		//cQuery := ""
		//cQuery := "SELECT SB1.* "
		//cQuery += "FROM "
		//cQuery += RetSqlName("SB1") + " SB1 "
		//cQuery += "WHERE "
		//cQuery += "SB1.B1_FILIAL= '" + xFilial("SB1") + "' AND "
		//cQuery += "SB1.B1_X_SIMIL = '" + aImport[nPos][nSimil] +"' AND "
        //cQuery += "'SB1.B1_X_SIMIL||SB1.B1_X_EIS01||SB1.B1_X_EIS02||SB1.B1_X_EIS03||SB1.B1_X_EIS04||SB1.B1_X_EIS05||SB1.B1_X_EIS06||SB1.B1_X_EIS07||B1_X_EIS08||SB1.B1_X_EIS09||SB1.B1_X_EIS10' = '" + aImport[nPos][nEis]+"' AND "
		//cQuery += "SB1.D_E_L_E_T_ <> '*' "
		//cQuery := ChangeQuery(cQuery)
		                    
	
		//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
		//For nX := 1 To Len(aStruSB1)
		//	If ( aStruSB1[nX][2] <> "C" )
		//		TcSetField(cAliasSB1,aStruSB1[nX][1],aStruSB1[nX][2],aStruSB1[nX][3],aStruSB1[nX][4])     
		//	EndIf
		//Next nX

		cQuery := " UPDATE "
		cQuery += RetSqlName("SB1") + " "
		cQuery += " SET B1_X_LT = "+aImport[nPos][nLead]+" "
		cQuery += "WHERE "
		cQuery += "B1_FILIAL= '" + xFilial("SB1") + "' AND "
		cQuery += "B1_X_SIMIL = '" + aImport[nPos][nSimil] +"' AND "
        cQuery += "B1_X_SIMIL||B1_X_EIS01||B1_X_EIS02||B1_X_EIS03||B1_X_EIS04||B1_X_EIS05||B1_X_EIS06||B1_X_EIS07||B1_X_EIS08||B1_X_EIS09||B1_X_EIS10 = '" + aImport[nPos][nEis]+ "' AND "
		cQuery += "D_E_L_E_T_ <> '*' "

		TCSQLEXEC(cQuery)

        TCSQLEXEC("COMMIT")

Next

Return          
