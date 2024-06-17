#include "rwmake.ch"
#include "topconn.ch"


USER FUNCTION TABAPPEND
Local cAlias        := ""
Local aStru         := {}
Local cArqTrab    := ""
Local cCampo     := ""
Local nPos         :=  0
Local cVal          := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria arquivo de todas as empresas                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY := 1 to 6


    //
    // Gera E2
    //
    dbSelectArea("SE2") 
 
    cEmpresa  := strzero(ny,2)
    aStruct  := dbStruct()
	cNomeArq := CriaTrab(aStruct)
	cTabela  := "_SE2"+cEmpresa+"0"     
    cArqTrab := "\SIGAADV\_TABELASVIRADA\"+cTabela+".dbf"
	
    dbSelectArea("SE2") 
	dbSeek( cFilial )
	Copy To &cNomeArq For E2_MSEMP = cEmpresa
    Copy File &cNomeArq To &cArqTrab


	dbUseArea(.T.,,cArqTrab,"SE2TMP",.F.,.F.)


    cEmpresa  := strzero(ny,2)
    aStruct  := dbStruct()
	cNomeArq := CriaTrab(aStruct)
	cTabela  := "_SEF"+cEmpresa+"0"     
    cArqTrab := "\SIGAADV\_TABELASVIRADA\"+cTabela+".dbf"


	dbUseArea(.T.,,cArqTrab,"SEFTMP",.F.,.F.)


    cEmpresa  := strzero(ny,2)
    aStruct  := dbStruct()
	cNomeArq := CriaTrab(aStruct)
	cTabela  := "_SE5"+cEmpresa+"0"     
    cArqTrab := "\SIGAADV\_TABELASVIRADA\"+cTabela+".dbf"


	dbUseArea(.T.,,cArqTrab,"SE5TMP",.F.,.F.)


              
    DbSelectArea("SE2TMP")
    DG
	dbSelectArea("SE5")
	dbSetOrder(7)
	If dbSeek(xFilial("SE5")+SE2TMP->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
			While !Eof() .and. xFilial("SE5") == SE5->E5_FILIAL .and. ;
				SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_FORNECE+E5_LOJA) == ;
				SE2TMP->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
				nAtuRec := SE5->(RECNO())
				dbSkip()
				nProxRec := SE5->(Recno())
				dbGoto(nAtuRec)
				RecLock("SE5")
				
				
				
				SE5->E5_PARCELA:=cParcela
				FKCOMMIT()
				dbGoto(nProxRec)
			Enddo
		Endif
		
		dbSelectArea("SEF")
		dbSetOrder(7)
		If dbSeek(xFilial("SEF")+"P"+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO))
			While !Eof() .and. xFilial("SEF") == SEF->EF_FILIAL .and. ;
				SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO) == ;
				SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
				
				nAtuRec := SE5->(RECNO())
				dbSkip()
				nProxRec := SE5->(Recno())
				dbGoto(nAtuRec)
				
				If SEF->(EF_FORNECE+EF_LOJA) == SE2->(E2_FORNECE+E2_LOJA)
					RecLock("SEF")
					SEF->EF_PARCELA:=cParcela
					MsUnlock()
					FKCOMMIT()
				Endif
				dbGoto(nProxRec)
			Enddo
		Endif
    W





Next


Return

/*
    

ProcRegua(len(aTabelas))


For nX :=  1 to len(aTabelas)
	
	cAlias        := Substr(aTabelas[ny],1,3)

	dbUseArea(.T.,,cArqTrab,"TMP",.F.,.F.)
	
	dbgotop()
	
	
	While !TMP->(eof())
		
		Reclock(cAlias,.T.)   
		For nY:= 1 to len(aStru)
			DbSelectArea("TMP")
			cCampo := aStru[nY][1]
			nPos   := FieldPos(cCampo)                                //FieldName(nCont)// Nome do Campo
			if nPos # 0
				cVal   := FieldGet(nPos)                                // Conteudo
				DbSelectArea(cAlias)
				nPos   := FieldPos(cCampo)                              // Busca posicao Campo no Trb
				if nPos # 0 
					FieldPut(nPos,cVal)                                   // Grava Conteudo
				Endif
			Endif
		Next
		MsUnLock()
		
		
		DBSELECTAREA("TMP")
		TMP->(dbSkip())
	
	EndDo
	
	TMP->(dbCloseArea())
	
Next  nX
*/


