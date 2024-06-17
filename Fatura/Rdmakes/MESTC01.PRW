#INCLUDE  "FIVEWIN.CH"
#include  "topconn.ch"
#include  "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MESTC01   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gestao de Materiais Multi-Tek - PGMM (Planilha de Gestao    º±±
±±º          ³Materiais Multi-Tek)                                        º±±
±±º          ³                                                            º±±
±±º          ³Fechamento Mensal dos Historicos de Movimentacao e          º±±
±±º          ³reclassificacao Logistica da PGMM - Geracao (SZ9 e SZA)     º±±
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MESTC01()

Local oDlg,nOpca:=0
Local cPeriodo1 := ""
Local cPeriodo2 := ""
Local oFntFecha,oFntFecha1,oFntFecha2,oFntFecha3,oFntFecha4,oFntFecha5 
Local lReprocessa := .F.

Private nPgmPeri := GETMV("MV_PGMPERI") // Pediodo de Fechamento p/ Leitura dos Historicos.
Private nPgmGiro := GETMV("MV_PGMGIRO") // Pediodo de Fechamento p/ Leitura dos Historicos.
Private dIniMes  := Ctod("")            // Data inicial para processamento do Mes.
Private dIniGir  := Ctod("")            // Data Inicial para processamento do Giro do Estoque
Private dIniHis  := Ctod("")            // Data Inicial para processamento dos Historicos
Private dFimProc := Ctod("")            // Data final para processamento do Fechamento do Mes
                                        //  do Historio e do Giro

Private aDatFecha:= {}  

//#IFDEF TOP               ??? Como isto funciona pode ser util
//	TCInternal(5,"*OFF")   // Desliga Refresh no Lock do Top
//#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o SX1 -                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aDatFecha[1] Data valida para Final de todos os Processamentos³
//³              (Mes, Historico e Giro)                          ³
//³ aDatFecha[2] Data valida para Inicio do Mes                   ³
//³ aDatFecha[3] Data valida para Inicio do Historico             ³
//³ aDatFecha[4] Data valida para Inicio do Giro                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDatFecha := U_DataFecha()


//Caso deseje travar o acesso
//If Substr(cAcesso,19,1) == " "
//	Help ( " ", 1, "SEMPERM" )
//	Return .F.
//EndIf  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha  NAME "TIMES NEW ROMAN" SIZE 19,34 BOLD   //Largura x Altura
DEFINE FONT oFntFecha1 NAME "TIMES NEW ROMAN" SIZE 6,10 BOLD
DEFINE FONT oFntFecha2 NAME "Ms Sans Serif"   SIZE 6,10 BOLD
DEFINE FONT oFntFecha3 NAME "Mono As"         SIZE 6,10 BOLD
DEFINE FONT oFntFecha4 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 11.5,22 BOLD

                     
DEFINE MSDIALOG oDlg FROM  96,4 TO 475,625 TITLE "FECHAMENTO MENSAL DOS HISTORICOS"  PIXEL

@ 018,  9 TO 158, 300 LABEL "" OF oDlg  PIXEL
@ 028, 15 Say " => ESTE PROGRAMA TEM COMO OBJETIVO:                                                   " SIZE 275, 10 OF oDlg PIXEL FONT oFntFecha2
@ 038, 15 Say "                                                                                             " SIZE 275, 10 OF oDlg PIXEL
@ 048, 15 Say " Efetuar o FECHAMENTO MENSAL DOS HISTORICOS de movimentacao e RECLASSIFICACAO LOGISTICA     " SIZE 275, 10 OF oDlg PIXEL  
@ 058, 15 Say " DA PGMM - Gerando  (SZ9 e SZA) que corresponde aos Historicos por Simil+EIS e SKU.         " SIZE 275, 10 OF oDlg PIXEL                                
@ 068, 15 Say "                                                                                             " SIZE 275, 10 OF oDlg PIXEL
@ 078, 15 Say " = > PARAMETROS ENVOLVIDOS:                                                                                 " SIZE 275, 10 OF oDlg PIXEL FONT oFntFecha2
@ 088, 15 Say "                                                                                             " SIZE 275, 10 OF oDlg PIXEL
@ 098, 15 Say " MV_PGMPERI - Periodo do parametro para analise do Historico e dos ultimos "+strzero(nPgmPeri,2)+" meses.      " SIZE 275, 10 OF oDlg PIXEL
@ 108, 15 Say " MV_PGMGIRO - Periodo do parametro para analise do Giro e dos ultimos "+strzero(nPgmGiro,2)+" meses.           " SIZE 275, 10 OF oDlg PIXEL
@ 118, 15 Say "                                                                                            " SIZE 275, 10 OF oDlg PIXEL                   
@ 128, 15 Say " = > PERIODOS VALIDOS (COM BASE NO SZ9 ULTIMO PROCESSAMENTO):                               " SIZE 275, 10 OF oDlg PIXEL FONT oFntFecha2
@ 138, 15 Say strzero(month(aDatFecha[1,1]),2)+" / " + str(year(aDatFecha[1,1]),4)+" - Reprocessamento do ultimo Fechamento  " SIZE 275, 10 OF oDlg PIXEL 
@ 148, 15 Say strzero(month(aDatFecha[2,1]),2)+" / " + str(year(aDatFecha[2,1]),4)+" - Fechar novo Perido.            " SIZE 275, 10 OF oDlg PIXEL

DEFINE SBUTTON FROM 168,209 TYPE 5 ACTION Pergunte("PLANI1",.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 168,238 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 168,267 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER



If nOpca == 1
   pergunte("PLANI1",.F.) // Sempre Le a ultima solicitacao com base no SX1

   If MV_PAR01 = 1        //  ( Fechamento )    

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Fechamento do novo Mes                                          ³
      //³                                                                 ³
      //³ aDatFecha[2,1] Data valida para Final de todos os Processamentos³
      //³                (Mes, Historico e Giro)                          ³
      //³ aDatFecha[2,2] Data valida para Inicio do Mes                   ³
      //³ aDatFecha[2,3] Data valida para Inicio do Historico             ³
      //³ aDatFecha[2,4] Data valida para Inicio do Giro                  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      // Data final para processamento do Fechamento do Mes do Historio e do Giro
      dFimProc :=         aDatFecha[2,1]
      // Data inicial para processamento do Mes.
      dIniMes  :=         aDatFecha[2,2]
      // Data Inicial para processamento dos Historicos
      dIniHis  :=         aDatFecha[2,3]
      // Data Inicial para processamento do Giro do Estoque
      dIniGir  :=         aDatFecha[2,4]
      
  Else                   //  ( Reprocessamento )
                                                
 
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Reprocessamento do Mes                                          ³
      //³                                                                 ³
      //³ aDatFecha[1,1] Data valida para Final de todos os Processamentos³
      //³                (Mes, Historico e Giro)                          ³
      //³ aDatFecha[1,2] Data valida para Inicio do Mes                   ³
      //³ aDatFecha[1,3] Data valida para Inicio do Historico             ³
      //³ aDatFecha[1,4] Data valida para Inicio do Giro                  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      // Data final para processamento do Fechamento do Mes do Historio e do Giro
      dFimProc :=         aDatFecha[1,1]
      // Data inicial para processamento do Mes.
      dIniMes  :=         aDatFecha[1,2]
      // Data Inicial para processamento dos Historicos
      dIniHis  :=         aDatFecha[1,3]
      // Data Inicial para processamento do Giro do Estoque
      dIniGir  :=         aDatFecha[1,4]
 
     lReprocessa := .T.

   Endif

   
   processa({|lend| U_MESTPROC(lReprocessa)},"Processamento da Planilha","Efetuando Processamento da Planilha",.F.)
   

EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MESTPROC  ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento dos Arquivos da Planilha.                     º±±
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MESTPROC(lReprocessa)
   
Local aSKU      := {}  // Vetor 1 - Sku
Local aEIS      := {}  // Vetor 2 - Simil + Eis + Sku  
Local aSimil    := {}  // Vetor 3 - Simil + Eis
Local nAcumCust := 0   // Acumulado dos Custos
Local lFechamento := If (Upper(Funname())= "#MESTC01",.T.,.F.) // Fechamento da Planilha

Default lReprocessa := .F.

If lFechamento
   ProcRegua(09,21,6)
Else
   ProcRegua(04,21,6)
Endif

If lFechamento
	
	// 1.Processa todas as Saidas de Estoque com base no SD2
	IncProc("Processando SD2 - Arquivo de Saidas")
	U_ProcSD2(@aSKU,@aEIS,@aSimil)
	
	// 2.Processa todas as Saidas de Estoque com base no SD3
	IncProc("Processando SD3 - Arquivo de Movimentos")
	U_ProcSD3(@aSKU,@aEIS,@aSimil)
	
	// 3.Grava o SZA com base na matriz aSku.
	IncProc("Gravando    SZA - Historico por Sku")
	U_ProcSZA(aSKU)
	
	// 4.Grava o SZ9 com base na matriz aSimil.
	IncProc("Gravando    SZ9 - Historico por Simil + Eis")
	U_ProcSZ9(aSimil)
	
Endif


aSKU    := {}  // Vetor 1 - Sku
aEIS    := {}  // Vetor 2 - Simil + Eis + Sku
aSimil  := {}  // Vetor 3 - Simil + Eis

// 6.Acumula saldos em Estoque dentro dos Vetores e retorna a variavel nAcumCust.
IncProc("Processando SB2 - Saldos em Estoque")
U_ProcSB2(@aSimil,@aSKU,@nAcumCust)



If lFechamento
	
	// 7.Processa o Historico e retorna a Variavel nAcumCust
	IncProc("Processando SZ9 - Historico por Simil + Eis")
	U_CalcSZ9(@aSimil,@nAcumCust)
	
Endif


// 8.Processa Vetor para definir as Classificacoes
IncProc("Processando Matriz Resultante do SB1 , SB2 e SZ9")
U_ProcVetor(@aSimil,@nAcumCust)

// 9.Encaminhamento/Dimensionamento os Estoques
IncProc("Calcula o Giro de Estoque")
U_GiroEst(@aSimil)


If lFechamento
	
	// 10.Grava novas classificacoes no SB1.
	IncProc("Atualizando SB1 com base na PGMM.")
	U_GravSB1(@aSimil)
	
Else
	
	// Geracao da PGMM com a gravacao do SZ7 e SZ8
	IncProc("Geracao de dados para a Manutencao.")
	U_GeraZ7eZ8(@aSimil,@aSKU)
	
Endif


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcSD2   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento dos Arquivos da Planilha.                     º±±
±±º          ³Arquivos de Saidas                                          º±±
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProcSD2(aSKU,aEIS,aSimil)
Local lQuery    := .T.
Local cAliasSD2 := ""
Local cAliasSB1 := ""

Local aStruSD2  := SD2->(dbStruct())
Local cQuery    := ""
Local cFilSD2   := ""
Local cIndex    := ""
Local cChave    := ""
Local nIndex    := 0
Local cCodiEis  := ""
Local cClassi   := ""

#IFDEF TOP
	If ( TcSrvType()!="AS/400" )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Totaliza registros de digitacao de inventario                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lQuery:=.T.
        cAliasSD2 := "SD2SQL"
        cAliasSB1 := "SD2SQL"
		aStruSD2  := SD2->(dbStruct())
		cQuery := " SELECT * "
		cQuery += " FROM "
		cQuery += RetSqlName("SD2")+" SD2 ,"
		cQuery += RetSqlName("SB1")+" SB1 ,"
		cQuery += RetSqlName("SF4")+" SF4 ,"
		cQuery += " WHERE "
		cQuery += " SD2.D2_EMISSAO>='"+DTOS(dIniMes)+"' AND"
		cQuery += " SD2.D2_EMISSAO<='"+DTOS(dFimProc)+"' AND"
		cQuery += " SD2.D2_TIPO = 'N'"
		cQuery += " SD2.D2_COD = SB1.B1_COD AND" 
		cQuery += " SD2.D2_TES = SF4.F4_CODIGO AND"  
		
		cQuery += " SF4.F4_X_APANH = 'S' AND" 
		//cQuery += " SF4.F4_DUPL    = 'S' AND"  Conf. Mauricio somente validar apanhe
		
		cQuery += " SD2.D_E_L_E_T_<>'*' AND"
		cQuery += " SB1.D_E_L_E_T_<>'*' AND"
		cQuery += " SF4.D_E_L_E_T_<>'*' "
	
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.F.,.T.)
		For nX := 1 To Len(aStruSD2)
			If aStruSD2[nX][2]<>"C" .And. FieldPos(aStruSD2[nX][1])<>0
				TcSetField(cAliasSD2,aStruSD2[nX][1],aStruSD2[nX][2],aStruSD2[nX][3],aStruSD2[nX][4])
			EndIf
		Next nX
	Else
        DbSelectArea("SD2")
		cFilSD2 := 'DTOS(D2_EMISSAO)>="'+dtos(dIniMes)+'".And.'
		cFilSD2 += 'DTOS(D2_EMISSAO)<="'+dtos(dFimProc)+'"'
		MsFilter(cFilSD2)
		dbSetOrder(1)
		dbSeek(xFilial()+dtos(dIniMes))
	EndIf
#ELSE                             

    lQuery   := .F.
    cAliasSD2:="SD2"
    cAliasSB1:="SB1"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o arquivo por data de Emissao                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD2")
	dbSetOrder(1)
	cIndex  := CriaTrab(nil,.f.)
	cChave  := "D2_EMISSAO"
    cFilSD2 := 'DTOS(D2_EMISSAO)>="'+dtos(dIniMes)+'".And.'
	cFilSD2 += 'DTOS(D2_EMISSAO)<="'+dtos(dFimProc)+'"'

	IndRegua("SD2",cIndex,cChave,,cFilSD2,"Selecionando Registros...") 
	nIndex := RetIndex("SD2")
	dbSelectArea("SD2")
	#IFNDEF TOP
		dbSetIndex( cIndex +OrdBagExt())
	#ENDIF
	dbSelectArea("SD2")
	dbSetOrder(nIndex+1)
	dbGoTop()

#ENDIF      

DbSelectArea(cAliasSD2)

While !(cAliasSD2)->(EOF())
	
	If !lQuery

		If  (cAliasSD2)->D2_TIPO # 'N'
			(cAliasSD2)->(dbSkip())
			Loop
        Endif  

        DbSelectArea("SB1")
        DbSetOrder(1)
        if !DbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)
			(cAliasSD2)->(dbSkip())
			Loop
		EndIf
        
        DbSelectArea("SF4")
        DbSetOrder(1)
        If !DbSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)
			(cAliasSD2)->(dbSkip())
			Loop
		EndIf
        
        If  SF4->F4_X_APANH # "S" 
			(cAliasSD2)->(dbSkip())
			Loop
		EndIf
	
	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados para processamento das Matrizes aSku,aEis,aSimil                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cCodiSku := (cAliasSD2)->D2_COD 
    nQuantid := (cAliasSD2)->D2_QUANT    
    nCustStd := (cAliasSB1)->B1_X_CTSTD      
    cCdSimil := (cAliasSB1)->B1_X_SIMIL                                   
 	cCodiEis := (cAliasSB1)->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+;
	                           B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)
	cClassi  := (cAliasSB1)->(B1_X_LMN+B1_X_PQR+B1_X_NEOIL+B1_X_XYZ+B1_X_123+B1_X_ABC)
                             
    PrVetor(cCodiSku,nQuantid,nCustStd,cCdSimil,cCodiEis,@aSKU,@aEIS,@aSimil,cClassi)    

    (cAliasSD2)->(DbSkip())
 
Enddo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcSD3   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento dos Arquivos da Planilha.                     º±±
±±º          ³SD3 - Arquivo de Movimentos Internos                        º±±
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProcSD3(aSKU,aEIS,aSimil) 

Local lQuery    := .T.
Local cAliasSD3 := ""
Local cAliasSB1 := ""

Local aStruSD3  := SD3->(dbStruct())
Local cQuery    := ""
Local cFilSD3   := ""
Local cIndex    := ""
Local cChave    := ""
Local nIndex    := 0
Local cClassi   := ""
                                                                                     

#IFDEF TOP
	If ( TcSrvType()!="AS/400" )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Totaliza registros de digitacao de inventario                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lQuery:=.T.
        cAliasSD3 := "SD3SQL"
        cAliasSB1 := "SD3SQL"
		aStruSD3  := SD3->(dbStruct())
		cQuery := " SELECT * "
		cQuery += " FROM "
		cQuery += RetSqlName("SD3")+" SD3 ,"
		cQuery += RetSqlName("SB1")+" SB1 ,"
		cQuery += RetSqlName("SF5")+" SF5 ,"
		cQuery += " WHERE "
		cQuery += " SD3.D3_EMISSAO>='"+DTOS(dIniMes)+"' AND"
		cQuery += " SD3.D3_EMISSAO<='"+DTOS(dFimProc)+"' AND"
		cQuery += " SD3.D3_COD = SB1.B1_COD AND" 
		cQuery += " SD3.D3_TM = SF5.F5_CODIGO AND"  
		cQuery += " SD3.D3_TM > '500' AND"  
		
		cQuery += " SF5.F5_X_APANH = 'S' AND" 
		
		cQuery += " SD3.D_E_L_E_T_<>'*' AND"
		cQuery += " SB1.D_E_L_E_T_<>'*' AND"
		cQuery += " SF5.D_E_L_E_T_<>'*' "
	
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD3,.F.,.T.)
		For nX := 1 To Len(aStruSD3)
			If aStruSD3[nX][2]<>"C" .And. FieldPos(aStruSD3[nX][1])<>0
				TcSetField(cAliasSD3,aStruSD3[nX][1],aStruSD3[nX][2],aStruSD3[nX][3],aStruSD3[nX][4])
			EndIf
		Next nX
	Else
        DbSelectArea("SD3")
		cFilSD3 := 'DTOS(D3_EMISSAO)>="'+dtos(dIniMes)+'".And.'
		cFilSD3 += 'DTOS(D3_EMISSAO)<="'+dtos(dFimProc)+'"'
		MsFilter(cFilSD3)
		dbSetOrder(1)               
		dbSeek(xFilial()+dtos(dIniMes))
	EndIf
#ELSE                             

    lQuery   := .F.
    cAliasSD3:="SD3"
    cAliasSB1:="SB1"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o arquivo por data de Emissao                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD3")
	dbSetOrder(1)
	cIndex  := CriaTrab(nil,.f.)
	cChave  := "D3_EMISSAO"
    cFilSD3 := 'DTOS(D3_EMISSAO)>="'+dtos(dIniMes)+'".And.'
	cFilSD3 += 'DTOS(D3_EMISSAO)<="'+dtos(dFimProc)+'"'

	IndRegua("SD3",cIndex,cChave,,cFilSD3,"Selecionando Registros...") 
	nIndex := RetIndex("SD3")
	dbSelectArea("SD3")
	#IFNDEF TOP
		dbSetIndex( cIndex +OrdBagExt())
	#ENDIF
	dbSelectArea("SD3")
	dbSetOrder(nIndex+1)
	dbGoTop()

#ENDIF      

DbSelectArea(cAliasSD3)

While !(cAliasSD3)->(EOF())
	
	If !lQuery

        DbSelectArea("SB1")
        DbSetOrder(1)
        if !DbSeek(xFilial("SB1")+(cAliasSD3)->D3_COD)
           (cAliasSD3)->(DbSkip())
			Loop
		EndIf
        
        DbSelectArea("SF5")
        DbSetOrder(1)
        If !DbSeek(xFilial("SF5")+(cAliasSD3)->D3_TM)
           (cAliasSD3)->(DbSkip())
			Loop
		EndIf
        
        If SF5->F5_X_APANH # "S" .OR. VAL(SF5->F5_CODIGO) <= 500
           (cAliasSD3)->(DbSkip())
			Loop
		EndIf
		
	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados para processamento das Matrizes aSku,aEis,aSimil                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cCodiSku := (cAliasSD3)->D3_COD 
    nQuantid := (cAliasSD3)->D3_QUANT    
    nCustStd := (cAliasSB1)->B1_X_CTSTD      
    cCdSimil := (cAliasSB1)->B1_X_SIMIL                                   
 	cCodiEis := (cAliasSB1)->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+;
	                           B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)
	cClassi  := (cAliasSD3)->(B1_X_LMN+B1_X_PQR+B1_X_NEOIL+B1_X_XYZ+B1_X_123+B1_X_ABC)


    PrVetor(cCodiSku,nQuantid,nCustStd,cCdSimil,cCodiEis,@aSKU,@aEIS,@aSimil,cClassi)    

    (cAliasSD3)->(DbSkip())
 
Enddo

Return
     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrVetor   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esta rotina visa executar o processamento dos  3 arrayss    º±±
±±º          ³do Fechamento.                                              º±±
±±º          ³aSK     // Vetor Sku                                        º±±
±±º          ³[1]     // Codigo da Sku        [*] index                   º±±
±±º          ³[2]     // Quantidade vendida   [S]                         º±±
±±º          ³[3]     // Quantidade de Apanhes[S+1]                       º±±
±±º          ³[4]     // Custo Stander                                    º±±
±±º          ³[5]     // Codigo Simil                                     º±±
±±º          ³[6]     // Codigo Eis                                       º±±
±±º          ³[7]     // Metodo: 1. Ponto de Pedido                       º±±
±±º          ³                   2. Estoque Maximo                        º±±
±±º          ³                   3. Estoque Minimo                        º±±
±±º          ³[8]     // Fator de Seguranca                               º±±
±±º          ³[9]     // Sistema de Tratamento                            º±±
±±º          ³                                                            º±±
±±º          ³aEIS    // Vetor Simil + Eis + Sku                          º±±
±±º          ³[1]     // Codigo Simil         [*] index                   º±±
±±º          ³[2]     // Codigo da Sku        [*]                         º±±
±±º          ³[3]     // Codigo do Eis        [*]                         º±±
±±º          ³                                                            º±±
±±º          ³aSimil  // Vetor Simil + Eis                                º±±
±±º          ³[1]     // Codigo do Simil      [*] index                   º±±
±±º          ³[2]     // Codigo do Eis        [*]                         º±±
±±º          ³[3]     // Quantidade Vendida   [S]                         º±±
±±º          ³[4]     // Quantidade de Apanhes[S]                         º±±
±±º          ³[5]     // Custo Stander        [S]                         º±±
±±º          ³[6]     // Sku Envolvidas       [S com base na aEis]        º±±
±±º          ³[7]     // Metodo: 1. Ponto de Pedido                       º±±
±±º          ³                   2. Estoque Maximo                        º±±
±±º          ³                   3. Estoque Minimo                        º±±
±±º          ³[8]     // Fator de Seguranca                               º±±
±±º          ³[9]     // Sistema de Tratamento                            º±±
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PrVetor(cCodiSku,nQuantid,nCustStd,cCdSimil,cCodiEis,aSKU,aEIS,aSimil,cClassi)
Local nPosSku   := 0
Local nPosEis   := 0
Local nPosSimil := 0
Local nSkuEnvol := 0
Local cMetodo   := ""
Local nFatEstS  := 0
Local cSistema  := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿           
//³ Prerrogativas para continuar                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("Z10")
DbSetOrder(1)
If  !DbSeek(xFilial("Z10")+cCodiEis) 
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no SZH , SZQ , SZG                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SZH")                 // Arvore de Encaminhamento
DbSetOrder(2)                       // Filial + ZH_AUXILIA
If DbSeek(xFilial("SZH")+cClassi)
	cMetodo := SZH->ZH_CODMET        //Classificacao: 1. Ponto de Pedido
	// 	                                               2. Estoque Maximo
	//		                                           3. Estoque Minimo
	//                            	                   4. Por encomenta (NAO SERA UTILIZADO P/ MULTITEK)
	DbSelectArea("SZQ")              // Distribuicao Normal
	DbSetOrder(1)                    // Filial + ZQ_CODIGO
	If DbSeek(xFilial("SZQ")+SZH->ZH_CODDN)
		nFatEstS := SZQ->ZQ_FATSEG
	Endif
	
	DbSelectArea("SZG")              // Metodo
	DbSetOrder(1)                    // Filial + ZG_CODMET  
	If DbSeek(xFilial("SZG")+SZH->ZH_CODMET) 
		cSistema := SZG->ZG_SISTEMA
	Endif
	
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicionando itens a Matriz 1 -  Nome aSku   - Busca   aScan[Sku]          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosSku  := aScan( aSKU , {|x| x[1] == cCodiSku })

if nPosSku = 0
	AADD(aSKU ,;  
	{ cCodiSku,;          // Codigo Sku
	nQuantid  ,;          // Quantidade Vendida
	1 ,;                  // Quantidade de Apanhes
	nCustStd ,;           // Custo Stander
	cCdSimil ,;           // Codigo Simil
	cCodiEis ,;           // Codigo Eis
	cMetodo ,;            // Classificacao: 1. Ponto de Pedido/2. Estoque Maximo/3. Estoque Minimo
	nFatEstS,;            // Fator de Seguranca
	cSistema })           // Sistema de Tratamento
Else
	aSku[nPosSku][2] += nQuantid
	aSku[nPosSku][3] += 1
Endif
  

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicionando itens a Matriz 2 -  Nome aEis   - Busca  aScan[Simil+Sku+Eis] ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosEis := aScan( aEis , {|x| x[1]+x[2]+x[3] == cCdSimil + cCodiSku + cCodiEis })

if nPosEis = 0
	AADD(aEis ,; 
	{ cCdSimil ,;          // Codigo Simil
	cCodiSku ,;            // Codigo Sku
	cCodiEis })            // Codigo Eis
Endif
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicionando itens a Matriz 3 -  Nome aSimil -  Busca  aScan[Simil+Eis]    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosSimil := aScan( aSimil , {|x| x[1]+x[2] == cCdSimil + cCodiEis })
//nSkuEnvol := iif(nPosEis = 0 , 1 , 0 )

if nPosSimil = 0
	AADD(aSimil ,;
	{ cCdSimil ,;        // Codigo Simil
	cCodiEis ,;          // Codigo Eis
	nQuantid ,;          // Quantidade Vendida
	1 ,;                 // Quantidade de Apanhes
	nCustStd * nQuantid ,;          // Custo Stander
	nSkuEnvol,;          // Sku Envolvidas
	cMetodo ,;           // Classificacao: 1. Ponto de Pedido/2. Estoque Maximo/3. Estoque Minimo
	nFatEstS,;           // Fator de Seguranca
	cSistema })          // Sistema de Tratamento
Else
	aSimil[nPosSimil][3] += nQuantid
	aSimil[nPosSimil][4] += 1
	aSimil[nPosSimil][5] += nCustStd * nQuantid // VICENTE AQUI MUDOU
 //	aSimil[nPosSimil][6] += nSkuEnvol
Endif

Return
  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcSZA   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Com base na MATRIZ aSku iremos efetuar a gravacao do SZA    º±±
±±º          ³                                                            º±±
±±º          ³aSK     // Vetor Sku                                        º±±
±±º          ³[1]     // Codigo da Sku        [*] index                   º±±
±±º          ³[2]     // Quantidade vendida   [S]                         º±±
±±º          ³[3]     // Quantidade de Apanhes[S+1]                       º±±
±±º          ³[4]     // Custo Stander                                    º±±
±±º          ³[5]     // Codigo Simil                                     º±±
±±º          ³[6]     // Codigo Eis                                       º±±
±±º          ³[7]     // Metodo: 1. Ponto de Pedido                       º±±
±±º          ³                   2. Estoque Maximo                        º±±
±±º          ³                   3. Estoque Minimo                        º±±
±±º          ³[8]     // Fator de Seguranca                               º±±
±±º          ³[9]     // Sistema de Tratamento                            º±±
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProcSZA(aSKU)
Local nPosSku      := 0
Local cChave       := ""
Local lAppend      := .T.
                    

For nPosSku := 1 to Len(aSKU)

    cChave := aSku[nPosSku][1] 

	DbSelectArea("SB1")
	DbSetOrder(1)                        // Filial+Sku
	if DbSeek(xFilial("SB1")+cChave)


     	DbSelectArea("SZA")
     	DbSetOrder(2)                   // Filial+Ano+Mes+Sku
        If DbSeek( xFilial("SZA") + cAno + cMes + cChave)
           lAppend := .F.              // Reprocessamento
        Else
           lAppend := .T.              // Fechamento
        Endif

		RecLock("SZA",lAppend)  

        If lAppend                     // Fechamento

		   SZA->ZA_FILIAL   := xFilial("SZA")
		   SZA->ZA_ANO      := STR(YEAR(dFimProc),4)
		   SZA->ZA_MES      := STRZERO(MONTH(dFimProc),2)
		   SZA->ZA_SKU      := aSku[nPosSku][1]                // Codigo da Sku
 		   SZA->ZA_SIMIL    := aSku[nPosSku][5]                 // Codigo Simil
		   SZA->ZA_EIS01    := Substr(aSku[nPosSku][6],01,2)   // Codigo Eis
		   SZA->ZA_EIS02    := Substr(aSku[nPosSku][6],03,2)
		   SZA->ZA_EIS03    := Substr(aSku[nPosSku][6],05,2)
		   SZA->ZA_EIS04    := Substr(aSku[nPosSku][6],07,2)
		   SZA->ZA_EIS05    := Substr(aSku[nPosSku][6],09,2)
		   SZA->ZA_EIS06    := Substr(aSku[nPosSku][6],11,2)
		   SZA->ZA_EIS07    := Substr(aSku[nPosSku][6],13,2)
		   SZA->ZA_EIS08    := Substr(aSku[nPosSku][6],15,2)
		   SZA->ZA_EIS09    := Substr(aSku[nPosSku][6],17,2)
		   SZA->ZA_EIS10    := Substr(aSku[nPosSku][6],19,2)

		   SZA->ZA_ORIGEM   := SB1->B1_X_NC_IM
		   SZA->ZA_GIROQ    := SB1->B1_X_GIROQ
		   SZA->ZA_ABC      := SB1->B1_X_ABC
		   SZA->ZA_PQR      := SB1->B1_X_PQR
		   SZA->ZA_NEOIL    := SB1->B1_X_NEOIL
		   SZA->ZA_123      := SB1->B1_X_123
		   SZA->ZA_XYZ      := SB1->B1_X_XYZ
		   SZA->ZA_LMN      := SB1->B1_X_LMN  //Giro class
		   SZA->ZA_LEAD     := SB1->B1_X_LT
		   SZA->ZA_CODREF   := SB1->B1_X_REFER
		   SZA->ZA_SUFIXO   := SB1->B1_X_SUFIX
		   SZA->ZA_MARCA    := SB1->B1_X_MARCA
           
           // ??? Nao e importante guardar estas informacoes no SZA
           //     nao estao presentes  na Modelagem.
           //			SB1->B1_X_TMEA := aSimil[nPosSimil][13]  //[13] Tmea             ProcVetor ()
           //			SB1->B1_X_DESVP:=  aSimil[nPosSimil][15]  //[15] Desvio Padrao    ProcVetor ()

        Endif

		SZA->ZA_QTDSAI   := aSku[nPosSku][2]                // Qtd. Vendida
		SZA->ZA_QTDAPA   := aSku[nPosSku][3]                // Qtd. de Apanhes
		SZA->ZA_VLRCM    := aSku[nPosSku][4]                // Custo Stander da SKU
		SZA->ZA_METDIM   := aSku[nPosSku][7]                // Metodo
		SZA->ZA_SIST_TR  := aSku[nPosSku][9]                // Sistema de Tratamento

		MsUnlock()
		
	Endif
	
Next
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcSZ9   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Com base na MATRIZ aSimil iremos efetuar a gravacao do SZ9  º±±
±±º          ³                                                            º±±
±±º          ³aSimil  // Vetor Simil + Eis                                º±±
±±º          ³[1]     // Codigo do Simil       [*] index                  º±±
±±º          ³[2]     // Codigo do Eis         [*]                        º±±
±±º          ³[3]     // Quantidade Vendida                               º±±
±±º          ³[4]     // Quantidade de Apanhes                            º±±
±±º          ³[5]     // Custo Stander                                    º±±
±±º          ³[6]     // Sku Envolvidas                                   º±±
±±º          ³[7]     // Metodo: 1. Ponto de Pedido                       º±±
±±º          ³                   2. Estoque Maximo                        º±±
±±º          ³                   3. Estoque Minimo                        º±±
±±º          ³[8]     // Fator de Seguranca                               º±±
±±º          ³[9]     // Sistema de Tratamento                            º±±
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProcSZ9(aSimil)
Local nPosSimil := 0
Local cClassi := ""
Local cMetodo := ""
Local nFatEstS:= ""
Local cSistema:= ""
Local cChave  := ""
Local lAppend      := .T.


For nPosSimil := 1 to Len(aSimil)

    cChave  := aSimil[nPosSimil][1]+aSimil[nPosSimil][2] // Simil + Eis
	
	DbSelectArea("SB1")
    DbOrderNickname("B1SIMEIS")         // Filial+Simil+Eis
	If  DbSeek(xFilial("SB1")+cChave ) 

     	DbSelectArea("SZ9")
     	DbSetOrder(2)                   // Filial+Ano+Mes+Simil+Eis
	    If DbSeek( xFilial("SZ9") + cAno + cMes + cChave)
           lAppend := .F.              // Reprocessamento
        Else
           lAppend := .T.              // Fechamento
        Endif

		RecLock("SZ9",lAppend)  

        If lAppend

		   SZ9->Z9_FILIAL   := xFilial("SZ9")
		   SZ9->Z9_ANO      := STR(YEAR(dFimProc),4)
		   SZ9->Z9_MES      := STRZERO(MONTH(dFimProc),2)
		   SZ9->Z9_SIMIL    := aSimil[nPosSimil][1]                  // Codigo Simil
		   SZ9->Z9_EIS01    := Substr(aSimil[nPosSimil][2],01,2)     // Codigo Eis
		   SZ9->Z9_EIS02    := Substr(aSimil[nPosSimil][2],03,2)
		   SZ9->Z9_EIS03    := Substr(aSimil[nPosSimil][2],05,2)
		   SZ9->Z9_EIS04    := Substr(aSimil[nPosSimil][2],07,2)
		   SZ9->Z9_EIS05    := Substr(aSimil[nPosSimil][2],09,2)
		   SZ9->Z9_EIS06    := Substr(aSimil[nPosSimil][2],11,2)
		   SZ9->Z9_EIS07    := Substr(aSimil[nPosSimil][2],13,2)
		   SZ9->Z9_EIS08    := Substr(aSimil[nPosSimil][2],15,2)
		   SZ9->Z9_EIS09    := Substr(aSimil[nPosSimil][2],17,2)
		   SZ9->Z9_EIS10    := Substr(aSimil[nPosSimil][2],19,2) 
		   SZ9->Z9_ORIGEM   := SB1->B1_X_NC_IM
		   SZ9->Z9_ABC      := SB1->B1_X_ABC
		   SZ9->Z9_PQR      := SB1->B1_X_PQR
		   SZ9->Z9_NEOIL    := SB1->B1_X_NEOIL
		   SZ9->Z9_123      := SB1->B1_X_123
		   SZ9->Z9_XYZ      := SB1->B1_X_XYZ
		   SZ9->Z9_LMN      := SB1->B1_X_LMN                  //Giro class
		   SZ9->Z9_GIROQ    := SB1->B1_X_GIROQ
		   SZ9->Z9_LEAD     := SB1->B1_X_LT
		
		Endif
		
		
        // Observacao / Observacao / Observacao / Observacao / Observacao
        // A informacao abaixo e apenas para mostrar como chegamos ao
        // conteudo do campo SZ9->Z9_VLRCM (Custo Medio)
        // aSimil[nPosSimil][3] += Qtde de Saidas (SD2 + SD3)
        // aSimil[nPosSimil][5] += aSimil[nPosSimil][3] * B1_X_CTSTD
		SZ9->Z9_VLRCM    := aSimil[nPosSimil][5] / aSimil[nPosSimil][3] 
		SZ9->Z9_QTDSAI   := aSimil[nPosSimil][3]                  // Qtd Vendida
		SZ9->Z9_QTDAPA   := aSimil[nPosSimil][4]                  // Qtd de Apanhes
		SZ9->Z9_METDIM   := aSimil[nPosSimil][7]                  // SZH - Metodo
		SZ9->Z9_SIST_TR  := aSimil[nPosSimil][9]                  // SZG - Sistema de Tratamento

		MsUnlock()

	Endif
	
Next

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcSB2   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Saldos em Estoque                                           º±±
±±º          ³                                                            º±±
±±º          ³Daqui por diante tudo ocorre por Simil + Eis                º±±
±±º          ³                                                            º±±
±±º          ³aSKU     // Vetor Sku                                       º±±
±±º          ³[01]     // Codigo da Sku       [*] index                   º±±
±±º          ³[02]     // Malha - Saldo Dispon + PC (Item Nao Compra)     º±±
±±º          ³[03]     // Malha - Saldo Dispon + PC (Item Compra)         º±±
±±º          ³[04]     // Malha - Saldo Empenhado                         º±±
±±º          ³[05]     // Malha - Saldo Disponivel                        º±±
±±º          ³[06]     // Matriz (Disp + PC)                              º±±
±±º          ³[07]     // Filial (Disp + PC)                              º±±
±±º          ³[08]     // Malha  (Em Poder de 3)                          º±±
±±º          ³[09]     // Malha  (3 EM Nosso Poder)                       º±±
±±º          ³[10]     // Malha  (Quantidade reservad                     º±±
±±º          ³[11]     // Malha  (Prevista entrar no est.via Compras ou Opº±±
±±º          ³[12]     // Malha  (Quant.de Ped. de Venda nao Lib.p/Faturarº±± 
±±º          ³                                                            º±±
±±º          ³aSimil   // Vetor Simil + Eis                               º±±
±±º          ³[01]     // Simil               [*] index                   º±±
±±º          ³[02]     // Eis                 [*] index                   º±±
±±º          ³[03]     // Qtde Vendida                                    º±±
±±º          ³[04]     // Custo Stander Medio                             º±±
±±º          ³[05]     // Custo Total                                     º±±
±±º          ³[06]     // Consumo                                         º±±
±±º          ³[07]     // Ocorrencias                                     º±±
±±º          ³[08]     // Perc.Class                                      º±±
±±º          ³[09]     // ABC                                             º±±
±±º          ³[10]     // Qtde de Apanhes                                 º±±
±±º          ³[11]     // PQR                                             º±±
±±º          ³[12]     // Neoil                                           º±±
±±º          ³[13]     // Tmea                                            º±±
±±º          ³[14]     // SomaSaidasPer2                                  º±±
±±º          ³[15]     // Desvio Padrao                                   º±±
±±º          ³[16]     // Class 123                                       º±±
±±º          ³[17]     // Class XYZ                                       º±±
±±º          ³[18]     // Nacimp                                          º±±
±±º          ³[19]     // LT                                              º±±
±±º          ³[20]     // LoteAut                                         º±±
±±º          ³[21]     // Ponto de Pedido                                 º±±
±±º          ³[22]     // EstSeg                                          º±±
±±º          ³[23]     // Acum. Ent.                                      º±±
±±º          ³[24]     // Acum. Sai                                       º±±
±±º          ³[25]     // Saldo                                           º±±
±±º          ³[26]     // Acum.Dif.Dias                                   º±±
±±º          ³[27]     // Acum.Saldo.Dias                                 º±±
±±º          ³[28]     // Acum.Saldo.Quad                                 º±±
±±º          ³[29]     // Giro                                            º±±
±±º          ³[30]     // ClassGiro                                       º±±
±±º          ³[31]     // Quantidade Lote Praticado                       º±±
±±º          ³[32]     // Malha - Disp + PC (Item de Compra)              º±±
±±º          ³[33]     // Malha - Dipo + PC (Item nao Compra)             º±±
±±º          ³[34]     // Malha - Empenhado (Item nao Compra)             º±±
±±º          ³[35]     // Malha - Saldo Disponivel                        º±±
±±º          ³[36]     // Matriz (Disp + PC)                              º±±
±±º          ³[37]     // Filial (Disp + PC)                              º±±
±±º          ³[38]     // Malha  (Em Poder de 3)                          º±±
±±º          ³[39]     // Malha  (3 EM Nosso Poder)                       º±±
±±º          ³[40]     // Malha  (Quantidade reservad                     º±±
±±º          ³[41]     // Malha  (Prevista entrar no est.via Compras ou Opº±±
±±º          ³[42]     // Malha  (Quant.de Ped. de Venda nao Lib.p/Faturarº±± 
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProcSB2(aSimil,aSKU)
Local nPosSimil := 0
Local aSaldoEst := {}

Local cCdSimil :=  ""  // Simil
Local cCodiEis :=  ""  // Eis
Local nQuantid :=  0   // Qtde Vendida
Local nCstdMed :=  0   // Custo Stander Medio
Local nCstdTot :=  0   // Custo Total
Local nConsumo :=  0   // Consumo
Local nOcorren :=  0   // Ocorrencias
Local nPerClas :=  0   // Perc.Class
Local cABC     :=  ""  // ABC
Local nApanhes :=  0   // Qtde de Apanhes
Local cPQR     :=  ""  // PQR
Local cNEOIL   :=  ""  // Neoil
Local nTMEA    :=  0   // Tmea
Local nSaidPe2 :=  0   // SomaSaidasPer2
Local nDesPadr :=  0   // Desvio Padrao
Local c123     :=  ""  // Class 123
Local cXYZ     :=  ""  // Class XYZ
Local cNacimp  :=  ""  // Nacimp
Local nLT      :=  0   // LT
Local nLoteAut :=  0   // LoteAut
Local nPonto   :=  0   // Ponto de Pedido
Local nEstSegu := 0  // EstSeg
Local nAcumEnt :=  0   // Acum. Ent.
Local nAcumSai :=  0   // Acum. Sai
Local nSaldo   :=  0   // Saldo
Local nAcumDif :=  0   // Acum.Dif.Dias
Local nAcumDias:=  0   // Acum.Saldo.Dias
Local nAcumQuad:=  0   // Acum.Saldo.Quad
Local nGiro    :=  0   // Giro
Local cClasGiro:=  ""  // ClassGiro
Local nPedComh:=  0    // Qtde Lote Praticado

Local nIcSldMalh := 0  //  Saldo Malha ( Disponivel + PC) Item de Compra
Local nNCSldMalh := 0  //  Saldo Malha ( Disponivel + PC) Item nao Compra
Local nSldMatriz := 0  //  Matriz (Disp + PC)
Local nSldFilial := 0  //  Filial (Disp + PC)

Local nSldDispo  := 0  //  Malha  (Saldo Disponivel)
Local nSldPoder3 := 0  //  Malha  (Nosso em Poder de Terceiros)
Local nSld3Em    := 0  //  Malha  (Terceiros em nosso poder)
Local nSldEmpen  := 0  //  Malha  (Quantidade Empenhada) 
Local nSldReserv := 0  //  Malha  (Quantidade reservada)
Local nSldSalPed := 0  //  Malha  (Prevista entrar no estoque via Compras ou Op) 
Local nSldQpedVe := 0  //  Malha  (Quant.de Pedidos de Venda nao Lib.p/Faturar 



Local cItemComp  := "" 
Local nPosSku    := 0          

aSimil  := {}          // Apenas por seguranca. Ja Liberada Anteriormente
aSKU    := {}                         

DbSelectArea("SB1")                    
DbGotop() 

While !SB1->(EOF())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados para processamento das Matrizes aSku,aEis,aSimil                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCdSimil :=  SB1->B1_X_SIMIL
	cCodiEis :=  SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+;
                     	B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)
	cABC     :=  SB1->B1_X_ABC
	cPQR     :=  SB1->B1_X_PQR
	cNEOIL   :=  SB1->B1_X_Neoil
	c123     :=  SB1->B1_X_123
	cXYZ     :=  SB1->B1_X_XYZ
	cNacimp  :=  SB1->B1_X_NC_IM
	nLT      :=  SB1->B1_X_LT
	cItemComp:=  SB1->B1_X_ITCPR

    nApanhe  :=  SB1->B1_X_APN_A  //Apanhe
    nQtdSai  :=  SB1->B1_X_QTDSA  //Quantidade de Saidas
    nVlrCusto:=  SB1->B1_X_VLRCM  //Valor do Custo
	
	
    // Observacao / Observacao / Observacao / Observacao / Observacao
	// Apos conversa com Mauricio definimos que iriamos apagar o cod.
	// Eis dos produtos que apresentem este tipo de problema mostrando 
	// mensagem de alerta para o usuario no termino do processamento.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Prerrogativas para continuar                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("Z10")
	DbSetOrder(1)
	If  !DbSeek(xFilial("Z10")+cCodiEis)
		DbSelectArea("SB1")
        /* ??? Liberar somente apos instabilizacao da base Oficial pois poderia
        /      comprometer os dados do SB1.
        /      Exemplo Importou o SB1 e esqueceu de importar o Z10.
        Reclock("SB1",.F.)
        SB1->B1_X_EIS01:=Space(2)
        SB1->B1_X_EIS02:=Space(2)
        SB1->B1_X_EIS03:=Space(2)
        SB1->B1_X_EIS04:=Space(2)
        SB1->B1_X_EIS05:=Space(2)
        SB1->B1_X_EIS06:=Space(2)
        SB1->B1_X_EIS07:=Space(2)
        SB1->B1_X_EIS08:=Space(2)
        SB1->B1_X_EIS09:=Space(2)
        SB1->B1_X_EIS10:=Space(2)
        MsUnlock()
        */
		SB1->(DbSkip())
		Loop
	Endif
	
	//
	// Define Saldos em estoque
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Parametros : Codigo do Produto                                            ³
	//³                                                                          ³
	//³Retorna:                                                                  ³
	//³                                                                          |
	//³[01]     MALHA                                                            ³
	//³[01][01] SaldoSb2() // Saldo Disponivel                                   ³
	//³[01][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
	//³[01][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
	//³[01][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
	//³[01][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
	//³[01][06] B2_QEMP    // Quantidade Empenhada                               ³
	//³[01][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
	//³[01][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
	//³[01][09] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
	//³                                                                          |
	//³[02]     MATRIZ                                                           ³
	//³[02][01] SaldoSb2() // Saldo Disponivel                                   ³
	//³[02][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
	//³[02][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
	//³[02][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
	//³[02][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
	//³[02][06] B2_QEMP    // Quantidade Empenhada                               ³
	//³[02][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
	//³[02][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
	//³[02][09] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
	//³                                                                          |
	//³                                                                          |
	//³[03]     FILIAL                                                           ³
	//³[03][01] SaldoSb2() // Saldo Disponivel                                   ³
	//³[03][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
	//³[03][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
	//³[03][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
	//³[03][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
	//³[03][06] B2_QEMP    // Quantidade Empenhada                               ³
	//³[03][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
	//³[03][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
	//³[03][09] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSaldoEst  := U_SaldoSb2(SB1->B1_COD)  // MFATC12.PRW
	
    nSldMatriz := aSaldoEst[02][09]        //  Matriz (Disp + PC)
    nSldFilial := aSaldoEst[03][09]        //  Filial (Disp + PC)

    nSldEmpen  := aSaldoEst[01][06]        //  Malha  (Quantidade Empenhada) 
    nSldDispo  := aSaldoEst[01][01]        //  Malha  (Saldo Disponivel)
    nSldPoder3 := aSaldoEst[01][02]        //  Malha  (Nosso em Poder de Terceiros)
    nSld3Em    := aSaldoEst[01][03]        //  Malha  (Terceiros em nosso poder)
    nSldEmpen  := aSaldoEst[01][06]        //  Malha  (Quantidade Empenhada) 
    nSldReserv := aSaldoEst[01][05]        //  Malha  (Quantidade reservada)
    nSldSalPed := aSaldoEst[01][07]        //  Malha  (Prevista entrar no estoque via Compras ou Op) 
    nSldQpedVe := aSaldoEst[01][08]        //  Malha  (Quant.de Pedidos de Venda nao Lib.p/Faturar 

	nNCSldMalh := 0
	nIcSldMalh := 0
	if  cItemComp = "N"
		nNCSldMalh := aSaldoEst[01][09]   //  Malha  (Disponivel + Previsto PC)
	Else                                              
		nIcSldMalh := aSaldoEst[01][09]   //  Malha  (Disponivel + Previsto PC)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adicionando itens a Matriz 1 por Sku dos Saldo em estoque                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPosSku  := aScan( aSKU , {|x| x[1] == cCodiSku })
	
	if nPosSku = 0
		AADD(aSKU ,;
		{ cCodiSku,;        // Codigo Sku
		nIcSldMalh ,;       // Malha  (Disp + PC) - Item de Compra
		nNcSldMalh ,;       // Malha  (Disp + PC) - Item nao Compra
		nSldEmpen,;         // Malha  (Empenhado)
		nSldDispo,;         // Malha  (Disp)
        nSldMatriz,;        // Matriz (Disp + PC)
        nSldFilial,;        // Filial (Disp + PC)
        nSldPoder3,;        // Malha  (Em Poder de 3)
        nSld3Em,;           // Malha  (3 EM Nosso Poder)
        nSldReserv,;        // Malha  (Quantidade reservada)
        nSldSalPed,;        // Malha  (Prevista entrar no estoque via Compras ou Op) 
        nSldQpedVe})        // Malha  (Quant.de Pedidos de Venda nao Lib.p/Faturar 
	Else
		// Malha (Disp + PC) - Item de Compra
		aSKU[nPosSku][02] += nIcSldMalh
		// Malha (Disp + PC) - Item nao Compra
		aSKU[nPosSku][03] += nNcSldMalh
        // Malha (Empenhado)
     	aSKU[nPosSku][04] += nSldEmpen
        // Malha (Disponivel)
     	aSKU[nPosSku][05] += nSldDispo
        // Matriz (Disp + PC)    	
     	aSKU[nPosSku][06] += nSldMatriz   
        // Filial (Disp + PC)
     	aSKU[nPosSku][07] += nSldFilial
        // Malha  (Em Poder de 3)
     	aSKU[nPosSku][08] += nSldPoder3 
        // Malha  (3 EM Nosso Poder)
     	aSKU[nPosSku][09] += nSld3Em 
        // Malha  (Quantidade reservada)
     	aSKU[nPosSku][10] += nSldReserv 
        // Malha  (Prevista entrar no estoque via Compras ou Op) 
     	aSKU[nPosSku][11] += nSldSalPed
        // Malha  (Quant.de Pedidos de Venda nao Lib.p/Faturar
      	aSKU[nPosSku][12] += nSldQpedVe
  	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adicionando itens a Matriz 3 -  Nome aSimil -  Busca  aScan[Simil+Eis]    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPosSimil := aScan( aSimil , {|x| x[1]+x[2] == cCdSimil + cCodiEis })
	
	if nPosSimil = 0
		AADD(aSimil ,;
		{ cCdSimil,;      // Codigo Simil     (B1_X_SIMIL)
		cCodiEis,;        // Codigo Eis       (B1_X_EIS01..B1_X_EIS10)
		nQuantid,;        // Qtde Vendida     (SZ9->Z9_QTDSAI)
		nCstdMed,;        // Custo Stander Medio(Custo Total / Qtde Vendida )
		nCstdTot,;        // Custo Total      (Z9_QTDSAI * Z9_VLRCM)
		nConsumo,;        // Consumo          (Qtde Vendida / Numero de Ocorrencias)
		nOcorren,;        // Ocorrencias      (+1 total de Meses Processados no SZ9)
		nPerClas,;        // Perc.Class       ProcVetor ()
		cABC    ,;        // ABC              ProcVetor ()
		nApanhes,;        // Qtde de Apanhes  (Z9_QTDAPA)
		cPQR    ,;        // PQR              ProcVetor ()
		cNEOIL  ,;        // Neoil            ProcVetor ()
		nTMEA   ,;        // Tmea             ProcVetor ()
		nSaidPe2,;        // SomaSaidasPer2   (Z9_QTDSAI * Z9_QTDSAI)
		nDesPadr,;        // Desvio Padrao    ProcVetor ()
		c123    ,;        // Class 123        (B1_X_123)
		cXYZ    ,;        // Class XYZ        (B1_X_XYZ)
		cNacimp ,;        // Nacimp           (B1_X_NC_IM)
		nLT     ,;        // LT               (B1_X_LT)
		nLoteAut,;        // LoteAut           ProcVetor ()
		nPonto  ,;        // Ponto de Pedido Aut ProcVetor ()
		nEstSegu,;        // EstSeg            ProcVetor ()
		nAcumEnt,;        // Acum. Ent.        ??? Posicoes Vazias
		nAcumSai,;        // Acum. Sai         ??? Posicoes Vazias
		nSaldo  ,;        // Saldo             ??? Posicoes Vazias
		nAcumDif,;        // Acum.Dif.Dias     ??? Posicoes Vazias
		nAcumDias,;       // Acum.Saldo.Dias   ??? Posicoes Vazias
		nAcumQuad,;       // Acum.Saldo.Quad   ??? Posicoes Vazias
		nGiro    ,;       // Giro
		cClasGiro,;       // ClassGiro
		nPedComh,;        // Quantidade Lote Praticado
		nIcSldMalh ,;     // Saldo Malha (Disponivel + PC)
		nNcSldMalh,;      // Saldo Malha (Disponivel + Pc)
		nSldEmpen,;       // Malha  (Empenhado)
		nSldDispo,;       // Malha  (Disp)
        nSldMatriz,;      // Matriz (Disp + PC)
        nSldFilial,;      // Filial (Disp + PC)
        nSldPoder3,;      // Malha  (Em Poder de 3)
        nSld3Em,;         // Malha  (3 EM Nosso Poder)
        nSldReserv,;      // Malha  (Quantidade reservada)
        nSldSalPed,;      // Malha  (Prevista entrar no estoque via Compras ou Op) 
        nSldQpedVe})      // Malha  (Quant.de Pedidos de Venda nao Lib.p/Faturar 


    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    	//³Quando estamos executando a Geracao da Planilha geracao do SZ7 e SZ8      ³
    	//³utilizo esta funcao para evitar a leitura do SZ9 Historico.               ³
    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If Upper(Funname())= "#MESTC02"     // Geracao da Planilha
		
      	   PrecheVetor(@aSimil,@nAcumCust,nPosSimil,cCdSimil,cCodiEis,nApanhe,nQtdSai,nVlrCusto) 

        Endif

	Else

		// Malha (Disp + PC) - Item de Compra
		aSimil[nPosSimil][32] += nIcSldMalh
		// Malha (Disp + PC) - Item nao Compra
		aSimil[nPosSimil][33] += nNcSldMalh
        // Malha (Empenhado)
     	aSimil[nPosSimil][34] += nSldEmpen
        // Malha (Disponivel)
     	aSimil[nPosSimil][35] += nSldDispo
        // Matriz (Disp + PC)    	
     	aSimil[nPosSimil][36] += nSldMatriz   
        // Filial (Disp + PC)
     	aSimil[nPosSimil][37] += nSldFilial
        // Malha  (Em Poder de 3)
     	aSimil[nPosSimil][38] += nSldPoder3 
        // Malha  (3 EM Nosso Poder)
     	aSimil[nPosSimil][39] += nSld3Em 
        // Malha  (Quantidade reservada)
     	aSimil[nPosSimil][40] += nSldReserv 
        // Malha  (Prevista entrar no estoque via Compras ou Op) 
     	aSimil[nPosSimil][41] += nSldSalPed
        // Malha  (Quant.de Pedidos de Venda nao Lib.p/Faturar
      	aSimil[nPosSimil][42] += nSldQpedVe

	Endif

	DbSelectArea("SB1")
	SB1->(DbSkip())
	
Enddo

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcSZ9   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processa historico conforme meses informados na             º±±
±±º          ³parametrizacao.                                             º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³aSimil   // Vetor Simil + Eis                               º±±
±±º          ³[01]     // Simil               [*] index                   º±±
±±º          ³[02]     // Eis                 [*] index                   º±±
±±º          ³[03]     // Qtde Vendida                                    º±±
±±º          ³[04]     // Custo Stander Medio                             º±±
±±º          ³[05]     // Custo Total                                     º±±
±±º          ³[06]     // Consumo                                         º±±
±±º          ³[07]     // Ocorrencias                                     º±±
±±º          ³[08]     // Perc.Class                                      º±±
±±º          ³[09]     // ABC                                             º±±
±±º          ³[10]     // Qtde de Apanhes                                 º±±
±±º          ³[11]     // PQR                                             º±±
±±º          ³[12]     // Neoil                                           º±±
±±º          ³[13]     // Tmea                                            º±±
±±º          ³[14]     // SomaSaidasPer2                                  º±±
±±º          ³[15]     // Desvio Padrao                                   º±±
±±º          ³[16]     // Class 123                                       º±±
±±º          ³[17]     // Class XYZ                                       º±±
±±º          ³[18]     // Nacimp                                          º±±
±±º          ³[19]     // LT                                              º±±
±±º          ³[20]     // LoteAut                                         º±±
±±º          ³[21]     // Ponto de Pedido                                 º±±
±±º          ³[22]     // EstSeg                                          º±±
±±º          ³[23]     // Acum. Ent.                                      º±±
±±º          ³[24]     // Acum. Sai                                       º±±
±±º          ³[25]     // Saldo                                           º±±
±±º          ³[26]     // Acum.Dif.Dias                                   º±±
±±º          ³[27]     // Acum.Saldo.Dias                                 º±±
±±º          ³[28]     // Acum.Saldo.Quad                                 º±±
±±º          ³[29]     // Giro                                            º±±
±±º          ³[30]     // ClassGiro                                       º±±
±±º          ³[31]     // Quantidade Lote Praticado                       º±±
±±º          ³[32]     // Malha - Disp + PC (Item de Compra)              º±±
±±º          ³[33]     // Malha - Dipo + PC (Item nao Compra)             º±±
±±º          ³[34]     // Malha - Empenhado (Item nao Compra)             º±±
±±º          ³[35]     // Malha - Saldo Disponivel                        º±±
±±º          ³[36]     // Matriz (Disp + PC)                              º±±
±±º          ³[37]     // Filial (Disp + PC)                              º±±
±±º          ³[38]     // Malha  (Em Poder de 3)                          º±±
±±º          ³[39]     // Malha  (3 EM Nosso Poder)                       º±±
±±º          ³[40]     // Malha  (Quantidade reservad                     º±±
±±º          ³[41]     // Malha  (Prevista entrar no est.via Compras ou Opº±±
±±º          ³[42]     // Malha  (Quant.de Ped. de Venda nao Lib.p/Faturarº±± 
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CalcSZ9(aSimil,nAcumCust) // Processa o Historico conforme meses informados na Parametricacao

Local cAno      := str(Year(dIniHis),4)
Local cMes      := strzero(month(dIniHis),2)
Local nPosSimil := 0
Local cCdSimil  := ""
Local cCodiEis  := ""
Local nApanhe   := 0    //Apanhe
Local nQtdSai   := 0    //Quantidade de Saidas
Local nVlrCusto := 0    //Valor do Custo

	
DbSelectArea("SZ9")
DbSetOrder(2)                // Filial+Mes+Ano+Simil+Eis
SET SOFTSEEK ON
DbSeek( xFilial("SZ9") + cAno + cMes ,.T.)
SET SOFTSEEK OFF

cAno  := str(Year(dFimProc),4)
cMes  := strzero(month(dFimProc),2)

While !SZ9->(Eof())
	
	// Garante o Periodo Final do Processamento
	If  SZ9->Z9_ANO + SZ9->Z9_MES > cAno + cMes
		Exit
	Endif
	
	cCdSimil  :=  SZ9->Z9_SIMIL
	cCodiEis  :=  SZ9->(Z9_EIS01+Z9_EIS02+Z9_EIS03+Z9_EIS04+Z9_EIS05+;
                     	 Z9_EIS06+Z9_EIS07+Z9_EIS08+Z9_EIS09+Z9_EIS10)
	nApanhe   :=  SZ9->Z9_QTDAPA   //Apanhe
	nQtdSai   :=  SZ9->Z9_QTDSAI   //Quantidade de Saidas
	nVlrCusto :=  SZ9->Z9_CUSTO    //Valor do Custo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adicionando itens a Matriz 3 -  Nome aSimil -  Busca  aScan[Simil+Eis]    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPosSimil := aScan( aSimil , {|x| x[1]+x[2] == cCdSimil + cCodiEis })
	
	PrechVetor(@aSimil,@nAcumCust,nPosSimil,cCdSimil,cCodiEis,nApanhe,nQtdSai,nVlrCusto)
	
	SZ9->(DbSkip())
	
Enddo

Return(nAcumCust)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrechVetorºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava as informacoes do HISTORICO no Vetor as informacoes   º±±
±±º          ³do Historico podem vir do SZ9 durante o fechamento da       º±±
±±º          ³Planilha e do SB1 durante a Geracao da PGMM tendo como      º±±
±±º          ³objetivo diminuir o tempo de processamento.                 º±±
±±º          ³                                                            º±±
±±º          ³As Variaveis @aSimil e @nAcumCust sao as responsaveis em    º±±
±±º          ³guardar as informacoes.                                     º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrechVetor(aSimil,nAcumCust,nPosSimil,cCdSimil,cCodiEis,nApanhe,nQtdSai,nVlrCusto)
		        
// Apenas por Seguranca.		
if nPosSimil = 0
   Return
Endif          
			
// Quantidade de Apanhes      (Quantidade de Apanhes)(Z9_APANHE)
aSimil[nPosSimil][10] += nApanhe
// Quantidade Vendida         (Quantidade de Saidas) (Z9_QTDSAI)
aSimil[nPosSimil][03] += nQtdSai              
// Custo Total                (Quantidade de Saidas * Valor Custo)(Z9_QTDSAI * Z9_VLRCM)
aSimil[nPosSimil][05] += nQtdSai * nVlrCusto
// Ocorrencias                (Numero de Ocorrencias)
aSimil[nPosSimil][07] += 1
// Custo Stander Medio        (Custo Total / Qtde Vendida )
aSimil[nPosSimil][04] += aSimil[nPosSimil][05] / aSimil[nPosSimil][03]
// Consumo Medio              (Quantidade Total / Qtde de Ocorrencias)
aSimil[nPosSimil][06] += aSimil[nPosSimil][03] / aSimil[nPosSimil][07]
// Quantidade ao Quadrado     (Quantidade de Saidas elevado ao Quadrado)
aSimil[nPosSimil][14] += aSimil[nPosSimil][03] ^ 2

// Variavel Custo Total
nAcumCust += aSimil[nPosSimil][05]

Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcVetor ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processa Matriz resultado da Busca no SB1 e SZ9             º±±
±±º          ³parametrizacao.                                             º±±
±±º          ³                                                            º±±
±±º          ³aSimil   // Vetor Simil + Eis                               º±±
±±º          ³[01]     // Simil               [*] index                   º±±
±±º          ³[02]     // Eis                 [*] index                   º±±
±±º          ³[03]     // Qtde Vendida                                    º±±
±±º          ³[04]     // Custo Stander Medio                             º±±
±±º          ³[05]     // Custo Total                                     º±±
±±º          ³[06]     // Consumo                                         º±±
±±º          ³[07]     // Ocorrencias                                     º±±
±±º          ³[08]     // Perc.Class                                      º±±
±±º          ³[09]     // ABC                                             º±±
±±º          ³[10]     // Qtde de Apanhes                                 º±±
±±º          ³[11]     // PQR                                             º±±
±±º          ³[12]     // Neoil                                           º±±
±±º          ³[13]     // Tmea                                            º±±
±±º          ³[14]     // SomaSaidasPer2                                  º±±
±±º          ³[15]     // Desvio Padrao                                   º±±
±±º          ³[16]     // Class 123                                       º±±
±±º          ³[17]     // Class XYZ                                       º±±
±±º          ³[18]     // Nacimp                                          º±±
±±º          ³[19]     // LT                                              º±±
±±º          ³[20]     // LoteAut                                         º±±
±±º          ³[21]     // Ponto de Pedido                                 º±±
±±º          ³[22]     // EstSeg                                          º±±
±±º          ³[23]     // Acum. Ent.                                      º±±
±±º          ³[24]     // Acum. Sai                                       º±±
±±º          ³[25]     // Saldo                                           º±±
±±º          ³[26]     // Acum.Dif.Dias                                   º±±
±±º          ³[27]     // Acum.Saldo.Dias                                 º±±
±±º          ³[28]     // Acum.Saldo.Quad                                 º±±
±±º          ³[29]     // Giro                                            º±±
±±º          ³[30]     // ClassGiro                                       º±±
±±º          ³[31]     // Quantidade Lote Praticado                       º±±
±±º          ³[32]     // Malha - Disp + PC (Item de Compra)              º±±
±±º          ³[33]     // Malha - Dipo + PC (Item nao Compra)             º±±
±±º          ³[34]     // Malha - Empenhado (Item nao Compra)             º±±
±±º          ³[35]     // Malha - Saldo Disponivel                        º±±
±±º          ³[36]     // Matriz (Disp + PC)                              º±±
±±º          ³[37]     // Filial (Disp + PC)                              º±±
±±º          ³[38]     // Malha  (Em Poder de 3)                          º±±
±±º          ³[39]     // Malha  (3 EM Nosso Poder)                       º±±
±±º          ³[40]     // Malha  (Quantidade reservad                     º±±
±±º          ³[41]     // Malha  (Prevista entrar no est.via Compras ou Opº±±
±±º          ³[42]     // Malha  (Quant.de Ped. de Venda nao Lib.p/Faturarº±± 
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProcVetor(aSimil,nAcumCust) 

Local nX       := 0
Local nAcumAbc := 0
Local nClassi  := 0
Local cClassi  := ""
Local aSZR     := {}
Local aSZS     := {}
Local nPosSimil:= 0               

Local nFatEstS := 0
Local nTRepro  := 0
Local nLT      := 0
Local nFreqPrat:= 0
Local nEstMin  := 0
Local nConsumo := 0
Local cMetodo  := ""
Local cSistema := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faixas para Classificacao ABC                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZR")
DbGotop()
While !SZR->(EOF())
	aadd(aSZR, { SZR->CODIGO, SZR->FXINI , SZR->FXFIM })
	SZR->(DbSkip())
Enddo
aSZR := Asort(aSZR,,,{|x,y| x[2] < y[2]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faixas para Classificacao PQR, NEOIL               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZS")       //  ??? SZS->COD1 = Classificacao PQR
DbGotop()                 //  ??? SZS->COD2 = Classificacao Neoil
While !SZS->(EOF())
	aadd(aSZS, { SZS->ZS_COD1, SZS->ZS_COD2, SZS->ZS_FXINI , SZS->ZS_FXFIM })
	SZS->(DbSkip())
Enddo
aSZS := Asort(aSZS,,,{|x,y| x[2] < y[2]})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Coloca o Vetor aSimil em Ordem Decrescente com base³
//³na coluna Custo Total [5]                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSimil := Asort(aSimil,,,{|x,y| x[5] > y[5]})

For nPosSimil := 1 to Len(aSimil)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Classificacao ABC                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Somatoria da Coluna Custo Total
	nAcumAbc += aSimil[nPosSimil][05]
	// Faixa a ser Classificada na Tabela SZR
	nClassi  := (nAcumAbc / nAcumCust) * 100
	cClassi  := ""
	For nX := 1 to Len(aSZR)
		If nClassi >= aSZR[nX][2] .and. nClassi <= aSZR[nX][3]
			cClassi := aSZR[nX][1]
			Exit
		Endif
	Next
	// Classificacao ABC Percentual
	aSimil[nPosSimil][08]:= nClassi
	// Classificacao ABC obtida no SZR com base no Percentual
	aSimil[nPosSimil][09]:= cClassi
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Classificacao PQR , Neoil com base no Qtd Apanhe  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cClassi := ""
	cClsNeo := ""
	For nX := 1 to Len(aSZS)
		If aSimil[nPosSimil][10] >= aSZS[nX][3] .and. aSimil[nPosSimil][10] <= aSZS[nX][4]
			cClassi := aSZS[nX][1]
			cClsNeo := aSZS[nX][2]
			Exit
		Endif
	Next
	// Classificacao PQR
	aSimil[nPosSimil][11]:= cClassi
	// Classificacao Neoil
	aSimil[nPosSimil][12]:= cClsNeo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tmea - Tempo Medio entre Apanhes                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//( Periodo da Planilha * 30 ) / Coluna Quantidade de Apanhes
	aSimil[nPosSimil][13]:= ( nPgmPeri * 30 ) / aSimil[nPosSimil][10]
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desvio Padrao                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//
	// Variavel A := Coluna SomaSaidaPer2 - ( Coluna Qtde Vendida * Coluna Qtde Vendida ) /
	//                                       Periodo da Planilha
	// Variavel A := Variavel A / Periodo da Planilha
	// DesvioPdrao := Raiz Quadrada da Variavel A
	nClassi := 0
	nClassi := aSimil[nPosSimil][14] - ;
	(aSimil[nPosSimil][03] * aSimil[nPosSimil][03]) / nPgmPeri
	nClassi := nClassi / nPgmPeri
	aSimil[nPosSimil][15]:= SQRT(nClassi)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta as Variaveis nas Tabelas :               ³
	//³                                                   ³
	//³ SZQ - Distribuicao Normal                         ³
	//³ SZH - Arvore de Encaminhamento                    ³
	//³ SZT - Frequencia Pratica                          ³
	//³                                                   ³
	//³ Para Definir :                                    ³
	//³                                                   ³
	//³ A. Estoque de Seguranca                           ³
	//³ B. Ponto de Pedido Automatico                     ³
	//³ C. Lote Automatico                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFatEstS := 0             // Fator de Seguranca  - Origem SZQ
	nFreqPrat:= 0             // Frequencia Pratica  - Origem SZT
	cMetodo  := ""            // Metodo que Sera Utilizado - Origem SZH
	cSistema := ""            // Sistema
	cClassi  :=	aSimil[nPosSimil][30]+;  //Classificacao Giro
             	aSimil[nPosSimil][11]+;  //Classificacao PQR    - Origem SZS
	            aSimil[nPosSimil][12]+;  //Classificacao NEOIL  - Origem SZS
	            aSimil[nPosSimil][17]+;  //Classificacao XYZ    - Origem SB1 - Nao Houve Reclassificao - Pois segundo o Marcelo sao Manuais
	            aSimil[nPosSimil][16]+;  //Classificacao 123    - Origem SB1 - Nao Houve Reclassificao - Pois segundo o Marcelo sao Manuais
	            aSimil[nPosSimil][09]    //Classificacao ABC    - Origem SZR

	
	DbSelectArea("SZH")
	DbSetOrder(2)                       // Filial + ZH_AUXILIA
	If DbSeek(xFilial("SZH")+cClassi)
		cMetodo := SZH->ZH_CODMET      //Classificacao: 1. Ponto de Pedido
	                                    //                2. Estoque Maximo
                                  		//                3. Estoque Minimo
	                                 	// 4. Por encomenta (NAO SERA UTILIZADO P/ MULTITEK)
		DbSelectArea("SZQ")
		DbSetOrder(1)                    // Filial + ZQ_CODIGO
		If DbSeek(xFilial("SZQ")+SZH->ZH_CODDN)
			nFatEstS := SZQ->ZQ_FATSEG
		Endif
         

    	DbSelectArea("SZG")              // Metodo
	    DbSetOrder(1)                    // Filial + ZG_CODMET  
	    If DbSeek(xFilial("SZG")+SZH->ZH_CODMET) 
		   cSistema := SZG->ZG_SISTEMA
	    Endif

	Endif
	
	
	cClassi := aSimil[nPosSimil][09]+;  //Classificacao ABC    - Origem SZR
	           aSimil[nPosSimil][18]     //"N/I" Nacionalidade   - Origem SB1
	
	DbSelectArea("SZT")
	DbSetOrder(2)                         // Filial + ZT_CODAUX
	If DbSeek(xFilial("SZT")+cClassi)
		nFreqPrat := SZT->ZT_FRQPRA
	Endif
	
	
	nTRepro := nPgmPeri * 30
	nLT     := aSimil[nPosSimil][19]
	nConsumo:= aSimil[nPosSimil][06]
	nDias   := IIf( nLT > nTRepro , nLT , nTRepro )
	nEstMin := ( nConsumo * nDias ) / 30


	Do Case
		
		Case cMetodo = "1"                  // 1. Ponto de Pedido
			
			// Estoque de Seguranca =  ( Fator de Seguranca * Desvio Padrao )
			aSimil[nPosSimil][22] := nFatEstS * aSimil[nPosSimil][15]

			if aSimil[nPosSimil][18] = "N" // Nacionais
				
				// Ponto de Pedido  = Estoque de Seguranca + (nDias / 30 * Consumo)
				aSimil[nPosSimil][21] := aSimil[nPosSimil][22] + ;
				( nDias / 30 * nConsumo)
				
			ElseIF aSimil[nPosSimil][18] = "I" // Importados
				
				// Ponto de Pedido  = Est. Seg + ( Lt / 30 * consumo ) + Desvio Padrao 
				aSimil[nPosSimil][21] := ( aSimil[nPosSimil][22] + ( nLT / 30 * nConsumo ) +;
				                            aSimil[nPosSimil][15] )
	
			Endif

			// Lote Automatico
			aSimil[nPosSimil][20] := nConsumo * ( nFreqPrat / 30 )
			
		Case cMetodo = "2"               // 2. Ponto de Estoque Maximo
			
			
			if aSimil[nPosSimil][18] = "N" // Nacionais
				
				// Ponto de Pedido  = Variavel EstMin + ((Consumo * FreqPratica) /30 )
				aSimil[nPosSimil][21] := nEstMin + (( nConsumo * nFreqPrat )/ 30)

			ElseIF aSimil[nPosSimil][18] = "I" // Importados
				
				// Ponto de Pedido  = Consumo * (( nLt /30 +nLt /30) / (Tmea * 30))
				aSimil[nPosSimil][21] := nConsumo * (( nLT / 30 + nLT / 30 ) /;
				(aSimil[nPosSimil][13] * 30))
				
			Endif
    
            // ???  Somente utilizo o saldo dos Itens de compra para calculo do
            //      saldo da Malha.
			// Lote Automatico     =  Ponto de Pedido - Saldo da Malha (Somente dos Itens de Compra)
			aSimil[nPosSimil][20] := aSimil[nPosSimil][21] - aSimil[nPosSimil][32]
			
		Case cMetodo = "3"               // 3. Ponto de Minimo
			
			If aSimil[nPosSimil][18] = "N" // Nacionais
				
				// Ponto de Pedido  = Estoque de Seguranca + (nDias * Consumo)
				aSimil[nPosSimil][21] := (nConsumo * nDias ) / 30
				
			ElseIF aSimil[nPosSimil][18] = "I" // Importados
				
				// Ponto de Pedido  = Consumo * (( nLt /30 +nLt /30) / (Tmea * 30))
				aSimil[nPosSimil][21] := nConsumo * (( nLT / 30 + nLT / 30 ) /;
				(aSimil[nPosSimil][13] * 30))
				
			Endif

			// Lote Automatico
			aSimil[nPosSimil][20] := nConsumo * ( nFreqPrat / 30 )

	Endcase
	
Next

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GiroEst   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Encaminhando/Dimensionando os Estoques (Ponto de Pedido e   º±±
±±º          ³Lote Automatico)                                            º±±
±±º          ³                                                            º±±
±±º          ³aSimil   // Vetor Simil + Eis                               º±±
±±º          ³[01]     // Simil               [*] index                   º±±
±±º          ³[02]     // Eis                 [*] index                   º±±
±±º          ³[03]     // Qtde Vendida                                    º±±
±±º          ³[04]     // Custo Stander Medio                             º±±
±±º          ³[05]     // Custo Total                                     º±±
±±º          ³[06]     // Consumo                                         º±±
±±º          ³[07]     // Ocorrencias                                     º±±
±±º          ³[08]     // Perc.Class                                      º±±
±±º          ³[09]     // ABC                                             º±±
±±º          ³[10]     // Qtde de Apanhes                                 º±±
±±º          ³[11]     // PQR                                             º±±
±±º          ³[12]     // Neoil                                           º±±
±±º          ³[13]     // Tmea                                            º±±
±±º          ³[14]     // SomaSaidasPer2                                  º±±
±±º          ³[15]     // Desvio Padrao                                   º±±
±±º          ³[16]     // Class 123                                       º±±
±±º          ³[17]     // Class XYZ                                       º±±
±±º          ³[18]     // Nacimp                                          º±±
±±º          ³[19]     // LT                                              º±±
±±º          ³[20]     // LoteAut                                         º±±
±±º          ³[21]     // Ponto de Pedido                                 º±±
±±º          ³[22]     // EstSeg                                          º±±
±±º          ³[23]     // Acum. Ent.                                      º±±
±±º          ³[24]     // Acum. Sai                                       º±±
±±º          ³[25]     // Saldo                                           º±±
±±º          ³[26]     // Acum.Dif.Dias                                   º±±
±±º          ³[27]     // Acum.Saldo.Dias                                 º±±
±±º          ³[28]     // Acum.Saldo.Quad                                 º±±
±±º          ³[29]     // Giro                                            º±±
±±º          ³[30]     // ClassGiro                                       º±±
±±º          ³[31]     // Quantidade Lote Praticado                       º±±
±±º          ³[32]     // Malha - Disp + PC (Item de Compra)              º±±
±±º          ³[33]     // Malha - Dipo + PC (Item nao Compra)             º±±
±±º          ³[34]     // Malha - Empenhado (Item nao Compra)             º±±
±±º          ³[35]     // Malha - Saldo Disponivel                        º±±
±±º          ³[36]     // Matriz (Disp + PC)                              º±±
±±º          ³[37]     // Filial (Disp + PC)                              º±±
±±º          ³[38]     // Malha  (Em Poder de 3)                          º±±
±±º          ³[39]     // Malha  (3 EM Nosso Poder)                       º±±
±±º          ³[40]     // Malha  (Quantidade reservad                     º±±
±±º          ³[41]     // Malha  (Prevista entrar no est.via Compras ou Opº±±
±±º          ³[42]     // Malha  (Quant.de Ped. de Venda nao Lib.p/Faturarº±± 
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GiroEst(aSimil) 

//Local nX       := 0
//Local cClassi  :=  ""
//Local nClassi  := 0        

// Segundo o Marcelo ele estaria executando esta atividade em virtude
// do  Muvograma.       

// Esta etar devera encontrar a Qtde de Giro no Ano 
// aSimil[nPosSimil][29]  //[29] Qtde de Giro no Ano  
// Para depois olhar no SZ1 achando a classificacao abaixo
// aSimil[nPosSimil][30]  //[30] ClassGiro


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravSB1   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Finalizando o Fechamento da PGMM                            º±±
±±º          ³                                                            º±±
±±º          ³Neste momento o Cadastro de Sku(SB1) serao atualizados      º±±
±±º          ³com base na Matriz, com base na chave Simil + Eis           º±±
±±º          ³                                                            º±±
±±º          ³aSimil   // Vetor Simil + Eis                               º±±
±±º          ³[01]     // Simil               [*] index                   º±±
±±º          ³[02]     // Eis                 [*] index                   º±±
±±º          ³[03]     // Qtde Vendida                                    º±±
±±º          ³[04]     // Custo Stander Medio                             º±±
±±º          ³[05]     // Custo Total                                     º±±
±±º          ³[06]     // Consumo                                         º±±
±±º          ³[07]     // Ocorrencias                                     º±±
±±º          ³[08]     // Perc.Class                                      º±±
±±º          ³[09]     // ABC                                             º±±
±±º          ³[10]     // Qtde de Apanhes                                 º±±
±±º          ³[11]     // PQR                                             º±±
±±º          ³[12]     // Neoil                                           º±±
±±º          ³[13]     // Tmea                                            º±±
±±º          ³[14]     // SomaSaidasPer2                                  º±±
±±º          ³[15]     // Desvio Padrao                                   º±±
±±º          ³[16]     // Class 123                                       º±±
±±º          ³[17]     // Class XYZ                                       º±±
±±º          ³[18]     // Nacimp                                          º±±
±±º          ³[19]     // LT                                              º±±
±±º          ³[20]     // LoteAut                                         º±±
±±º          ³[21]     // Ponto de Pedido                                 º±±
±±º          ³[22]     // EstSeg                                          º±±
±±º          ³[23]     // Acum. Ent.                                      º±±
±±º          ³[24]     // Acum. Sai                                       º±±
±±º          ³[25]     // Saldo                                           º±±
±±º          ³[26]     // Acum.Dif.Dias                                   º±±
±±º          ³[27]     // Acum.Saldo.Dias                                 º±±
±±º          ³[28]     // Acum.Saldo.Quad                                 º±±
±±º          ³[29]     // Giro                                            º±±
±±º          ³[30]     // ClassGiro                                       º±±
±±º          ³[31]     // Quantidade Lote Praticado                       º±±
±±º          ³[32]     // Malha - Disp + PC (Item de Compra)              º±±
±±º          ³[33]     // Malha - Dipo + PC (Item nao Compra)             º±±
±±º          ³[34]     // Malha - Empenhado (Item nao Compra)             º±±
±±º          ³[35]     // Malha - Saldo Disponivel                        º±±
±±º          ³[36]     // Matriz (Disp + PC)                              º±±
±±º          ³[37]     // Filial (Disp + PC)                              º±±
±±º          ³[38]     // Malha  (Em Poder de 3)                          º±±
±±º          ³[39]     // Malha  (3 EM Nosso Poder)                       º±±
±±º          ³[40]     // Malha  (Quantidade reservad                     º±±
±±º          ³[41]     // Malha  (Prevista entrar no est.via Compras ou Opº±±
±±º          ³[42]     // Malha  (Quant.de Ped. de Venda nao Lib.p/Faturarº±± 
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GravSB1(aSimil)
Local  nPosSimil := 0

DbSelectArea("SB1")
DbOrderNickname("B1SIMEIS") // Filial+Simil+Eis

For nPosSimil := 1 to Len(aSimil)
	
	cChave := aSimil[nPosSimil][01] + aSimil[nPosSimil][02]
	
	If DbSeek (xFilial("SB1") + cChave )
		
		While !SB1->(EOF()) .and. cChave = SB1->( B1_X_SIMIL + B1_X_EIS01 + B1_X_EIS02+;
			B1_X_EIS03 + B1_X_EIS04 + B1_X_EIS05+B1_X_EIS06 + B1_X_EIS07 + B1_X_EIS08+;
			B1_X_EIS09 + B1_X_EIS10 )

            // Observacao / Observacao / Observacao / Observacao / Observacao
            // No momento ficou definido que nao seria gravado os campos do padrao
            // correspondentes aos Multitek que sao:
            // MULTITEK                 PADRAO                     
            // B1_X_EST           (B1_ESTSEG)
            // B1_X_LTAUT         (B1_LM ou B1_LE)                              
            // B1_X_PTAUT         (B1_EMIN)
			Reclock("SB1",.F.)
			//cCdSimil,;                               //[01] Codigo Simil     (B1_X_SIMIL)
			//cCodiEis,;                               //[02] Codigo Eis       (B1_X_EIS01..B1_X_EIS10)
			//nQuantid,;                               //[03] Qtde Vendida     (SZ9->Z9_QTDSAI)
			//nCstdMed,;                               //[04] Custo Stander Medio(Custo Total / Qtde Vendida )
			//nCstdTot,;                               //[05] Custo Total      (Z9_QTDSAI * Z9_VLRCM)
			SB1->B1_X_CONSM:= aSimil[nPosSimil][06]   //[06] Consumo Medio    (Qtde Vendida / Numero de Ocorrencias)
			//nOcorren,;                               //[07] Ocorrencias      (+1 total de Meses Processados no SZ9)
			//nPerClas,;                               //[08] Perc.Class       ProcVetor ()
			SB1->B1_X_ABC  := aSimil[nPosSimil][09]  //[09] ABC              ProcVetor ()
			SB1->B1_X_PQR  := aSimil[nPosSimil][11]  //[11] PQR              ProcVetor ()
			SB1->B1_X_NEOIL:= aSimil[nPosSimil][12]  //[12] Neoil            ProcVetor ()
			SB1->B1_X_TMEA := aSimil[nPosSimil][13]  //[13] Tmea             ProcVetor ()
			//nSaidPe2,;                               //[14] SomaSaidasPer2   (Z9_QTDSAI * Z9_QTDSAI)
			SB1->B1_X_DESVP:=  aSimil[nPosSimil][15]  //[15] Desvio Padrao    ProcVetor ()
			SB1->B1_X_123  :=  aSimil[nPosSimil][16]  //[16] Class 123        (B1_X_123)
			SB1->B1_X_XYZ  :=  aSimil[nPosSimil][17]  //[17] Class XYZ        (B1_X_XYZ)
			//cNacimp ,;                                 //[18] Nacimp           (B1_X_NC_IM)
			//SB1->B1_X_LT   :=  aSimil[nPosSimil][19]  //[19] LT               (B1_X_LT)
			SB1->B1_X_LTAUT:=  aSimil[nPosSimil][20]  //[20] LoteAut           ProcVetor ()
			SB1->B1_X_PTAUT:=  aSimil[nPosSimil][21]  //[21] Ponto de Pedido   ProcVetor ()
			SB1->B1_X_ESTSE:=  aSimil[nPosSimil][22]  //[22] EstSeg            ProcVetor ()
			//nAcumEnt,;                                //[23] Acum. Ent.        ??? Posicoes Vazias
			//nAcumSai,;                                //[24] Acum. Sai         ??? Posicoes Vazias
			//nSaldo  ,;                                //[25] Saldo             ??? Posicoes Vazias
			//nAcumDif,;                                //[26] Acum.Dif.Dias     ??? Posicoes Vazias
			//nAcumDias,;                               //[27] Acum.Saldo.Dias   ??? Posicoes Vazias
			//nAcumQuad,;                               //[28] Acum.Saldo.Quad   ??? Posicoes Vazias
			SB1->B1_X_GIROQ:= aSimil[nPosSimil][29]   //[29] Qtde de Giro no Ano
			SB1->B1_X_LMN  := aSimil[nPosSimil][30]   //[30] ClassGiro
			//SaldoMalh })                             //[31] Saldo da Malha  (Qatu - Reserva + Salpedi + Qnpt - Qtnp - QpedVen)

            // ??? As informacoes abaixo seram utilizadas  
            //     durante a geracao da PGMM.
            //     Com base nestas informacoes nao sera necessario 
            //     rodar o SZ9 Historico novamente.
            SB1->B1_X_APN_A:= aSimil[nPosSimil][10]   // [10] Qtde de Apanhes    (Z9_QTDAPA)
            SB1->B1_X_QTDSA:= aSimil[nPosSimil][03]   // [03] Quantidade Vendida (Z9_QTDSAI)
            SB1->B1_X_VLRCM:= aSimil[nPosSimil][05] / aSimil[nPosSimil][03] // Custo Total Medio /  Z9_QTDSAI.
			MsUnlock()
			
			SB1->(DBSKIP())
			
		Enddo
		
	Endif

Next

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraZ7eZ8 ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geracao dos dados para Manutencao                           º±±
±±º          ³                                                            º±±
±±º          ³Neste momento estou aproveitando a Matriz aSimil para       º±±
±±º          ³gravar o SZ8                                                º±±
±±º          ³                                                            º±±
±±º          ³aSKU     // Vetor Sku                                       º±±
±±º          ³[01]     // Codigo da Sku       [*] index                   º±±
±±º          ³[02]     // Malha - Saldo Dispon + PC (Item Nao Compra)     º±±
±±º          ³[03]     // Malha - Saldo Dispon + PC (Item Compra)         º±±
±±º          ³[04]     // Malha - Saldo Empenhado                         º±±
±±º          ³[05]     // Malha - Saldo Disponivel                        º±±
±±º          ³[06]     // Matriz (Disp + PC)                              º±±
±±º          ³[07]     // Filial (Disp + PC)                              º±±
±±º          ³[08]     // Malha  (Em Poder de 3)                          º±±
±±º          ³[09]     // Malha  (3 EM Nosso Poder)                       º±±
±±º          ³                                                            º±±
±±º          ³aSimil   // Vetor Simil + Eis                               º±±
±±º          ³[01]     // Simil               [*] index                   º±±
±±º          ³[02]     // Eis                 [*] index                   º±±
±±º          ³[03]     // Qtde Vendida                                    º±±
±±º          ³[04]     // Custo Stander Medio                             º±±
±±º          ³[05]     // Custo Total                                     º±±
±±º          ³[06]     // Consumo                                         º±±
±±º          ³[07]     // Ocorrencias                                     º±±
±±º          ³[08]     // Perc.Class                                      º±±
±±º          ³[09]     // ABC                                             º±±
±±º          ³[10]     // Qtde de Apanhes                                 º±±
±±º          ³[11]     // PQR                                             º±±
±±º          ³[12]     // Neoil                                           º±±
±±º          ³[13]     // Tmea                                            º±±
±±º          ³[14]     // SomaSaidasPer2                                  º±±
±±º          ³[15]     // Desvio Padrao                                   º±±
±±º          ³[16]     // Class 123                                       º±±
±±º          ³[17]     // Class XYZ                                       º±±
±±º          ³[18]     // Nacimp                                          º±±
±±º          ³[19]     // LT                                              º±±
±±º          ³[20]     // Lote Automatico                                 º±±
±±º          ³[21]     // Ponto de Pedido Automatico                      º±±
±±º          ³[22]     // EstSeg                                          º±±
±±º          ³[23]     // Acum. Ent.                                      º±±
±±º          ³[24]     // Acum. Sai                                       º±±
±±º          ³[25]     // Saldo                                           º±±
±±º          ³[26]     // Acum.Dif.Dias                                   º±±
±±º          ³[27]     // Acum.Saldo.Dias                                 º±±
±±º          ³[28]     // Acum.Saldo.Quad                                 º±±
±±º          ³[29]     // Giro                                            º±±
±±º          ³[30]     // ClassGiro                                       º±±
±±º          ³[31]     // Quantidade Lote Praticado                       º±±
±±º          ³[32]     // Malha - Disp + PC (Item de Compra)              º±±
±±º          ³[33]     // Malha - Dipo + PC (Item nao Compra)             º±±
±±º          ³[34]     // Malha - Empenhado (Item nao Compra)             º±±
±±º          ³[35]     // Malha - Saldo Disponivel                        º±±
±±º          ³[36]     // Matriz (Disp + PC)                              º±±
±±º          ³[37]     // Filial (Disp + PC)                              º±±
±±º          ³[38]     // Malha  (Em Poder de 3)                          º±±
±±º          ³[39]     // Malha  (3 EM Nosso Poder)                       º±±
±±º          ³[40]     // Malha  (Quantidade reservad                     º±±
±±º          ³[41]     // Malha  (Prevista entrar no est.via Compras ou Opº±±
±±º          ³[42]     // Malha  (Quant.de Ped. de Venda nao Lib.p/Faturarº±± 
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GeraZ7eZ8(aSimil,aSKU)

Local nPosSimil  := 0
Local cCodiSku   := ""
Local nCustStd   := 0
Local cCdSimil   := ""
Local cCodiEis   := ""

Local nPonto     := 0
Local nLote      := 0
Local aSaldoEst  := {}
Local nSldMalha  := 0
Local nSldEmpen  := 0
Local nSldItSC   := 0
Local nSldItNC   := 0
Local nSldEmpe   := 0
Local nPosSku    := 0
Local cItemComp  := ""
Local nPtMan     := 0          //  Ponto de Pedido Manual
Local nLtMan     := 0          //  Lote Manual
Local nLtAut     :=  0         //  Lote Automatico   ProcVetor ()
Local nPtAut     :=  0         //  Ponto Automatico  ProcVetor ()

//TCSQLEXEC(("UPDATE PZ2010 SET PZ2_NOW='N' WHERE PZ2_NOW='T' " ))
//TCSQLEXEC(("DELETE "+ RetSqlName("PZ1")+" PZ1 " + " WHERE PZ1_ALIAS = '"+_cProcTab+"' and PZ1_DATA < '"+DTOS(dDataBase-10)+"'" ))
//TCSQLEXEC(("UPDATE PZ2010 SET PZ2_NOW='N' WHERE PZ2_NOW='T' " ))

#IFDEF TOP
	TCSQLEXEC(("DELETE "+ RetSqlName("SZ7")+ " SZ7 " ))
	TCSQLEXEC(("DELETE "+ RetSqlName("SZ8")+ " SZ8 " ))
#ELSE
	DbSelectArea("SZ7")    // Planilha por Simil + Eis
	DbGotop()
	while !SZ7->(EOF())
		Reclock("SZ7",.F.)
		SZ7->(DbDelete())
		MsUnlock()
		SZ7->(DbSkip())
	Enddo
	DbSelectArea("SZ8")    // Planilha por Sku
	DbGotop()
	while !SZ8->(EOF())
		Reclock("SZ8",.F.)
		SZ8->(DbDelete())
		MsUnlock()
		SZ8->(DbSkip())
	Enddo
#ENDIF

DbSelectArea("SB1")
DbGotop()

While !SB1->(EOF())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados para processamento                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodiSku      := SB1->B1_COD
	nCustStd      := SB1->B1_X_CTSTD
	cCdSimil      := SB1->B1_X_SIMIL
	cCodiEis      := SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+;
                        	B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)
	nPtMan        := SB1->B1_X_PTMAN          //  Ponto de Pedido Manual
	nLtMan        := SB1->B1_X_LTMAN          //  Lote Automatico Manual
	cItemComp     := SB1->B1_X_ITCPR          //  Item de Compra (S/N)
	cAuxiliar     := SB1->(B1_X_LMN+B1_X_PQR+B1_X_NEOIL+B1_X_XYZ+B1_X_123+B1_X_ABC)
                      
	If EmptY(cCdSimil)
		DbSelectArea("SB1")
		SB1->(DbSkip())
		Loop
	Endif
	
	if SB1->B1_X_PTMAN < 0     // Na documentacao sita campo de Pedido Manual
		DbSelectArea("SB1")    // diferente de -1 quando falo de ponto de pedido
		SB1->(DbSkip())        // Deixar claro que criei o B1_X_LTMAN e B1_X_LTAUT (Lote)
		Loop                   //                           B1_X_PTMAN e B1_X_PTAUT (Ponto de Pedido)
	Endif


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Posicionando aScan[Sku]                                                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    nPosSku  := aScan( aSKU , {|x| x[1] == cCodiSku })
    if nPosSku #  0
       nSldItSC := aSKU[nPosSku][2]     // Malha - Saldo Disponivel + PC) - Item nao Compra
 	   nSldItNC := aSKU[nPosSku][3]     // Malha - Saldo Disponivel + PC) - Item Compra
 	   nSldEmpe := aSKU[nPosSku][4]     // Malha - Saldo Empenhado
       nSldDisp := aSKU[nPosSku][5]     // Malha - Saldo Disponivel
    Else
      nSldItSC := 0                      // Malha - Saldo Disponivel + PC) - Item nao Compra
      nSldItNC := 0                      // Malha - Saldo Disponivel + PC) - Item Compra
      nSldEmpe := 0                      // Malha - Saldo Empenhado
      nSldDisp := 0                      // Malha - Saldo Disponivel
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionando aSimil[smil+eis] - com informacoes de SB1, SB2 , SZ9         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nPosSimil := aScan( aSimil , {|x| x[1]+x[2] == cCdSimil + cCodiEis })
	if nPosSimil # 0
	   nLtAut:=  aSimil[nPosSimil][20]  // Lote Automatico            ProcVetor ()
	   nPtAut:=  aSimil[nPosSimil][21]  // Ponto de Pedido Automatico ProcVetor ()
    Else
	   nLtAut  :=  0                     // Lote Automatico             ProcVetor ()
	   nPtAut  :=  0                     // Ponto de Pedido Automatico  ProcVetor ()
    Endif

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Define o Lote Praticado (Pedido de Compra)                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Com base na Logica abaixo o
	// Lote Praticado pode ser 0(zero) quando o Saldo da Malha
	// for maior que o Ponto de Pedido Automatico e
	// Saldo da Malha for maior que o Ponto de Pedido Manual
	nPedCom := 0
	
	if nLtMan >= 0           // nLtMan -1 nao ocorre esta sendo tratado acima
		If nLtMan = 0
			// Sld Malha < Pto Ped. Automatico (Gatilho) .or.
			// Sld Malha <  nLtMan
			if nSldMalha <  nPtAut .or. nSldMalha < nLtMan
				nPedCom  := nLtAut
			Endif
		Elseif nLtMan > 0
			// Sld Malha < Pto Ped. Automatico (Gatilho) .or.
			// Sld Malha <  nLtMan
			if nSldMalha <  nPtAut .or. nSldMalha < nLtMan
				nPedCom := nLtMan
			Endif
		Endif
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia Processo de Gravacao do SZ8 - Por Sku                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Reclock("SZ8",.T.)
	SZ8->Z8_FILIAL	:= xFilial("SZ8")           // C	2
	SZ8->Z8_SIMIL	:= SB1->B1_X_SIMIL          //C	6
	SZ8->Z8_EIS01	:= SB1->B1_X_EIS01          //C	2
	SZ8->Z8_EIS02	:= SB1->B1_X_EIS02          //C	2
	SZ8->Z8_EIS03	:= SB1->B1_X_EIS03          // 	C	2
	SZ8->Z8_EIS04	:= SB1->B1_X_EIS04          // 	C	2
	SZ8->Z8_EIS05	:= SB1->B1_X_EIS05          // 	C	2
	SZ8->Z8_EIS06	:= SB1->B1_X_EIS06          // 	C	2
	SZ8->Z8_EIS07	:= SB1->B1_X_EIS07          // 	C	2
	SZ8->Z8_EIS08	:= SB1->B1_X_EIS08          // 	C	2
	SZ8->Z8_EIS09	:= SB1->B1_X_EIS09          // 	C	2
	SZ8->Z8_EIS10	:= SB1->B1_X_EIS10          // 	C	2
	SZ8->Z8_SKU		:= SB1->B1_COD              // C	15
	SZ8->Z8_REFER	:= SB1->B1_X_REFER          // 	C	17
	SZ8->Z8_SUFIXO	:= SB1->B1_X_SUFIX          // 	C	10
	SZ8->Z8_MARCA	:= SB1->B1_X_MARCA          // 	C	4
	SZ8->Z8_CDTR	:= SB1->B1_X_NC_IM          // 	C	1
	SZ8->Z8_VLRFOB	:= SB1->B1_X_VLFOB          //  N   14
	SZ8->Z8_LOTEPRA	:= nPedCom                  // N	14
	SZ8->Z8_ITCPR 	:= cItemComp      
	SZ8->Z8_PEDCOMP	:= nSldItSC                 // 	N	14  
	SZ8->Z8_NAOCOMP	:= nSldItNC                 // 	N	14   
	SZ8->Z8_SLDEMPE	:= nSldEmpe                 //  N	14 
	SZ8->Z8_DISPONI	:= nSldDisp                 // 	N	14 
    SZ8->Z8_SHARE   := SB1->B1_X_SHARE
	// ??? Consumo Medio (Neste campo e realmente gravado o Consumo Medio)
	SZ8->Z8_CONSPER  := aSimil[nPosSimil][06]
    // Custo Stander Medio      ++(Z9_QTDSAI * SZ9->Z9_VLRCM) / ++Z9_QTDSAI 
	SZ8->Z8_CUSMED   := aSimil[nPosSimil][04]
	MsUnlock()
	
	DbSelectArea("SB1")
	SB1->(DBSKIP())
	
Enddo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia Processo de Gravacao do SZ7                                        ³
//³Para garantir a Integricade ja que a Matriz veio pronta e nao posso gravar³
//³alguns itens tipo SB1->B1_X_PTMAN < 0  Verifico o SZ8 p/ Continuar        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



For nPosSimil := 1 to Len(aSimil)
	DbSelectArea("SZ8")          // Garante a Integridade entre Z7 e Z8
	DbSetOrder(1) // Filial+Simil+Eis
	If  DbSeek(xFilial("SZ8")+aSimil[nPosSimil][01]+aSimil[nPosSimil][02]) // simil + Eis
		
		DbSelectArea("SB1")
		DbOrderNickname("B1SIMEIS") // Filial+Simil+Eis
		DbSeek(xFilial("SB1")+aSimil[nPosSimil][01]+aSimil[nPosSimil][02]) // simil + Eis
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dados para processamento                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCodiSku      := SB1->B1_COD
		nCustStd      := SB1->B1_X_CTSTD
		cCdSimil      := SB1->B1_X_SIMIL
		cCodiEis      := SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+;
		B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)
		nPtMan        := SB1->B1_X_PTMAN          //  Ponto de Pedido Manual
		nLtMan        := SB1->B1_X_LTMAN          //  Lote Automatico Manual
		cItemComp     := SB1->B1_X_ITCPR
		cAuxiliar     := SB1->(B1_X_LMN+B1_X_PQR+B1_X_NEOIL+B1_X_XYZ+B1_X_123+B1_X_ABC)
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona no SZH , SZQ , SZG                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SZH")                 // Arvore de Encaminhamento
		DbSetOrder(2)                       // Filial + ZH_AUXILIA
		If DbSeek(xFilial("SZH")+cAuxiliar)
			
			DbSelectArea("SZQ")              // Distribuicao Normal
			DbSetOrder(1)                    // Filial + ZQ_CODIGO
			DbSeek(xFilial("SZQ")+SZH->ZH_CODDN)
			
			DbSelectArea("SZG")              // Metodo
			DbSetOrder(1)                    // Filial + ZG_CODMET
			DbSeek(xFilial("SZG")+SZH->ZH_CODMET)
			
		Endif
		
		
		DbSelectArea("SZ7")
		RecLock("SZ7",.T.)
		SZ7->Z7_FILIAL	:= xFilial("SZ7")
		SZ7->Z7_SIMIL	:= SB1->B1_X_SIMIL  //[01] Codigo Simil     (B1_X_SIMIL)
		SZ7->Z7_EIS01	:= SB1->B1_X_EIS01
		SZ7->Z7_EIS02	:= SB1->B1_X_EIS02
		SZ7->Z7_EIS03	:= SB1->B1_X_EIS03
		SZ7->Z7_EIS04	:= SB1->B1_X_EIS04
		SZ7->Z7_EIS05	:= SB1->B1_X_EIS05
		SZ7->Z7_EIS06	:= SB1->B1_X_EIS06
		SZ7->Z7_EIS07	:= SB1->B1_X_EIS07
		SZ7->Z7_EIS08	:= SB1->B1_X_EIS08
		SZ7->Z7_EIS09	:= SB1->B1_X_EIS09
		SZ7->Z7_EIS10	:= SB1->B1_X_EIS10
		SZ7->Z7_GATILHO	:= aSimil[nPosSimil][20]  //[20] Ponto de Pedido Automatico
		SZ7->Z7_LOTEAUT	:= aSimil[nPosSimil][21]  //[21] Lote Automatico
		SZ7->Z7_CONSPER	:= aSimil[nPosSimil][03]  //[03] Total de Saidas
		SZ7->Z7_LT_DIAS	:= aSimil[nPosSimil][19]  //[19] LT               (B1_X_LT)                      // N	6
		SZ7->Z7_QTDAPAN	:= aSimil[nPosSimil][10]  //[10] Qtde de Apanhes  (Z9_QTDAPA)                      //	N	9
		SZ7->Z7_TMEA	:= aSimil[nPosSimil][13]  //[13] Tmea             ProcVetor ()                      //	N	6
		SZ7->Z7_CONSMED	:= aSimil[nPosSimil][06]  //[06] Consumo Medio    (Qtde Vendida / Numero de Ocorrencias)                      // N	15
		SZ7->Z7_DESVPAD	:= aSimil[nPosSimil][15]  //[15] Desvio Padrao    ProcVetor ()                       // N	11
		SZ7->Z7_AUXILIA	:= cAuxiliar              // C	 5            // ZH_AUXILIAR
		SZ7->Z7_ESTSEG	:= aSimil[nPosSimil][22]  //[22] EstSeg            ProcVetor ()
		
		// ??? A gravacao do campo abaixo esta correta
		//     saldo da Malha / consumo medio
		//     observando outro fator que tambem e um campo
		//     numerico de seis posicoes.
		SZ7->Z7_CB_INST	:= aSimil[nPosSimil][32] / aSimil[nPosSimil][06]
		
		// ??? Qual das descricoes devem entrar nos campos abaixo:
		// ZG_DESCMET	C	15	0	DESC.METODO	Descrição do Método (1-6)
		// ZG_DSCTRAT	C	15	0	DescSistTrat	Descr Sistema Tratamento
		// ZH_DESCPQR	C	25	0	Descr PQR	Descr Classif PQR
		// ZH_D_NEOIL	C	15	0	Descr NEOIL	Descr da Classif Demanda
		// ZH_DESCXYZ	C	15	0	Descr XYZ	Descr Classif Criticidade
		// ZH_DESC123	C	15	0	Descr 123	Descr Classif Aquisição
		// ZH_DESCABC	C	35	0	Descr ABC	Descr Classif ABC
		// ZH_DESCLMN	C	20	0	DESC.LHM	Descr Classif Giro
		
		//SZ7->Z7_DESCR1	:=                     // C 100    // Descricao do SZG + SZH
		//SZ7->Z7_DESCR2	:=                     // C 100
		//SZ7->Z7_DESCR3	:=                     // C 100
		
		// Consumo total no Periodo ++Z9_QTDSAI
		SZ7->Z7_QTDSAI  := aSimil[nPosSimil][03]
		// Custo Stander Medio      ++(Z9_QTDSAI * SZ9->Z9_VLRCM) / ++Z9_QTDSAI
		SZ7->Z7_VLRCM	:= aSimil[nPosSimil][04]
		SZ7->Z7_ABC		:= aSimil[nPosSimil][09]  //[09] ABC              ProcVetor ()                       // C	1
		SZ7->Z7_PQR	    := aSimil[nPosSimil][11]  //[11] PQR              ProcVetor ()                     // C	1
		SZ7->Z7_NEOIL	:= aSimil[nPosSimil][12]  //[12] Neoil            ProcVetor ()
		SZ7->Z7_123	    := aSimil[nPosSimil][16]  //[16] Class 123        (B1_X_123)                       // C	1
		SZ7->Z7_XYZ		:= aSimil[nPosSimil][17]  //[17] Class XYZ        (B1_X_XYZ)                      // C	1
		SZ7->Z7_LMN  	:= aSimil[nPosSimil][30]  //[30] ClassGiro
		SZ7->Z7_GIROQ	:= aSimil[nPosSimil][29]  //[29] Qtde de Giro no Ano                      // N	8
		SZ7->Z7_LEAD	:= aSimil[nPosSimil][19]  //[19] LT               (B1_X_LT)                      // N	4
		SZ7->Z7_EIS	    := aSimil[nPosSimil][02]  //[02] EIS
		SZ7->Z7_SLDMALH	:= aSimil[nPosSimil][32]  // Malha  - Disponivel + PC
		SZ7->Z7_SLDMTZ	:= aSimil[nPosSimil][36]  // Matriz - Disponivel + PC
		SZ7->Z7_SLDFIL	:= aSimil[nPosSimil][37]  // Filial - Disponivel + PC
		SZ7->Z7_SLDPD3	:= aSimil[nPosSimil][38]  // Malha  - Em Poder de 3
		SZ7->Z7_SLD3EM	:= aSimil[nPosSimil][39]  // Malha  - 3 EM Nosso Poder
		SZ7->Z7_SLDEMPE	:= aSimil[nPosSimil][34]  // Malha  - Empenhado
		SZ7->Z7_DISPONI	:= aSimil[nPosSimil][35]  // Malha  - Saldo Disponivel
		SZ7->Z7_NAOCOMP	:= aSimil[nPosSimil][33]  // Malha  - Dipo + PC (Item nao Compra)
		
		// ??? O Lote praticado e o mesmo do SZ8 Simil+Eis agora
		//     gravando por Sku.
		SZ7->Z7_LOTEPRA:= SZ8->Z8_LOTEPRA
		
		// ??? Esta quantidade e a Empenhada ou Empenhada +
		//     [42] (Quant.de Ped. de Venda nao Lib.p/Faturar
		//     observar que quantidade empenhada ja esta sendo gravada
		// SZ7->Z7_PEDVEND:=                     // N	15
		
		MsUnlock()
	Endif
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Alice Y Yamamoto    ³Data³ 22.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aPerg := {}
Local cPerg := "PLANI1", nI, nPerg


//aadd(aPerg,{"01","Mes            ?","Mes            ?","Mes            ?","mv_ch1","N",2,0,0,"G","U_VALMES(MV_PAR01)","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aadd(aPerg,{"02","Ano            ?","Ano            ?","Ano            ?","mv_ch2","N",4,0,0,"G","U_VALANO(MV_PAR02)","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aadd(aPerg,{"01","Processar      ?","Processar      ?","Processar      ?","mv_ch1","N",1,0,0,"C","","MV_PAR01","Fechamento     ","Fechamento     ","Fechamento     ","","Reprocessamento","Reprocessamento","Reprocessamento","","","","","","","","","","","","","","","","","","",""})

nPerg := Len(aPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso nao exista a Pergunta a mesma sera criada.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX1")
dbSetOrder(1)
For nI := 1 To nPerg
	If ! dbSeek(cPerg+aPerg[nI,1])
		RecLock("SX1",.T.)
		Replace X1_GRUPO	With cPerg
		Replace X1_ORDEM	With aPerg[nI,01]
		Replace X1_PERGUNT	With aPerg[nI,02]
		Replace X1_PERSPA	With aPerg[nI,03]
		Replace X1_PERENG	With aPerg[nI,04]
		Replace X1_VARIAVL	With aPerg[nI,05]
		Replace X1_TIPO		With aPerg[nI,06]
		Replace X1_TAMANHO	With aPerg[nI,07]
		Replace X1_DECIMAL  With aPerg[nI,08]
		Replace X1_PRESEL   With aPerg[nI,09]
		Replace X1_GSC		With aPerg[nI,10]
		Replace X1_VALID    With aPerg[nI,11]
		Replace X1_VAR01	With aPerg[nI,12]
		Replace X1_DEF01	With aPerg[nI,13]
		Replace X1_DEFSPA1	With aPerg[nI,14]
		Replace X1_DEFENG1	With aPerg[nI,15]
		Replace X1_CNT01	With aPerg[nI,16]
		Replace X1_DEF02	With aPerg[nI,17]
		Replace X1_DEFSPA2	With aPerg[nI,18]
		Replace X1_DEFENG2	With aPerg[nI,19]
		MsUnlock()
	EndIf
Next

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DataFecha    ³Autor ³  Almeida             ³Data³ 05.07.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visa determinar as datas validas para Processamento baseado³±±
±±³          ³ no SZ9      (Historico por Simil + Eis)                    ³±±
±±³          ³    Index 2  (SZ9->Z9_FILIAL+SZ9->Z9_ANO+SZ9->Z9_MES)                      ³±±
±±³          ³                                                            ³±±
±±³Retorna   ³ Matriz com duas datas validas para processamento           ³±±
±±³          ³ [1]   Esta posicao e exclusiva para as datas do Reprocessam³±±
±±³          ³ [1][1]Data Final do Reprocessamento;                       ³±±
±±³          ³ [1][2]Data Inicio da consulta dos Historicos com base na   ³±±
±±³          ³       data de Reprocessamento;                             ³±±
±±³          ³ [1][3]Data Inicio consulta do Giro com base na             ³±±
±±³          ³       data de Reprocessamento;                             ³±±
±±³          ³                                                            ³±±
±±³          ³ [2]   Esta posicao e exclusiva para as datas do Fechamento ³±±
±±³          ³ [2][1]Data Final do Fechamento;                            ³±±
±±³          ³ [2][2]Data Inicio da consulta dos Historicos com base na   ³±±
±±³          ³       data de Fechamento;                                  ³±±
±±³          ³ [2][3]Data Inicio consulta do Giro com base na             ³±±
±±³          ³       data de Fechamento;                                  ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DataFecha()
Local cAno1    := ""
Local cMes1    := ""
Local dPer1    := CTOD("")   // Data Inicial do Reprocessamento

Local cAno2    := ""
Local cMes2    := ""

Local dIni_Mes := CTOD("")
Local dIni_Hist:= Ctod("")
Local dIni_Giro:= Ctod("")
Local dFim     := Ctod("")
Local dDtProc2 := Ctod("")
Local dDtGiro2 := Ctod("")

Local aMatriz  := {}


DbselectArea("SZ9")   // Historico por Simil + Eis
DbSetOrder(2)
DbGobottom()

cAno1 := SUBSTR(SZ9->Z9_ANO,3,2)  // 2004
cMes1 := SZ9->Z9_MES  // 04

If EmptY(cAno1)                            // Apenas para teste quando base estiver vazia
	cAno1 := "2004"
	cMes1 := "12"
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona a matriz posicao [1] dados do Reprocessamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Define o Primeiro dia do Mes
dIni_Mes   := CTOD("01"+"/"+cMes1+"/"+cAno1)   // Data Inicial do Reprocessamento
// do Mes ( Reprocessamento )
// Define o Ultimo dia do Mes para processamento
dFim       := LastDay(Ctod("01/"+cMes1+"/"+cAno1))
// Define data Inicial para processamento do Historico (com base no Reprocessamento)
dDtProc2   := dFim - (nPgmPeri * 30)
dIni_Hist  := Ctod("01/"+STRZERO(Month(dDtProc2),2)+"/"+STR(Year(dDtProc2),4))
// Define data Inicial para processamento do Giro      (com base no Reprocessamento)
dDtGiro2   := dFim - (nPgmGiro * 30)
dIni_Giro  := Ctod("01/"+STRZERO(Month(dDtGiro2),2)+"/"+STR(Year(dDtGiro2),4))

aadd(aMatriz,{dFim,dIni_Mes,dIni_Hist,dIni_Giro})         // Reprocessamento


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona a matriz posicao [2] dados novo Fechamento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if Val(cMes1)=12
	cAno2 := str(Val(cAno1)+1,4)
	cMes2 := "01"
Else
	cAno2 := cAno1
	cMes2 := strzero(Val(cMes1)+1,2)
Endif
// Define o Primeiro dia do Mes
dIni_Mes:= CTOD("01"+"/"+cMes2+"/"+cAno2) // Data Inicial do Processamento
// do Mes ( Processamento )

// Define o Mes para processamento
dFim       := LastDay(Ctod("01/"+cMes2+"/"+cAno2))
// Define data Inicial para processamento do Historico
dDtProc2   := dFim - (nPgmPeri * 30)
dIni_Hist  := Ctod("01/"+STRZERO(Month(dDtProc2),2)+"/"+STR(Year(dDtProc2),4))
// Define data Inicial para processamento do Giro
dDtGiro2   := dFim - (nPgmGiro * 30)
dIni_Giro   := Ctod("01/"+STRZERO(Month(dDtGiro2),2)+"/"+STR(Year(dDtGiro2),4))

aadd(aMatriz,{dFim,dIni_Mes,dIni_Hist,dIni_Giro})         // Fechamento

Return(aMatriz)



