#include "rwmake.ch"

User Function MTKLISTPR()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CALIAS,_NRECNO,_NORDEM,_CNOMEARQ,_CCAMINHO,_CDIRETORIO")
SetPrvt("_CARQUIVO,_NCODCLI,_NNROCOM,A3_NROCOM")
SetPrvt("A3_DTULCHQ,A3_BAIRROE,A3_CEPE,A3_MUNE,A3_ESTE,_ACAMPOS")
SetPrvt("_CARQTMP,_CNUMCGC,_NTAMANHO,_CDVC,_CCGC,_CDIG")
SetPrvt("J,_NCNT,_NSUM,I,_NDIG,_LRET1")
SetPrvt("_LRET2,_CCPF,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    � MTKLISTPR� Autor � Edelcio Cano          � Data � 05/07/04 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Atualiza Custo STD atraves da Lista de preco especifica da 낢�
굇� 		    � Multi-Tek.                                             	  낢�
굇� 		    �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Especifico Multi-Tek                                       낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�/*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Guarda Ambiente 														  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Private _cOrigem	:= ""
Private _Grava  	:= ""
Private _cArquivo	:= ""
Private _cPasta   := ""
Private _aLog 	   := {}

Private cCadastro := "Importar arquivo .CSV"
Private aTxt      := {}
Private aRet      := {}

Private _cPasta   := "\RELATO\"
Private _cArquivo := ""


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿣ariaveis que serao alimentadas com os conteudos dos�
//� campos do DTC                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Private  _cSku	    := ""
Private	_cRefer   := ""
Private	_cSufix   := ""
Private	_cMarcaAt := ""
Private  _nValor	 := 0
Private  _cMarca   := ""
Private _cSkuMtk   := ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿣ariavel que armazenara o calculo do Custo Std Muti-Tek�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Private  _nCustStd:= 0

_aLog 	    := {} //Vetor do Log de erro

_aAreaAtu := GetArea()
_cPerg    := "LISTPR"+SPACE(4)
_lRetorno := .T.
_lGrava	  := .T.
_nTotImp  := 0
_nFator	  := 0

dbSelectArea("SB1")
_aAreaB1	:=	GetArea()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//�          Perguntas                 �
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿺v_par01    -  Arquivo de Entrada   �
//쿺v_par02    -  Fabricante           �
//쿺v_par03    -  Loja                 �
//쿺v_par04    -  Dolar Base           �
//쿺v_par05    -  Forma de Carga       �
//쿺v_par06    -  Origem               �
//쿺v_par07    -  Data Referencia      �
//쿺v_par08    -  Armazena Lista Precos�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Validperg()


pergunte(_cPerg,.F.) // Sempre Le a ultima solicitacao com base no SX1


_cArquivo := _cPasta + AllTrim(mv_par01) + ".CSV"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Desenha a tela de apresentacao da rotina								  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
@ 96,042 TO 333,510 DIALOG oDlg1 TITLE "Calculo do Custo Stander - Especifico Multi-Tek"
@ 08,010 TO 084,222
@ 91,138 BMPBUTTON TYPE 5 ACTION PergList()
@ 91,168 BMPBUTTON TYPE 1 ACTION (Processa({|| PROC_TMP()}),oDlg1:End())
@ 91,196 BMPBUTTON TYPE 2 ACTION (oDlg1:End())
@ 24,014 SAY "Esta rotina tem como objetivo calcular o Custo Std a partir da Lista de Precos "
@ 34,014 SAY "gravando  o custo Std, data do calculo  no SB1-Tabela de Produtos e gerar Logs "
@ 44,014 SAY "para as possiveis  ocorrencias  durante o  processamento. Permitira  tambem  a "
@ 54,014 SAY "gravacao da  Lista  de Precos  processada, na tabela  SZU-Repositorio da Lista "
@ 74,014 SAY "ATENCAO ! O programa ira pesquisar o arquino na Pasta R:\RELATO                "
ACTIVATE DIALOG oDlg1 Center


RETURN

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function PergList()

_lRetorno := Pergunte(_cPerg)

_cPasta   := "\RELATO\"
_cArquivo := _cPasta + AllTrim(mv_par01) + ".CSV"

If _lRetorno
	If EMPTY(_cArquivo)
		MsgBox("Rotina CANCELADA - Nome do arquivo em branco...","ERRO")
		_lRetorno := .F.
	Else
		If !File(_cArquivo)
			MsgBox("Rotina CANCELADA - Verifique o nome do arquivo digitado...","ERRO")
			_lRetorno := .F.
		EndIf
	EndIf
	
	If Empty(mv_par02)
		MsgBox("Rotina CANCELADA - Codigo do Fornecedor em branco...","ERRO")
		_lRetorno := .F.
	Endif
	
	If Empty(mv_par03)
		MsgBox("Rotina CANCELADA - Codigo da Loja do Fornecedor em branco...","ERRO")
		_lRetorno := .F.
	Endif
	
	If mv_par04 < 1
		MsgBox("Rotina CANCELADA - Taxa da Moeda deve ser maior ou igual a 1,00...","ERRO")
		_lRetorno := .F.
	Endif
	
	If mv_par07 == ctod("")
		MsgBox("Rotina CANCELADA - Data de Referencia em branco...","ERRO")
		_lRetorno := .F.
	Endif
	
Endif


Return


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Static Function CustList()
Static Function PROC_TMP()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿣erificacao das perguntas para identificar o Tipo de �
//쿌tualizacao da Lista e caputrar o Fator (Nac ou Imp) �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If mv_par06 == 1
	_nFator := Getadvfval("SA2","A2_X_FATNA",xFILIAL("SA2")+mv_par02+mv_par03,1," ")
Else
	_nFator := Getadvfval("SA2","A2_X_FATIM",xFILIAL("SA2")+mv_par02+mv_par03,1," ")
Endif

If _nFator = 0
	MsgBox("Rotina CANCELADA - Fator do Fornecedor esta Zerado, Atualize o Fator no Cadastro de Fornecedores...","ERRO")
	Return
Endif

_cArquivo := _cPasta + AllTrim(mv_par01) + ".CSV"

If (nHandle := FT_FUse(AllTrim(_cArquivo)))== -1
	Help(" ",1,"NOFILEIMPOR")
	Return
EndIf


procregua(Len(aTxt))

FT_FGOTOP()
While !FT_FEOF()
	
	IncProc(OEMtoAnsi("Lendo Arquivo..."+_cArquivo))
	
	//PmsIncProc(.T.)
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



If Len(aTxt) < 2
	msgbox('Arquivos de dados esta em branco','Dados da Lista','ALERT')
	Return
endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿌rmazena a Marca para consistencia da mesma nos prx Regs.�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//_cMarca	:= Alltrim(aTxt[nX][4])


procregua(Len(aTxt))


For nX := 2 to Len(aTxt)
	//PmsIncProc(.T.)
	IncProc(OEMtoAnsi("Atualizando Produtos..."))
	
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿞e os campos forem numericos,serao convertidos para �
	//쿬aracter, menos o campo VALOR                       �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	_cSku     :=  alltrim(aTxt[nX][1])
	_cRefer   :=  alltrim(aTxt[nX][2])
	_cSufix   :=  alltrim(aTxt[nX][3])
	_cMarcaAt :=  alltrim(aTxt[nX][4])
	_nValor   :=   troca(aTxt[nX][5])
	_cSkuMtk  :=  strzero(val(alltrim(aTxt[nX][6])),6)
	
	_nRegLista:= nX  //Recno()
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿎onsiste tamanho dos campos da Lista, se nao estiverem    �
	//쿬onforme definido abaixo, gera o log e passa p/ o prx Reg.�
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If Len(_cSku) > 20
		GeraLog("Sku Forn: "+Alltrim(_cSku)+"-Tam > que B1_FABRIC, "+"Reg.: "+Strzero(_nRegLista,6))
		loop
	ElseIf Len(_cRefer) > 17
		GeraLog("Ref: "+Alltrim(_cRefer)+"-Tam > que B1_X_REFER, "+"Reg.: "+Strzero(_nRegLista,6))
		loop
	Elseif Len(_cSufix) > 15 //09
		GeraLog("Suf: "+Alltrim(_cSufix)+"-Tam > que B1_X_SUFIX, "+"Reg.: "+Strzero(_nRegLista,6))
		loop
	ElseIf Len(_cMarcaAt) > 3
		GeraLog("Marca: "+Alltrim(_cMarcaAt)+"-Tam > que B1_X_MARCA, "+"Reg.: "+Strzero(_nRegLista,6))
		loop
	Endif
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//쿛repara as variaveis com o formato dos campos, pois serao�
	//퀅tilizados como Chave de pesquisa.                       �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	_cSku    :=  _cSku    + space(20 - Len(_cSku))
	_cRefer  :=  _cRefer  + space(17 - Len(_cRefer))
	_cSufix  :=  _cSufix  + space(15 - Len(_cSufix))   //09
	_cMarcaAt:=  _cMarcaAt+ space(03 - Len(_cMarcaAt))
	_cSkuMtk :=  _cSkuMtk + space(20 - Len(_cSkuMtk))
	
	//IncProc(OemToAnsi('Processando Lista de Precos'))

	
	If Empty(_cMarcaAt)
		GeraLog("Marca em Branco na Lista de Precos, "+"Reg.: "+Strzero(_nRegLista,6))
		loop
	Endif
	
	//If _cMarcaAt <> _cMarca
	//	GeraLog(Alltrim(_cMarcaAt)+"-"+"Difer. da Marca, "+"Reg.: "+Strzero(_nRegLista,6))
	//   loop
	//Endif
	
	If mv_par05 == 1
		_cChave := _cSku + _cMarcaAt
	Elseif mv_par05 == 2
		_cChave := _cRefer + _cSufix + _cMarcaAt
	Else  
		_cChave := _cSkuMtk
	Endif
	
	dbSelectArea("SB1")
	//_aAreaB1	:=	GetArea()
	If mv_par05 == 1
	   	DbOrderNickname("B1_12FABRI")    //22/07/2008_Virada_         //B1_X_SIMIL + EIS
		//dbSetOrder(12)//Sku no Fornec+Marca
	Elseif  mv_par05 == 2
   		DbOrderNickname("B1_11REFER")    //22/07/2008_Virada_         //B1_X_SIMIL + EIS
		//dbSetOrder(11)// Ref+Sufix+Marca
	Else 
		dbSetOrder(1)   // xfilial+sku
	Endif
	dbGotop()
	
	If !dbSeek(xFilial("SB1")+_cChave)
		If mv_par05 == 2
			GeraLog(Alltrim(_cRefer)+"+"+Alltrim(_cSufix)+"+"+Alltrim(_cMarcaAt)+"-Nao encontrado no SB1, "+"Reg.: "+Strzero(_nRegLista,6))
		Elseif mv_par05 == 1
			GeraLog(Alltrim(_cSku)+"+"+Alltrim(_cMarcaAt)+"-Nao encontrada no SB1, "+"Reg.: "+Strzero(_nRegLista,6))
		Elseif mv_par05 == 3
			GeraLog(Alltrim(_cSkuMtk)+"-Nao encontrada no SB1, "+"Reg.: "+Strzero(_nRegLista,6))
		Endif
		loop
	Endif

	
	_cOrigem := SB1->B1_ORIGEM
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//쿎onsiste se B1_Origem esta em Branco,�
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	If Empty(_cOrigem)
		GeraLog(Alltrim(_cSku)+"-Sku Forn no SB1 com B1_ORIGEM em Branco !")
		loop
	Endif


	
	If mv_par05 == 1 //Por Sku do Fornecedor
		
		Do While SB1->B1_FILIAL == xFilial("SB1") .and. SB1->B1_FABRIC == _cSku .and. ;
			SB1->B1_X_MARCA == _cMarcaAt
			
			_cOrigem := SB1->B1_ORIGEM
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//쿎onsiste se B1_Origem esta compativel com  o Tipo de Lista�
			//쿪 ser importado (Nac/Imp)                                 �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If mv_par05 == 2 //Refer+Sufixo+Marca
				If mv_par06 == 1 // Nacional
					If !(_cOrigem $ "0/2" )//0-Nacional, 2-Importado(Adq. no Mercado Interno)
						GeraLog("SKU do Fornec. "+_cSku+" com Origem errada no SB1!")
					Endif
				Else // 2 Importado
					If !(_cOrigem $ "1/2")//1-Importado, 2-Importado(Adq. no Mercado Interno)
						GeraLog("SKU do Fornec. "+_cSku+" com Origem errada no SB1!")
					Endif
				Endif
			Endif
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//쿑uncao que Calcula o Custo Std -Especifico da Multitek�
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			_CalCustStd()
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//� Atualiza Custo Std no SB1 									  �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//If _nCustStd > 0
				dbSelectArea("SB1")
				RecLock("SB1",.F.)
				SB1->B1_X_DTSTD := mv_par07
				SB1->B1_X_CTSTD := _nCustStd
				MsUnLock()
			//Endif
			
			dbSelectArea("SB1")
			dbSkip()
			
		Enddo
		
	Elseif mv_par05 == 2
		
		//Por Referencia+Sufixo+Marca
		Do While SB1->B1_FILIAL == xFilial("SB1") .and. SB1->B1_X_REFER == _cRefer .and.;
			SB1->B1_X_SUFIX == _cSufix .and. SB1->B1_X_MARCA == _cMarcaAt
			
			
			_cOrigem := SB1->B1_ORIGEM
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//쿎onsiste se B1_Origem esta compativel com  o Tipo de Lista�
			//쿪 ser importado (Nac/Imp)                                 �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If mv_par05 == 2 //Refer+Sufixo+Marca
				
				If mv_par06 == 1 // Nacional
					If !(_cOrigem $ "0/2") //0-Nacional, 2-Importado(Adq. no Mercado Interno)
						GeraLog("SKU do Fornec. "+_cSku+" com Origem errada no SB1!")
					Endif
				Else // 2 Importado
					If !(_cOrigem $ "1/2")//1-Importado, 2-Importado(Adq. no Mercado Interno)
						GeraLog("SKU do Fornec. "+_cSku+" com Origem errada no SB1!")
					Endif
				Endif
			Endif
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//쿑uncao que Calcula o Custo Std -Especifico da Multitek�
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			_CalCustStd()
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//� Atualiza Custo Std no SB1 									  �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//If _nCustStd > 0
				dbSelectArea("SB1")
				RecLock("SB1",.F.)
				SB1->B1_X_DTSTD := mv_par07
				SB1->B1_X_CTSTD := _nCustStd
				MsUnLock()
			//Endif
			
			dbSelectArea("SB1")
			dbSkip()
			
		Enddo

	Else


		Do While SB1->B1_FILIAL == xFilial("SB1") .and. ALLTRIM(SB1->B1_COD) == ALLTRIM(_cSkuMtk)
			
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//쿑uncao ue Calcula o Custo Std -Especifico da Multitek�
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			_CalCustStd()
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			//� Atualiza Custo Std no SB1 									  �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			dbSelectArea("SB1")
			RecLock("SB1",.F.)
			SB1->B1_X_DTSTD := mv_par07
			SB1->B1_X_CTSTD := _nCustStd
			MsUnLock()
			
			dbSelectArea("SB1")
			dbSkip()
			
		Enddo

		
	Endif
	
	
	If mv_par08 == 1
		GrvRepList()
	Endif
	
Next nX

If !Empty(_aLog)
	_Imprime()
Endif


Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿐xcRepList튍utor  쿐delcio Cano        � Data �  07/18/04   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Verifica no Repositorio SZU, se Lista ja foi atualizada,   볍�
굇�          � pois os registro do Repositorio serao excluidos em uma     볍�
굇�          � nova atualizacao.                                          볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AP                                                         볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

Static Function ExcRepList()

_aAreaP	:= GetArea()

dbSelectArea("SZU")
_aAreaZu	:= GetArea()
dbSetorder(1)
dbGotop()

If dbSeek(xFilial("SZU")+Dtos(mv_par07)+mv_par02+mv_par03)
	
	Do While SZU->ZU_FILIAL = xFilial("SZU") .and. SZU->ZU_DATAREF = mv_par07 .and. SZU->ZU_CODFORN = mv_par02 ;
		.and. SZU->ZU_LOJA = mv_par03
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//쿏eleta Registro do SZU-Repositorio   �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		RecLock("SZU",.F.)
		dbDelete()
		MsUnLock()
		
		dbSkip()
		
	Enddo
Endif

RestArea(_aAreaZu)
RestArea(_aAreaP)

Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  �_CALCUSTSTD튍utor  쿐delcio Cano       � Data �  07/14/04   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Apos consistencias calcula o Custo Std, conforme regra da  볍�
굇�          � Multi-Tek                                                  볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Multi-Tek                                                  볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

Static Function _CALCUSTSTD()

_nCustStd	:= 0

If mv_par05 == 2 //Refer+Sufixo+Marca
	If mv_par06 == 1 // Nacional
		If _cOrigem $ "0/2" //0-Nacional, 2-Importado(Adq. no Mercado Interno)
			_nCustStd	:=	(_nValor *	_nFator) * mv_par04
		Endif
	Else // 2 Importado
		If _cOrigem $ "1/2" //1-Importado, 2-Importado(Adq. no Mercado Interno)
			_nCustStd	:=	(_nValor *	_nFator) * mv_par04
		Endif
	Endif
Else //Sku no Fornecedor+Marca
	_nCustStd	:=	(_nValor *	_nFator) * mv_par04
Endif

Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿒RVREPLIST튍utor  쿐delcio Cano        � Data �  07/14/04   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Grava Lista de Preco no arquivo especifico SZU-Repositorio 볍�
굇�          � Lista de Preco                                             볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Multi-Tek                                                  볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

Static Function GRVREPLIST()

_aAreaAt	:= GetArea()

dbSelectArea("SZU")
_aAreaZu	:= GetArea()

RecLock("SZU",.T.)
SZU->ZU_FILIAL	:=	xFilial()
SZU->ZU_CODFORN	:=	mv_par02
SZU->ZU_LOJA	:=	mv_par03
SZU->ZU_DATAREF	:=	mv_par07
SZU->ZU_SKUFORN	:=	_cSku
SZU->ZU_REFEREN	:=	_cRefer
SZU->ZU_SUFIXO	:=	_cSufix
SZU->ZU_MARCA	:=	_cMarcaAt
SZU->ZU_VALOR	:=	_nValor
MsUnLock()

RestArea(_aAreaZU)
RestArea(_aAreaAt)

Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    � GeraLog  � Autor � Edelcio Cano          � Data � 16/07/04 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o � Funcao que efetuara a gravacao do arquivo de LOG           낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Multi-Tek                                                  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

Static Function GeraLog(_cString1)

AADD(_aLog,_cString1)

Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    � _Imprime � Autor � Edelcio Cano          � Data � 16/07/04 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o � Impressao do LOG de ocorrencias na importacao              낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Multi-Tek                                                  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

Static Function _Imprime()

titulo    := "Ocorrencias na importacao diaria"
cDesc1    := PADC("Emiss꼘 do relatorio com as ocorrencias",74)
cDesc2    := PADC("do Calculo do Custo Std a partir da ",74)
cDesc3    := PADC("Lista de Precos - Especifico Multi-Tek",74)
tamanho   := "P"
limite    := 80
cString   := "SE2"
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "MTKLISTPR"
nLastKey  := 0
//            0       10       20       30       40       50       60       70
//            .12345679.12345679.12345679.12345679.12345679.12345679.12345679.123456789.
cabec1    := " Ocorrencias do Calculo de Custo Std"
cabec2    := ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para Impressao dos Cabecalhos e Rodape  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt   := Space(10)
cbcont  := 00
li      := 80
m_pag   := 01

wnrel := "MTKLISTPR"
wnrel := SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

PROCESSA({|| _ImpNow()},"Processando o relatorio")

Return


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    � _ImpNow  � Autor � Edelcio Cano          � Data � 16/07/04 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o � Inicio da Impressao (Para funcionamento da REGUA)          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Multi-Tek                                                  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

Static Function _ImpNow()

nTipo     := IF(aReturn[4]==1,15,18)

procregua(Len(_aLog))

For _i := 1 to Len(_aLog)
	
	IncProc("Imprimindo, aguarde ...")
	
	If li > 59
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := prow() + 1
	EndIf
	
	@ li, 000 PSAY _aLog[_i]
	
	li := li + 1
Next

Roda(0,"","P")

Set device to Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

Ms_Flush()

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔un뇙o    �_CRIASX1  � Autor 쿐delcio Cano        � Data �  05/07/04   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒escri뇙o � Funcao auxiliar que valida ou cria perguntas no SX1        볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Programa principal                                         볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

Static Function ValidPerg()

Local aRegs     := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(_cPerg,10)

//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_GRPSXG
//Grupo   /Ordem   /Pergunta  /         /            /Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01   /Def01   /          /          /Cnt01   /Var02   /Def02   /          /          /Cnt02   /Var03   /Def03   /          /          /Cnt03   /Var04   /Def04   /          /          /Cnt04   /Var05   /Def05   /          /          /Cnt05   /F3   /Grupo SXG
aAdd(aRegs,{_cPerg,"01","Arquivo de Entrada ?","","","mv_ch1","C",12,0,0,"G","","mv_par01",""             ,"","","","",""           ,"","","","",""     ,"","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{_cPerg,"02","Fabricante         ?","","","mv_ch2","C",06,0,0,"G","","mv_par02",""             ,"","","","",""           ,"","","","",""     ,"","","","","","","","","","","","","","FOR",""})
aAdd(aRegs,{_cPerg,"03","Loja               ?","","","mv_ch3","C",02,0,0,"G","","mv_par03",""             ,"","","","",""           ,"","","","",""     ,"","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{_cPerg,"04","Tx Conversao Moeda ?","","","mv_ch4","N",07,4,0,"G","","mv_par04",""             ,"","","","",""           ,"","","","",""     ,"","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{_cPerg,"05","Forma de Carga     ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","SKU do Fornec ","","","","","Ref+Sufix+Marca"           ,"","","","","Sku Mtk","","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{_cPerg,"06","Origem             ?","","","mv_ch6","N",01,0,0,"C","","mv_par06","Nacional      ","","","","","Importado      "           ,"","","","",""     ,"","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{_cPerg,"07","Data Referencia    ?","","","mv_ch7","D",08,0,0,"G","","mv_par07",""             ,"","","","",""           ,"","","","",""     ,"","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{_cPerg,"08","Grava Lista Preco  ?","","","mv_ch8","N",01,0,0,"C","","mv_par08","Sim           ","","","","","Nao            "           ,"","","","",""     ,"","","","","","","","","","","","","","   ",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
Return


Static Function Troca(cCampo)
Local nCampo := 0

cCampo := StrTran(cCampo,".","")

cCampo := StrTran(cCampo,",",".")

nCampo := Val(cCampo)

Return(nCampo)
