/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTKACD01  บAutor  ณAnderson            บ Data ณ  24/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLibera Nfe de Importacao para Classificacao.                บฑฑ
ฑฑบ          ณem funcao do uso do sigaacd                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multi-Tek                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MTKACD01

cCadastro := "Libera  Classificao NFE"

aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;
{ "Visualizar"   ,"AxVisual" , 0, 2},;
{ "Liberar"    ,'ExecBlock("MTKLIBCLA",.F.,.F.)', 0, 3} }

If SuperGetMV("MV_CONFFIS") == "S"
	
	aCores    := {{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. Empty(F1_STATUS)', 'ENABLE' },;	// NF Nao Classificada
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="N"'	 , 'DISABLE'},;		// NF Normal
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="P"'	 , 'BR_AZUL'},;		// NF de Compl. IPI
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="I"'	 , 'BR_MARRON'},;	// NF de Compl. ICMS
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="C"'	 , 'BR_PINK'},;		// NF de Compl. Preco/Frete
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="B"'	 , 'BR_CINZA'},;	// NF de Beneficiamento
	{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="D"'    , 'BR_AMARELO'},;	// NF de Devolucao
	{ 'F1_STATCON<>"1" .AND. !EMPTY(F1_STATCON)', 'BR_PRETO'}}
	
Else
	
	aCores    := {{ 'Empty(F1_STATUS)', 'ENABLE' },; // NF Nao Classificada
	{'F1_TIPO=="N"', 'DISABLE'   },; // NF Normal
	{'F1_TIPO=="P"', 'BR_AZUL'   },; // NF de Compl. IPI
	{'F1_TIPO=="I"', 'BR_MARRON' },;	 // NF de Compl. ICMS
	{'F1_TIPO=="C"', 'BR_PINK'   },;	 // NF de Compl. Preco/Frete
	{'F1_TIPO=="B"', 'BR_CINZA'  },;	 // NF de Beneficiamento
	{'F1_STATCON<>"1"', 'BR_PRETO'  },;	 // NF em Conferencia
	{'F1_TIPO=="D"', 'BR_AMARELO'} }	 // NF de Devolucao
	
EndIf

dbSelectArea("SF1")
dbSetOrder(1)

mBrowse(6,1,22,75,"SF1",,,,,,aCores)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTKACD02  บAutor  ณAnderson            บ Data ณ  24/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma complementar ao MTKACD01 o qual ira verif.  se a NFบฑฑ
ฑฑบ          ณescolhida pode ter o status mudado ou nao qto. a conferenciaบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multi-Tek                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MTKLIBCLA()
Local _nVolume := 0
Local _cCodEsp := ""
Local _cEspecie := ""
Local _nPesoBrt := 0
Local _cEspecie := ""
Local _nPesoLiq := 0


// Vamos verificar aqui se a PRE-NF que nao tem etiquetas foi gerada pelo SIGAEIC

If !Empty(SF1->F1_HAWB)
	
	
	DbSelectArea("SD1")
	DbSetOrder(1)
	If Dbseek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		
		While !EOF() .AND. xFilial("SD1") == SD1->D1_FILIAL .AND. SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
			
			//
			// Facilitador da Digitacao
			//
			SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+"012"))
			
			DbSelectArea("SD1")
			RECLOCK("SD1",.F.)
			D1_TES     = '012'
			D1_CF      = SF4->F4_CF
			D1_CLASFIS = SUBSTR(SD1->D1_CLASFIS,1,1)+SF4->F4_SITTRIB
			MsUnlock()
			
			DbSelectArea("SD1")
			DbSkip()
			
		EndDo
		
		
		_nVolume := Getadvfval("EIH","EIH_QTDADE",xFILIAL("EIH")+SF1->F1_HAWB,1," ")  //Quant Volume
		_cCodEsp := Getadvfval("EIH","EIH_CODIGO",xFILIAL("EIH")+SF1->F1_HAWB,1," ")  //Codigo da Especie
		_cEspecie := Getadvfval("SJF","JF_DESC",xFILIAL("SJF")+_cCodEsp,1," ")    //Descricao da Especie
		_nPesoBrt := Getadvfval("SW6","W6_PESO_BR",xFILIAL("SW6")+SF1->F1_HAWB,1," ")
		_nPesoLiq := Getadvfval("SW6","W6_PESOL",xFILIAL("SW6")+SF1->F1_HAWB,1," ")
		
		
		// Liberadno PRE-NF do SIGAEIC
		DbSelectArea("SF1")
		RecLock("SF1",.F.)
		SF1->F1_STATCON	:= "1"
		SF1->F1_X_USRLC	:= Substr(cUsuario,7,15)
		SF1->F1_ESPECI1 := _cEspecie
		SF1->F1_PLIQUI  := _nPesoLiq
		SF1->F1_PBRUTO  := _nPesoBrt
		SF1->F1_VOLUME1 := _nVolume
		MsUnlock()
		
        Aviso("ATENCAO", "NF Liberada pelo Modulo de IMPORTACAO, para Classificacao...",{"&Ok"})
		
	EndIf

Else

   Aviso("ATENCAO", "Rotina apenas utilizada para NFE de Importacao. A nota escolhida nao e de importacao...",{"&Ok"})

Endif

Return()

