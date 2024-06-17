#include "rwmake.ch"
#define _nD_ENTER Chr(13)+Chr(10)

*-----------------------
User Function Impr_Etq()

Private _cPerg := "MTK_01"+SPACE(4)

AjustaSX1()


@ 208,182 To 423,590 Dialog oDlg Title OemToAnsi( Space(10)+"IMPRESSAO DE ETIQUETAS" )
@ 006,009 To 083,196

@ 011,015 Say OemToAnsi(Upper("                    I m p r e s s a o   d e   E t i q u e t a s "))
@ 022,015 Say OemToAnsi(Upper("                                                               "))
//@ 029,015 Say OemToAnsi(" ")
@ 040,015 Say OemToAnsi("   Esta rotina ira imprimir Etiquetas (CB0) dos produtos Importados")
@ 050,015 Say OemToAnsi("   e transferencia entre filiais.                                  ")


@ 090,040 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 090,090 BmpButton Type 01 Action Impr_CB0()
@ 090,140 BmpButton Type 02 Action Close(oDlg)

Activate Dialog oDlg Centered

Return


*---------------------
Static Function Impr_CB0()
Close(oDlg)

RptStatus({|| Etq_Impr() })

Return

*-------------------------
Static Function Etq_Impr()
// Impressao efetiva das etiquetas em pares
Local _aEtiq   := {} // Array que contera as etiquetas a serem impressas (lado a lado ou nao)
Local _cChave  := ""
Local cTipoBar := ""
Local _cAlias  := "TEMP_SQL"
Local _cQuery  := ""
Local _nEtqL   := 0
Local _nEtqC   := 0
Local _i       := 0
Local _cDescr  := ""
Local sConteudo:= ""
Local lRet     := .f.


SetRegua(3)

DbSelectArea("SB1")
DbSetOrder(1)

DbSelectArea("CB0")
DbSetOrder(1)

/*
If mv_par01 == 1
DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+mv_par02)
Else
DbSelectArea("SBE")
DbSetOrder(1)
DbSeek(xFilial("SBE")+mv_par02)
EndIf

If !Found()
Alert("Codigo "+mv_par02+" nao Encontrado.")
Return
EndIf
*/


IncRegua("Coletando...")

_cQuery := " SELECT CB0_CODETI, CB0_CODPRO, CB0_QTDE, CB0_X_DFRU, CB0_X_PRT, CB0_NFSAI, CB0_NFENT , CB0_SERIEE , CB0_FORNEC , CB0_LOJAFO "+_nD_ENTER

_cQuery += " FROM " + RetSqlName("CB0") + "  (NOLOCK) CB0 " + _nD_ENTER
_cQuery += " WHERE " + _nD_ENTER
_cQuery += " CB0_FILIAL='" + xFilial("CB0") + "' AND "

_cQuery += " CB0_X_DFRU >= '" + mv_par01 + "' AND " + _nD_ENTER		// DFRUN de
_cQuery += " CB0_X_DFRU <= '" + mv_par02 + "' AND " + _nD_ENTER		// DFRUN ate

_cQuery += " CB0_CODETI >= '" + mv_par04 + "' AND " + _nD_ENTER		// etiq de
_cQuery += " CB0_CODETI <= '" + mv_par05 + "' AND " + _nD_ENTER		// etiq  ate

_cQuery += " CB0_NFENT  >= '" + mv_par06 + "' AND " + _nD_ENTER		// nf de
_cQuery += " CB0_NFENT  <= '" + mv_par08 + "' AND " + _nD_ENTER    	// nf ate

_cQuery += " CB0_SERIEE >= '" + mv_par07 + "' AND " + _nD_ENTER    	// serie de
_cQuery += " CB0_SERIEE <= '" + mv_par09 + "' AND " + _nD_ENTER   		// serie ate

_cQuery += " CB0_FORNEC  = '" + mv_par10 + "' AND " + _nD_ENTER		// fornecedor(cod)
_cQuery += " CB0_LOJAFO  = '" + mv_par11 + "' AND " + _nD_ENTER		// loja For

_cQuery += " CB0_CODPRO  >= '" + mv_par12 + "' AND " + _nD_ENTER		// Produto de
_cQuery += " CB0_CODPRO  <= '" + mv_par13 + "' AND " + _nD_ENTER		// Produto Ate

_cQuery += " CB0_LOCAL   >= '" + mv_par14 + "' AND " + _nD_ENTER		// Local de
_cQuery += " CB0_LOCAL   <= '" + mv_par15 + "' AND " + _nD_ENTER		// Local Ate

_cQuery += " CB0_LOCALI  >= '" + mv_par16 + "' AND " + _nD_ENTER		// Local de
_cQuery += " CB0_LOCALI  <= '" + mv_par17 + "' AND " + _nD_ENTER		// Local Ate


_cQuery += " D_E_L_E_T_<>'*' " + _nD_ENTER
_cQuery += " ORDER BY CB0_X_DFRU " + _nD_ENTER

MemoWrit("ImprEtq.Sql",_cQuery)

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAlias, .F., .T.)

//TcSetField(_cAlias,"DATA","D",8,0)

ContETQ	:= 50		// contador para imprimir somente as 50 primeiras etiquetas... apos os testes tirar esta linha

// tirar tambem o and abaixo e remover a linha 149. (Gerardo)
While !Eof() //.and. contETQ > 0
	

	
	DbSelectArea(_cAlias)
	
	cCodPro	:= CB0_CODPRO
	cCodigo	:= ""                                                 
	cCodigo	:= CB0_CODETI
	_cDescr := ""
	_xFlag	:= CB0_X_PRT
	
	
	//-> Posiciona no SB1 e CB0
	DbSelectArea("SB1")
	DbSeek(xFilial("SB1")+cCODPRO)
	If !Found()
		_cDescr := ""
	Else
		_cDescr := SB1->B1_DESC
	EndIf
	
	DbSelectArea("CB0")
	DbSeek(xFilial("CB0")+cCODIGO)
	If !Found()
		(_cAlias)->( DbSkip() )
		Loop
	EndIf
	
	cCodigo := Alltrim(cCodigo)
	cTipoBar := 'MB07' //128
	If ! Usacb0("01")
		If Len(cCodigo) == 8
			cTipoBar := 'MB03'
		ElseIf Len(cCodigo) == 13
			cTipoBar := 'MB04'
		EndIf
	EndIf
	
	//	If Usacb0("01")
	//		cCodigo := If(cCodID ==NIL,CBGrvEti('01',{SB1->B1_COD,nQtde,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,cPedido,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem}),cCodID)
	//	Else
	//      cCodigo := SB1->B1_CODBAR
	//	EndIf
	
	// __cUserId Variável Publica com o ID do Usuário Logado
	cNome := Alltrim(UsrRetName(__cUserId))

	
	IF  CB0->CB0_X_PRT = 0 .OR. ( ALLTRIM(UPPER(cNome)) $ "ADMINISTRADOR")
		aadd( _aEtiq, { cCODPRO, _cDescr, cCODIGO, cTipoBar, CB0->CB0_X_PRT } )
	Endif
	
	
	DbSelectArea(_cAlias)
	DbSkip()
	
	//ContETQ--
	
EndDo

DbSelectArea( _cAlias )
DbCloseArea()

IncRegua("Imprimindo...")

ASort(_aEtiq,,,{|x,y| y[2] > x[2] })

If Len(_aEtiq) > 0
	
	//	Setando o local da Impressao
	If MV_PAR03 == GetMV("MV_IACD01")
		CB5SetImp(CBRLocImp("MV_IACD01"),IsTelNet())
	ElseIf MV_PAR03 == GetMV("MV_IACD02")                                       
		CB5SetImp(CBRLocImp("MV_IACD02"),IsTelNet())
	Endif
	
	/*
	CB5SetImp(CBRLocImp("MV_IACD01"), IsTelNet())
	//CB5SetImp(CBRLocImp(MV_PAR03), IsTelNet())
	
	CB5SetImp(CBRLocImp("MV_IACD01"), IsTelNet()) // - versao anterior
	*/
	
	For _i := 1 to Len(_aEtiq)
		
		
		//Anderson - Variavel de ajuste rapido das etiquetas.
		_nEtqL := 4
		_nEtqC := 0
		
		If SM0->M0_CODIGO='01'
    	   MSCBLOADGRF("MTK.GRF")
    	ELSE
    	   MSCBLOADGRF("UBC.GRF")
    	Endif   
		
		MSCBBEGIN(1,6)
		// Lado esquerdo
		MSCBBOX(01+_nEtqC, 06+_nEtqL, 41+_nEtqC, 06+_nEtqL)
		/*Alteracao em 26/08 - MV */
		If Len(AllTrim(_aEtiq[_i,2]))  < 16
			MSCBBOX(01+_nEtqC, 11+_nEtqL, 41+_nEtqC, 11+_nEtqL)
		EndIf
		
		If SM0->M0_CODIGO='01'
    	   MSCBGRAFIC(01+_nEtqC, 01+_nEtqL, "MTK")
    	ELSE
    	   MSCBGRAFIC(01+_nEtqC, 01+_nEtqL, "UBC")
    	Endif   
		
		MSCBSAY(20+_nEtqC, 01+_nEtqL, _aEtiq[_i,1], "N", "0", "030,030") // B1_COD
		MSCBSAY(01+_nEtqC, 08+_nEtqL, Substr(_aEtiq[_i,2],1,16), "N", "0", "020,035")  // B1_DESC
		
		If Len(AllTrim(_aEtiq[_i,2]))  > 16
			MSCBSAY(01+_nEtqC, 11+_nEtqL, Substr(_aEtiq[_i,2],17,16), "N", "0", "020,035")  // B1_DESC
		EndIf
		
		MSCBSAYBAR(03+_nEtqC, 14+_nEtqL, _aEtiq[_i,3], "N", _aEtiq[_i,4], 7, .F., .T., .F., , 2, 2, .F., .F., "1", .T.) // CB0_CODETI (Codigo de Barras) e Tipo de Etiqueta
		
		MSCBInfoEti("Produto", "30X100")
		
		DbSelectArea("CB0")
		DbSetOrder(1)
		IF DbSeek(xfilial()+_aEtiq[_i,3])
			Reclock("CB0",.F.)
			CB0->CB0_X_PRT	:= CB0->CB0_X_PRT+1
			MsUnLock()
		ENDIF
		
		
		
		// Lado Direito
		If  _i < Len(_aEtiq)
			
			_nEtqL := 4
			_nEtqC := 42
			
			_i := _i + 1
			
			
			_lFlagPRT	:= .T.
			
			
			DbSelectArea("CB0")
			DbSetOrder(1)
			IF DbSeek(xfilial()+_aEtiq[_i,3])
				IF CB0->CB0_X_PRT > 0
					_lFlagPRT	:= .F.
				Endif
			Endif
			
			
			MSCBBOX(01+_nEtqC, 06+_nEtqL, 41+_nEtqC, 06+_nEtqL)
			
			If Len(AllTrim(_aEtiq[_i,2]))  < 16
				MSCBBOX(01+_nEtqC, 11+_nEtqL, 41+_nEtqC, 11+_nEtqL)
			EndIf
			
			//MSCBGRAFIC(01+_nEtqC, 01+_nEtqL, "MTK")

			If SM0->M0_CODIGO='01'
    	   	   MSCBGRAFIC(01+_nEtqC, 01+_nEtqL, "MTK")
    	    ELSE
    	       MSCBGRAFIC(01+_nEtqC, 01+_nEtqL, "UBC")
    	    Endif   
			
			MSCBSAY(20+_nEtqC, 01+_nEtqL, _aEtiq[_i,1], "N", "0", "030,030") // B1_COD
			MSCBSAY(01+_nEtqC, 08+_nEtqL, Substr(_aEtiq[_i,2],1,16), "N", "0", "020,035")  // B1_DESC
			
			If Len(AllTrim(_aEtiq[_i,2]))  > 16
				MSCBSAY(01+_nEtqC, 11+_nEtqL, Substr(_aEtiq[_i,2],16,16), "N", "0", "020,035")  // B1_DESC
			EndIf
			
			MSCBSAYBAR(03+_nEtqC, 14+_nEtqL, _aEtiq[_i,3], "N", _aEtiq[_i,4], 7, .F., .T., .F., , 2, 2, .F., .F., "1", .T.) // (_cAlias)->CB0_CODETI (Codigo de Barras) e Tipo de Etiqueta
			
			MSCBInfoEti("Produto","30X100")
			
			DbSelectArea("CB0")
			DbSetOrder(1)
			IF DbSeek(xfilial()+_aEtiq[_i,3])
				Reclock("CB0",.F.)
				CB0->CB0_X_PRT	:= CB0->CB0_X_PRT+1
				MsUnLock()
			ENDIF
			
			
		Endif
		
		sConteudo:=MSCBEND()
		
		
	Next
	
	MSCBCLOSEPRINTER()
	
EndIf

IncRegua("Imprimindo...")

Return sConteudo


*---------------------
Static Function AjustaSX1()

Local aRegistros := {}
Local i,j        := 0



aadd(aRegistros,{_cPerg,"01","Local DFRun Inicial?"	,"","","mv_ch1","C",15,0,0,"G","","MV_PAR01",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","",""   ,""})
aadd(aRegistros,{_cPerg,"02","Local DFRun Final  ?"	,"","","mv_ch2","C",15,0,0,"G","","MV_PAR02",""         ,"",""  ,"ZZZZZZZZZZZZZZZ","",""        ,"","","","","","","","","","","","","","","","","","",""   ,""})
aadd(aRegistros,{_cPerg,"03","Local Impressao    ?"    ,"","","mv_ch3","C",06,0,0,"G","NAOVAZIO()","MV_PAR03",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","","CB5",""})
aadd(aRegistros,{_cPerg,"04","Etiqueta de        ?"	,"","","mv_ch4","C",10,0,0,"G","","MV_PAR04",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","",""   ,""})
aadd(aRegistros,{_cPerg,"05","Etiqueta Ate       ?" 	,"","","mv_ch5","C",10,0,0,"G","","MV_PAR05",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","",""   ,""})
aadd(aRegistros,{_cPerg,"06","Nota Fiscal de     ?"	,"","","mv_ch6","C",06,0,0,"G","","MV_PAR06",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","",""   ,""})
aadd(aRegistros,{_cPerg,"07","Serie de           ?" 	,"","","mv_ch7","C",03,0,0,"G","","MV_PAR07",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","",""   ,""})
aadd(aRegistros,{_cPerg,"08","Nota Fiscal Ate    ?"	,"","","mv_ch8","C",06,0,0,"G","","MV_PAR08",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","",""   ,""})
aadd(aRegistros,{_cPerg,"09","Serie Ate          ?" 	,"","","mv_ch9","C",03,0,0,"G","","MV_PAR09",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","",""   ,""})
aadd(aRegistros,{_cPerg,"10","Fornecedor         ?"    ,"","","mv_cha","C",06,0,0,"G","","MV_PAR10",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","","FOR",""})
aadd(aRegistros,{_cPerg,"11","Loja Fornecedor    ?"    ,"","","mv_chb","C",02,0,0,"G","","MV_PAR11",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","",""   ,""})
aadd(aRegistros,{_cPerg,"12","Produto de         ?"    ,"","","mv_chc","C",15,0,0,"G","","MV_PAR12",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{_cPerg,"13","Produto Ate        ?"    ,"","","mv_chd","C",15,0,0,"G","","MV_PAR13",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{_cPerg,"14","Local   de         ?"    ,"","","mv_che","C",02,0,0,"G","","MV_PAR14",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{_cPerg,"15","Local   Ate        ?"    ,"","","mv_chf","C",02,0,0,"G","","MV_PAR15",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{_cPerg,"16","Localizacao de     ?"    ,"","","mv_chg","C",15,0,0,"G","","MV_PAR16",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{_cPerg,"17","Localizacao Ate    ?"    ,"","","mv_chh","C",15,0,0,"G","","MV_PAR17",""         ,"",""  ,""               ,"",""        ,"","","","","","","","","","","","","","","","","","","","",""})

/*
DbSelectArea("SX1")
For i:=1 to Len(aRegistros)
If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
RecLock("SX1",.T.)
Else
RecLock("SX1",.f.)
EndIf

_nK := 0
_nK := Len(aRegistros[i])

If _nK <> FCount()
_nK := Len(aRegistros[i])
EndIf

For j:=1 to _nK
FieldPut(j,aRegistros[i,j])
Next j
MsUnlock()
Next I
*/

Return
