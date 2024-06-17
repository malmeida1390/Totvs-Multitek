#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/07/00

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MTA330TOK ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Elimina os registros do CT2 caso a rotina de custo seja      ³±±
±±³          ³utilizada novamente.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MA330OK()

Private cRotina:="MATA240-"+xFilial("SD2")+"/MATA250-"+xFilial("SD2")+"/MATA260-"+xFilial("SD2")+"/MATA261-"+xFilial("SD2")+"/MATA331-"+xFilial("SD2")+"/MTA460C-"+xFilial("SD2")+"/MTA520C-"+xFilial("SD2")+"/CNA200C-"+xFilial("SD2")+"/MATA685-"+xFilial("SD2")+"/"
// Alterado MATA330 para MATA331 este tratativa e efetuada no ponto de ENTRADA DEPCTBGRV.
// objetivo e controlar a delecao dos registros do ct2
// Local cRotina:="MATA240-"+xFilial("SD2")+"/MATA250-"+xFilial("SD2")+"/MATA260-"+xFilial("SD2")+"/MATA261-"+xFilial("SD2")+"/MATA330-"+xFilial("SD2")+"/MTA460C-"+xFilial("SD2")+"/MTA520C-"+xFilial("SD2")+"/CNA200C-"+xFilial("SD2")+"/MATA685-"+xFilial("SD2")+"/"

MsgRun( OemToAnsi( "Aguarde. Efetuando Exclusao de Lanc. Contabeis no Periodo..." ),"",{||Ca100ApCTB(cRotina,a330ParamZX[01])})


RETURN



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³cA100ApCtb³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 18/06/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Apaga lancamentos feitos por outros programas e estorna    ³±±
±±³          ³ os valores do Plano de Conta (CT1) - SIGACTB               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ cA100ApCTB(ExpC1,ExpD1)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = String com o(s) nome(s) do(s) programa(s)          ³±±
±±³          ³         gerador(es) dos lancamentos que serao apagados     ³±±
±±³          ³ ExpD1 = Data limite a considerar no arquivo de lancamentos ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
User Function Ca100ApCTB(cRotina,dDataFim)

Local dDataIni := GetMv("MV_ULMES")+1

Local lCusto	:= CtbMovSaldo("CTT")
Local lItem		:= CtbMovSaldo("CTD")
Local lCLVL		:= CtbMovSaldo("CTH")
Local lDeleta  := .T.
Local nMinRecno, nMaxRecno

Local nCont
Local nValor


cRotina	:= Upper(cRotina)
If CtbInUse()
	ChkFile("CT2")
Endif

#IFDEF TOP
	If TcSrvType() != "AS/400"                     		

      // Verifico na moeda 01 se a data de inicio e de fim eh valida
		If ! CtbDtComp(5,dDataIni,"01") .Or. ! CtbDtComp(5,dDataFim,"01")
			Return
		Endif
		
		//Verifico o menor registro e maior registro da tabela a ser atualizada		
		cRotina := If(Right(cRotina, 1) = "/", Left(cRotina, Len(cRotina) - 1), cRotina)
		
		cRecno := "cRecno"  						
		cQuery := "SELECT MIN(R_E_C_N_O_) MINRECNO,"
		cQuery += "MAX(R_E_C_N_O_) MAXRECNO "
		cQuery += "FROM "+RetSqlName("CT2")+ " "
		cQuery += "WHERE CT2_FILIAL = '" + xFilial ("CT2") + "' AND "
		cQuery += "CT2_DATA >= '" + Dtos(dDataIni) + "' AND "
		cQuery += "CT2_DATA <= '" + Dtos(dDataFim) + "' AND "
		cQuery += "CT2_ROTINA IN " + FormatIn(cRotina, "/" ) + " AND "
		cQuery += "(CT2_FILORI = '  ' OR CT2_FILORI = '" + cFilAnt + "' ) AND "
		cQuery += "(CT2_EMPORI = '  ' OR CT2_EMPORI = '" + cEmpAnt + "' ) AND"
		cQuery := ChangeQuery(cQuery)


       ///TCSQLEXEC(("DELETE CT2010 WHERE  CT2_FILIAL = '"+xFilial("CT2")+"' AND CT2_ROTINA = 'MATA331/"+xFilial("SD2")+"'" ))

		
		If ( Select ( "cRecno" ) <> 0 )
			dbSelectArea ( "cRecno" )
			dbCloseArea ()
		Endif
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cRecno,.T.,.F.)
		
		nMaxRecno := (cRecno)->MAXRECNO
		nMinRecno := (cRecno)->MINRECNO

		cQuery := "DELETE FROM "+RetSqlName("CT2")+ " "
		cQuery += "WHERE CT2_FILIAL = '"+xFilial ("CT2") +"' AND "
		cQuery += "CT2_DATA >= '" + Dtos(dDataIni) + "' AND "
		cQuery += "CT2_DATA <= '" + Dtos(dDataFim) + "' AND "
		cQuery += "CT2_ROTINA IN " + FormatIn(cRotina, "/" ) + " AND "
		cQuery += "(CT2_FILORI = '  ' OR CT2_FILORI = '" + cFilAnt + "' ) AND "
		cQuery += "(CT2_EMPORI = '  ' OR CT2_EMPORI = '" + cEmpAnt + "' ) AND "

		For nCont := nMinRecno To nMaxRecno STEP 1024
			cChave := "R_E_C_N_O_>="+Str(nCont,10,0)+" AND R_E_C_N_O_<="+Str(nCont+1023,10,0)+""
			TcSqlExec(cQuery+cChave)
		Next nCont                                                  
	Else

#ENDIF

dbSelectArea("CT2")
dbSeek(xFilial()+DTOS(dDataIni),.T.)

While ! Eof() .And. CT2->CT2_FILIAL == xFilial() .And. ;
		DTOS(CT2->CT2_DATA) <= DTOS(dDataFim)
	
	If ! (Alltrim(Upper(CT2->CT2_ROTINA))$cRotina )
		dbSkip()
		Loop
	EndIf
	
	If !Empty(CT2->CT2_FILORI)
		If CT2->CT2_FILORI != cFilAnt
			dbSkip()
			Loop
		EndiF
	EndIf
	
	If !Empty(CT2->CT2_EMPORI)
		If CT2->CT2_EMPORI != cEmpAnt
			dbSkip()
			Loop
		EndiF
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o Plano de Contas                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lDeleta := .T.							// Verifica qual registro pode deletar
	For nCont := 1 To Len(CT2->CT2_MOEDAS)
		IF SubStr(CT2->CT2_MOEDAS,nCont,1) == "1" .And. lDeleta
			cMoeda  := StrZero(nCont,2)
			nValor  := &('CT2->CT2_VLR'+cMoeda)
			If lDeleta
				lDeleta := CtbDtComp(5,CT2->CT2_DATA,cMoeda)
			Endif

// Removida desgravacao de saldos - Sera Chamado Reprocessamento

		EndIf
	Next nCont		
	If lDeleta
		dbSelectArea("CT2")
		RecLock( "CT2", .f., .t. )
		CT2->( DbDelete() )
		MsUnlock()
	EndIf
	
	dbSkip( )
End

#IFDEF TOP
	Endif
#ENDIF

cFil190 := If(Empty(xFilial("CT2")), Space(2), cFilAnt)
CTBA190(.T.,dDataIni,dDataFim,cFil190,cFil190,"1",.F.,"  ")

Return


//
// Antes de efetuar novos Lancamentos contabeis devemos Limpar os Lancametos Anteriores.
//

//TCSQLEXEC(("DELETE CT2010 WHERE  CT2_FILIAL = '"+xFilial("CT2")+"' AND CT2_ROTINA = 'MATA331/"+xFilial("SD2")+"'" ))
//TCSQLEXEC(("COMMIT"))


*/