#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   ºAutor  ³Cleber M.           º Data ³  15/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este PE efetuara a geracao da NF de Entrada na Filial (depo-º±±
±±º          ³sito fechado) apos a gravacao da NF de Saida de material da º±±
±±º          ³Matriz e tambem atualizara a tabela SZn com dados a serem   º±±
±±º          ³enviados apos a sincronizacao do Handheld 			      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek (Projeto Handheld)                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2460I

Local cNumNF 	:= ""  // Nr. da proxima NF (sequencial SXE)
Local cNumSer	:= ""  // Serie da NF 
Local aArea		:= GetArea()
Local aCab		:= {}
Local aLinha	:= {}
Local aItens	:= {}
Local aEtiquetas:= {}
Local nItens 	:= 0
Local cFilOrig	:= ""
Local nPosDoc	:= 0
Local cNovoItem := "00"
Local cFornecPad:= ""
Local lConfirmSX8 := .f.	
PRIVATE lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a NF esta sendo gerada para um cliente    ³
//³que seja deposito fechado. Caso positivo, sera gerada ³
//³a NF de Entrada nesta filial com as respectivas etiq. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SA1")
dbSetOrder(1)
If MsSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA)
	If SA1->(FieldPos("A1_X_ALMOX")) > 0
		If !Empty(SA1->A1_X_ALMOX)
			cFilAlmox := SA1->A1_X_ALMOX
		Else
			RestArea(aArea)
			return 
		Endif                             
	Else
		ConOut("Atencao - Criar o campo A1_X_ALMOX caracter de dois via Configurador.")
		RestArea(aArea)		
		return 
	Endif
Endif

//ConOut("Doc " + SF2->F2_DOC)
//ConOut("Serie " + SF2->F2_SERIE)
//ConOut("Cliente/Loja " + SF2->F2_CLIENTE + "/" + SF2->F2_LOJA)

cNumSer		:= GetMv("MV_SERIPAD",,"UNI")
cFornecPad	:= GetMv("MV_FORNPAD",,"00000101")

//Adiciona no array os dados do cabecalho da NF
AAdd( aCab, { "F1_DOC"    , cNumNF							, Nil } )	// Numero da NF : Obrigatorio
AAdd( aCab, { "F1_SERIE"  , cNumSer							, Nil } )	// Serie da NF  : Obrigatorio

AAdd( aCab, { "F1_TIPO"   , "N"  	                		, Nil } )	// Tipo da NF   : Obrigatorio
AAdd( aCab, { "F1_FORNECE", Substr(cFornecPad,1,6) 		, Nil } )	// Codigo do Fornecedor : Obrigatorio
AAdd( aCab, { "F1_LOJA"   , Right(cFornecPad,2)  	   		, Nil } )	// Loja do Fornecedor   : Obrigatorio
AAdd( aCab, { "F1_EMISSAO", dDataBase           			, Nil } )	// Emissao da NF        : Obrigatorio
AAdd( aCab, { "F1_FORMUL" , "N"                 			, Nil } )  // Formulario
AAdd( aCab, { "F1_ESPECIE", If(Empty(CriaVar("F1_ESPECIE",.T.)),;
	PadR("NF",Len(SF1->F1_ESPECIE)),CriaVar("F1_ESPECIE",.T.)), Nil } )  // Especie
AAdd( aCab, { "F1_COND"   , SF2->F2_COND    	  			, Nil } )	// Condicao do Fornecedor

	
//Posiciona nos itens da NF de Saida
dbSelectArea("SD2")
dbSetOrder(3)
If MsSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA )
	While !Eof() .And. SD2->D2_FILIAL == xFilial("SD2") .And.;
			SD2->D2_DOC == SF2->F2_DOC .And.;
			SD2->D2_SERIE == SF2->F2_SERIE .And.;
			SD2->D2_CLIENTE == SF2->F2_CLIENTE .And.;
			SD2->D2_LOJA == SF2->F2_LOJA
			
		
		//Adicionar no array os dados do item da NF
		aLinha := {}				
		AAdd( aLinha, { "D1_COD"    , SD2->D2_COD    , Nil } )
		AAdd( aLinha, { "D1_QUANT"  , SD2->D2_QUANT	  , Nil } )					
		AAdd( aLinha, { "D1_VUNIT"  , (SD2->D2_TOTAL+SD2->D2_DESCON+SD2->D2_DESCZFR)/SD2->D2_QUANT, Nil })

		AAdd( aLinha, { "D1_TOTAL"  , A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL"),Nil } )
		AAdd( aLinha, { "D1_VALDESC"  , A410Arred(SD2->D2_DESCON/SD2->D2_QUANT*aLinha[2][2],"D1_VALDESC"),Nil } )	

		AAdd( aLinha, { "D1_IPI"    , SD2->D2_IPI    	, Nil } )	
		AAdd( aLinha, { "D1_LOCAL"  , SD2->D2_LOCAL  	, Nil } )
		AAdd( aLinha, { "D1_TES" 	, "052" 			, Nil } ) //TES de Entrada
		AAdd( aLinha, { "D1_UM"     , SD2->D2_UM 		, Nil } )
		If Rastro(SD2->D2_COD)
			AAdd( aLinha, { "D1_LOTECTL", SD2->D2_LOTECTL, ".T." } )
			AAdd( aLinha, { "D1_NUMLOTE", SD2->D2_NUMLOTE, ".T." } )
			AAdd( aLinha, { "D1_DTVALID", SD2->D2_DTVALID, ".T." } )
			AAdd( aLinha, { "D1_POTENCI", SD2->D2_POTENCI, ".T." } )
		EndIf
		AAdd( aLinha, { "D1_NFORI"  , SD2->D2_DOC    , Nil } )
		AAdd( aLinha, { "D1_SERIORI", SD2->D2_SERIE  , Nil } )
		AAdd( aLinha, { "D1_ITEMORI", SD2->D2_ITEM   , Nil } )
		AAdd( aLinha, { "D1_ICMSRET", SD2->D2_ICMSRET, Nil } )	
		
		AAdd( aItens, aLinha)
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca as etiquetas no CB0   	  	   ³
		//³ referentes a este item da NF de Saida  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CB0")
		dbSetOrder(9) 
		//Pesquisa usando o indice por NF Saida+SerieNF+Produto
		MsSeek(xFilial("CB0") + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_COD)
		
		While !CB0->(Eof()) .And. CB0->CB0_FILIAL == xFilial("CB0") .AND. ;
			SD2->D2_DOC == CB0->CB0_NFSAI .AND. SD2->D2_SERIE == CB0->CB0_SERIES ;
			.AND. SD2->D2_COD == CB0->CB0_CODPRO
			
			If CB0->CB0_CODPRO == SD2->D2_COD				
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estrutura do array aEtiquetas³
				//³ 1 - Cod. Etiqueta            ³
				//³ 2 - NF Saida                 ³
				//³ 3 - Serie NF                 ³
				//³ 4 - Cod. Prod.               ³
				//³ 5 - Qtde                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aAdd(aEtiquetas, {CB0->CB0_CODETI ,CB0->CB0_NFSAI,CB0->CB0_SERIES,;
									CB0->CB0_CODPRO,CB0->CB0_QTDE} )

				nItens++        	    
        	Endif
        	CB0->(dbSkip())
		
		Enddo

		dbSelectArea("SD2")				
		dbSkip()	
	Enddo
	
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a MATA103 para criar a NF de Entrada  ³
//³ na respectiva filial                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aCab) > 0 .And. Len(aItens) > 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Altera a cFilAnt primeiro para que a NF de Entrada seja ³
	//³ incluida na Filial referente ao Almoxarifado            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilOrig:= cFilAnt 
	cFilAnt := cFilAlmox
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pega o prox. nr. da NF  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3->(dbSetOrder(2))
	SX3->(dbSeek("F1_DOC"))	
	If Empty(SX3->X3_RELACAO)
		lConfirmSX8 := .T.	
		cNumNF := GetSxeNum("SF1", "F1_DOC")
		SF1->(dbSetOrder(1))
		While SF1->(dbSeek(xFilial("SF1")+cNumNF))
			ConfirmSX8()
			cNumNF := GetSxeNum("SF1", "F1_DOC")
		EndDo
	Endif
	SX3->(dbSetOrder(1))	
	
	                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza no array aCab o prox. nr. da NF  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPosDoc := Ascan(aCab, { |X| X[1] = "F1_DOC" })
	If nPosDoc > 0 .And. !Empty(cNumNF)
		aCab[nPosDoc,2] := cNumNF
	ElseIf nPosDoc > 0
		aCab := aDel(aCab,nPosDoc)
		aCab := aSize(aCab,Len(aCab)-1)
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Executa a MsExecAuto da NF de Entrada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MATA103(aCab, aItens, 3)
	
	If !lMsErroAuto
		Alert("NF de Entrada incluida com sucesso " + SF1->F1_DOC)
	    If lConfirmSX8
	    	ConfirmSX8()
	    EndIf		
	Else
	    If lConfirmSX8
			RollBackSX8()
	    EndIf		
		MostraErro()		
		cFilAnt := cFilOrig 
		RestArea(aArea)	
		return
	EndIf
Else
	Alert("SF2460I: Não foram gerados dados para a NF de Entrada")
	RestArea(aArea)	
	return	
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravar os dados da NF e das etiquetas nas tabelas SZ³
//³	Usar o array aEtiquetas 							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("Z20") 
dbSetOrder(1)
If !MsSeek( xFilial("Z20") + SF1->F1_DOC + SF1->F1_SERIE )
	RecLock("Z20",.T.)

	Z20->Z20_FILIAL		:= xFilial("Z20")
	Z20->Z20_DOC   		:= SF1->F1_DOC
	Z20->Z20_SERIE		:= SF1->F1_SERIE
	Z20->Z20_EMISSA		:= SF1->F1_EMISSAO
	Z20->Z20_FORNEC 	:= SF1->F1_FORNECE
	Z20->Z20_LOJA		:= SF1->F1_LOJA
	Z20->Z20_QTDIT		:= nItens
	Z20->Z20_STATUS		:= "A"
	
	For nI:=1 to Len(aEtiquetas)
		
		cNovoItem := SomaIt(cNovoItem)                    
		SB1->(dbSetOrder(1))
		SB1->( MsSeek(xFilial("SB1")+aEtiquetas[nI][4]) )
				
		SB5->(dbSetOrder(1))
		SB5->( MsSeek(xFilial("SB5")+aEtiquetas[nI][4]) )
				
		dbSelectArea("Z21")
		RecLock("Z21",.T.)
		
		Z21->Z21_FILIAL	:= xFilial("Z21")
		Z21->Z21_ITEM	:= cNovoItem
		Z21->Z21_ETIQ	:= aEtiquetas[nI][1]
		Z21->Z21_CODPRO	:= aEtiquetas[nI][4]
		Z21->Z21_DESCRI	:= SB1->B1_DESC
		Z21->Z21_QTDE	:= aEtiquetas[nI][5]
		Z21->Z21_DOC	:= Z20->Z20_DOC
		Z21->Z21_SERIE	:= Z20->Z20_SERIE
		//Indicador granel (B5_TIPUNIT 0=Nao;1=Sim)               
		Z21->Z21_GRANEL	:= IIf(SB5->B5_TIPUNIT=="0", "S", "N")
		Z21->Z21_STATUS	:= "A"
	
		Z21->(MsUnLock())
	Next
	
	Z20->(MsUnLock())
	ConOut("NF " + SF1->F1_DOC + " gravada em Z20/Z21 com sucesso!")
Else    
	ConOut("Aviso: NF ja existente em Z20/Z21")	
Endif

//Restaura a variavel da Filial do Sistema e o Ambiente
cFilAnt := cFilOrig 
RestArea(aArea)

Return
  
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Estrutura das tabelas a serem criadas: Z20 e Z21	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
Z20_FILIAL		C	2
Z20_DOC         C	6
Z20_SERIE		C	3
Z20_EMISSA		D	8
Z20_FORNEC		C	6
Z20_LOJA		C	2
Z20_QTDIT		N	4
Z20_STATUS		C	1
-----------------------------------
Z21_FILIAL		C	2
Z21_ITEM		C	2
Z21_ETIQ		C	10
Z21_CODPRO		C	15 
Z21_DESCRI		C	30
Z21_QTDE  		N	4	
Z21_DOC			C	6
Z21_SERIE		C	3
Z21_GRANEL		C	1
Z21_STATUS		C	1
Z21_QTDCON		N 	4

Campo: A1_X_ALMOX	C	2

Indices               
========
Z20
1 = Z20_FILIAL+Z20_DOC+Z20_SERIE
2 = Z20_FILIAL+Z20_STATUS
   
Z21
1 = Z21_FILIAL+Z21_DOC+Z21_SERIE
2 = Z21_FILIAL+Z21_DOC+Z21_SERIE+Z21_ITEM

*/
