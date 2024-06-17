#INCLUDE "FIVEWIN.CH"

#Define _nD_ENTER         Chr(13)+Chr(10)

User Function MTR_CONTRA()

SetPrvt("CBTXT,TITULO,CDESC1,CDESC2,CDESC3,CBCONT")
SetPrvt("cCABEC1,cCABEC2,cCABEC3,cCABEC4,cCABEC5,cCABEC6,cCABEC7,WNREL,TAMANHO,CSTRING")
SetPrvt("ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,CPERG,ACAMPOS,ATAM")
SetPrvt("NAG1,NAG2,NAG3,NAG4,NRANK,CVEND,NVALOR1")
SetPrvt("NVALOR2,NVALOR3,CESTOQ,CDUPLI,ATAMVAL,NTIPO")
SetPrvt("LI,M_PAG,CNOMEARQ,CNOMARQ1,CNOMARQ2,NCONTADOR")
SetPrvt("NTOTAL,NVALICM,NVALIPI,NVENDEDOR,CVENDEDOR,AVEND")
SetPrvt("AIMPOSTOS,NIMPOS,CCAMPIMP,NY,_NTOTSQL,_nValpisvel,_nValpisnov,")
SetPrvt("_cVend,_cNome,_nValBrut,_nValMerc,_nQuant,_nImposto,cFiltro")


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³MTR_CONTRA³ Autor ³ Adriano P.Pavan       ³ Data ³ 23.08.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Estatistica de Venda por Ordem de Vendedor                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ Baseado no MATR580                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros³ Verificar Indexacao com vendedor                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ Generico                                                   ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ALTERADO POR ³ ROBERTO R.MEZZALIRA 20/03/03                             ³±± 
±±³CRIADO 2 CAMPOS NO SELECT PARA CONTEMPLAR O VLR DO PIS                  ³±± 
±±³UM COM ALIQUOTA DE 0.65 E O OUTRO COM A ALIQUOTA VIGENTE NO PARAMETRO   ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Private _aTrb    := {}
Private LIMITE   :=132
Private aOrdem   := {OemToAnsi("Por Grupo"),OemToAnsi("Por Valor")}	
Private nPag     := 0

Private nPOSTOTAL := 0
Private nPOSMARG  := 0
Private nPOSRESU  := 0
   
Private nNEGTOTAL := 0
Private nNEGMARG  := 0
Private nNEGRESU  := 0

Private nRESTOTAL := 0
Private nRESMARG  := 0
Private nRESRESU  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo    := "Faturamento por Vendedor"
cDesc1    := "Este relatorio emite a relacao de faturamento. Podera ser"
cDesc2    := "emitido por ordem de Cliente ou por Valor (Ranking).     "
cDesc3    := "Se no TES estiver gera duplicata (N), nao sera computado."

CbTxt     := ""
CbCont    := ""

Cabec1    := ""
Cabec2    := ""

wnrel     := ""
Tamanho   := "G"
cString   := "SD2"
       
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg  := "MTR_CONTRA"
nLastKey  := 0

cPerg   := "MTCONT"+SPACE(4)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01         // A partir da data                         ³
//³ mv_par02         // Ate a data                               ³
//³ mv_par03         // Do Grupo Contrato                        ³
//³ mv_par04         // Ao Grupo Contrato                        ³
//³ mv_par05         // Analitico/Sintentico/Anal_Mens           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ajustaSx1(cPerg)

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  := "CONTRATO"            //Nome Default do relatorio em Disco
//wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,"","","",.F.,aOrdem,,Tamanho)
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,"","","",.f.,  aOrdem,.f.,tamanho,"",.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Processa({|| P580Gera()},"Aguarde !!! Selecionando Registros ...")
RptStatus({|| C580Imp()},"Aguarde !!! Gerando Relatorio de Contratos ...")


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ P580GERA³ Autor ³  Adriano P.Pavan      ³ Data ³ 23/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Chamada da Query                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ AGPR011                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function P580Gera()

Titulo    := "Relatorio Faturamento por Grupos de Contrato"
cDesc1    := "Este relatorio emite uma relacao de faturamento por Grupo de  "
cDesc2    := "Contrato. Pemitido por ordem de Grupo ou por Valor (Ranking). "
cDesc3    := "Se no TES estiver gera duplicata (N), nao sera computado."
CbCont    := ""
Cabec1    := ""
Cabec2    := ""
Tamanho   := "G"
aCampos   := {}
aTam      := {}
nAg1      := 0
nAg2      := 0
nAg3      := 0
nAg4      := 0
nRank     := 0
_cVend    := ""
_nValBrut := 0
_nValMerc := 0                                                   
_nQuant   := 0
_nImposto := 0
_cEMISSAO := "" 
cFiltro   := ""
_nValpisvel :=0 
_nValpisnov :=0
aTamVal   := { 16, 2 }
If aReturn[4] == 1
	nTipo := 15
Else
	nTipo := 18
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt    := SPACE(10)
CbCont   := 0


Titulo := "FATURAMENTO POR GRUPOS DE CONTRATO " 

cCabec1 := "|--------|------------------------------|----------------------------------------|---------------------------------------|-----------------------------------------|"
cCabec2 := "|        |                              |       Operacoes com Lucratividade      |          Operacoes Negativas          |             Resultado das Operacoes     |"
cCabec3 := "|--------|------------------------------|---------------|---------------|--------|--------------|---------------|--------|--------------|---------------|----------|-----------|-------|"
cCabec4 := "| GRUPO  | DESCRICAO DO GRUPO           |  R$ VENDAS    |   R$ MARGEM   |% MARGEM|  R$ VENDAS   |   R$ MARGEM   |% MARGEM|  R$ VENDAS   |   R$ MARGEM   | % MARGEM |  ANO / MES|   %   |"           
cCabec5 := "|        |                              |    S/ IPI     |               |        |    S/IPI     |               |        |    S/ IPI    |               |          |           |       |"   
cCabec6 := "|--------|------------------------------|---------------|---------------|--------|--------------|---------------|--------|--------------|---------------|----------|-----------|-------|" 
cCabec7 := "|        |                              |               |               |        |              |               |        |              |               |          |           |       |"
//		     0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa Query totalizando por Vendedor                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaSQL()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ C580IMP  ³ Autor ³ Adriano P.Pavan      ³ Data ³ 23/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Chamada do Relatorio                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AGPR011                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C580Imp()
Local nY     := 0
Local SomaPer:= 0  

li       := 80
nPag     := 1


SetRegua(Len(_aTrb))


For nY := 1 to Len(_aTrb)

	IncRegua()

	If li > 55
      Cabec02()
 	Endif
	
	@ li,000        PSAY "|"                                                                                            
	@ li,PCOL()+1   PSAY _aTrb[nY][01]                                 // 10 Grupo                                                                                            
	@ li,PCOL()+1   PSAY "|"
	@ li,PCOL()     PSAY _aTrb[nY][02]                                 // 30 Descricao
	@ li,PCOL()     PSAY "|"
	@ li,PCOL()+1   PSAY _aTrb[nY][03] Picture "@E 999,999,999.99"    // 15 D2_TOTAL
	@ li,PCOL()     PSAY "|"
	@ li,PCOL()+1   PSAY _aTrb[nY][04] Picture "@E 999,999,999.99"    // 15 D2_X_MARGV * D2_QUANT
	@ li,PCOL()     PSAY "|"
	@ li,PCOL()+2   PSAY _aTrb[nY][05] Picture "@E 999.99"            // 15 D2_X_MARGV * D2_QUANT / D2_TOTAL *100
	@ li,PCOL()     PSAY "|"
	@ li,PCOL()     PSAY _aTrb[nY][06] Picture "@E 999,999,999.99"    // 15 D2_X_MARGV * D2_QUANT / D2_TOTAL *100
	@ li,PCOL()     PSAY "|"
	@ li,PCOL()+1   PSAY _aTrb[nY][07] Picture "@E 999,999,999.99"    // 15 D2_X_MARGV * D2_QUANT / D2_TOTAL *100
	@ li,PCOL()     PSAY "|"
	@ li,PCOL()+2   PSAY _aTrb[nY][08] Picture "@E 999.99"            // 08 D2_X_MARGV * D2_QUANT / D2_TOTAL *100 NEGATIVO 
	@ li,PCOL()     PSAY "|"
	@ li,PCOL()     PSAY _aTrb[nY][09] Picture "@E 999,999,999.99"    // 15 D2_X_MARGV * D2_QUANT / D2_TOTAL *100
	@ li,PCOL()     PSAY "|"
	@ li,PCOL()+1   PSAY _aTrb[nY][10] Picture "@E 999,999,999.99"    // 15 D2_X_MARGV * D2_QUANT / D2_TOTAL *100
	@ li,PCOL()     PSAY "|"
	@ li,PCOL()+4   PSAY _aTrb[nY][11] Picture "@E 999.99"            // 08 D2_X_MARGV * D2_QUANT / D2_TOTAL *100 NEGATIVO 
	@ li,PCOL()     PSAY "|"
  	@ li,PCOL()+1   PSAY _aTrb[nY][12]+" / "+ _aTrb[nY][13]                
	@ li,PCOL()+1   PSAY "|"
  	@ li,PCOL()+1   PSAY ROUND( ( _aTrb[nY][09] * 100 ) / NRESTOTAL ,2) Picture "@E 999.99"
	@ li,PCOL()     PSAY "|"

	li := li + 1

   SomaPer := SomaPer + ROUND( ( _aTrb[nY][09] * 100 ) / NRESTOTAL ,2)

Next nY


If li > 52
   Cabec02()
Else
	@ li,000        PSAY cCabec7  // SPACO
   li := li + 1
   @ li,000        PSAY cCabec6  // LINHA
	li := li + 1
	@ li,000        PSAY cCabec7  // SPACO
	li := li + 1
Endif

@ li,000        PSAY "|"
@ li,PCOL()+1   PSAY space(6)                                      // 10 Grupo                                                                                            163
@ li,PCOL()+1   PSAY "|"
@ li,PCOL()     PSAY "T O T A L --->"+SPACE(16)                   // 30 Descricao
@ li,PCOL()     PSAY "|"
@ li,PCOL()+1   PSAY nPOSTOTAL Picture "@E 999,999,999.99"    // 15 D2_TOTAL
@ li,PCOL()     PSAY "|"
@ li,PCOL()+1   PSAY nPOSMARG  Picture "@E 999,999,999.99"    // 15 D2_X_MARGV * D2_QUANT
@ li,PCOL()     PSAY "|"
@ li,PCOL()+2   PSAY nPOSRESU  Picture "@E 999.99"            // 15 D2_X_MARGV * D2_QUANT / D2_TOTAL *100
@ li,PCOL()     PSAY "|"
@ li,PCOL()     PSAY nNEGTOTAL Picture "@E 999,999,999.99"    // 15 D2_X_MARGV * D2_QUANT / D2_TOTAL *100
@ li,PCOL()     PSAY "|"
@ li,PCOL()+1   PSAY nNEGMARG  Picture "@E 999,999,999.99"    // 15 D2_X_MARGV * D2_QUANT / D2_TOTAL *100
@ li,PCOL()     PSAY "|"
@ li,PCOL()+2   PSAY nNEGRESU  picture "@E 999.99"            // 08 D2_X_MARGV * D2_QUANT / D2_TOTAL *100 NEGATIVO
@ li,PCOL()     PSAY "|"
@ li,PCOL()     PSAY nRESTOTAL Picture "@E 999,999,999.99"    // 15 D2_X_MARGV * D2_QUANT / D2_TOTAL *100
@ li,PCOL()     PSAY "|"
@ li,PCOL()+1   PSAY nRESMARG  Picture "@E 999,999,999.99"    // 15 D2_X_MARGV * D2_QUANT / D2_TOTAL *100
@ li,PCOL()     PSAY "|"
@ li,PCOL()+4   PSAY nRESRESU  Picture "@E 999.99"            // 08 D2_X_MARGV * D2_QUANT / D2_TOTAL *100 NEGATIVO
@ li,PCOL()     PSAY "|"
@ li,PCOL()+11  PSAY "|"
@ li,PCOL()+1   PSAY SomaPer picture "@E 999.99" 
@ li,PCOL()     PSAY "|"

li := li + 1
@ li,000        PSAY cCabec7
li := li + 1
@ li,000        PSAY cCabec6


Roda(CbCont,CbTxt)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Set Device to Screen

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

DbSelectArea("TMP")
DbCloseArea()

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ CriaSQL  ³ Autor ³ Adriano P.Pavan      ³ Data ³ 23.08.00  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Gera a Query com as totalizacoes por Vendedor              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CriaSQL()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriaSQL()
Local cQuery  :=""                
Local aStru   := SD2->(dbStruct())
LOCAL nOrdem  := aReturn[8]
Local nY      := 0

_aTrb:= {}
nPOSTOTAL := 0
nPOSMARG  := 0
nPOSRESU  := 0
nNEGTOTAL := 0
nNEGMARG  := 0
nNEGRESU  := 0
nRESTOTAL := 0
nRESMARG  := 0
nRESRESU  := 0

// Observacao: O percentual e demostrado em todos  os tipos de consulta mas o mes somente nas analiticas.
//
//


cQuery :=             " Select A1_X_GRPCO GRUPO, "

IF MV_PAR05 <> 2
   cQuery += _nD_ENTER + "        SUBSTR(D2_EMISSAO,1,4) ANO, "   
   cQuery += _nD_ENTER + "        SUBSTR(D2_EMISSAO,5,2) MES, "   
Endif

cQuery += _nD_ENTER + "        Z11_DESCRI DESCC, "   

//--- RETORNO DO SIGN  
//-- If number < 0, then sign returns -1.
//-- If number = 0, then sign returns 0.
//-- If number > 0, then sign returns 1.
If MV_PAR05=1
   cQuery += _nD_ENTER + "D2_TOTAL RESTOTAL, "
   cQuery += _nD_ENTER + "D2_X_MARGV*D2_QUANT RESMARG, "   
   cQuery += _nD_ENTER + "DECODE( SIGN(D2_X_MARGV) , -1 , D2_TOTAL  , 0 , D2_TOTAL  )                            AS NEGTOTAL, "
   cQuery += _nD_ENTER + "DECODE( SIGN(D2_X_MARGV) , -1 , D2_X_MARGV * D2_QUANT , 0 , D2_X_MARGV * D2_QUANT    ) AS NEGMARG,  "
   cQuery += _nD_ENTER + "DECODE( SIGN(D2_X_MARGV) ,  1 , D2_TOTAL                  )                            AS POSTOTAL, "
   cQuery += _nD_ENTER + "DECODE( SIGN(D2_X_MARGV) ,  1 , D2_X_MARGV * D2_QUANT                               )  AS POSMARG   "
ElseIf MV_PAR05=2 .or. MV_PAR05=3
   cQuery += _nD_ENTER + "SUM(D2_TOTAL) RESTOTAL, "
   cQuery += _nD_ENTER + "SUM(D2_X_MARGV*D2_QUANT) RESMARG, "   
	cQuery += _nD_ENTER + "SUM( DECODE( SIGN(D2_X_MARGV) , -1 , D2_TOTAL  , 0 , D2_TOTAL  ))                            AS NEGTOTAL, "
   cQuery += _nD_ENTER + "SUM( DECODE( SIGN(D2_X_MARGV) , -1 , D2_X_MARGV * D2_QUANT , 0 , D2_X_MARGV * D2_QUANT    )) AS NEGMARG,  "
   cQuery += _nD_ENTER + "SUM( DECODE( SIGN(D2_X_MARGV) ,  1 , D2_TOTAL                  ))                            AS POSTOTAL, "
   cQuery += _nD_ENTER + "SUM( DECODE( SIGN(D2_X_MARGV) ,  1 , D2_X_MARGV * D2_QUANT                               ))  AS POSMARG   "
Endif

cQuery += _nD_ENTER + " From SB1010 SB1 ,SA1010 SA1 ,SF4010 SF4 ,SD2010 SD2,Z11010 Z11 "  
cQuery += _nD_ENTER + " Where "   
cQuery += _nD_ENTER + " A1_FILIAL = D2_FILIAL    AND "  
cQuery += _nD_ENTER + " A1_COD    = D2_CLIENTE   AND "  
cQuery += _nD_ENTER + " A1_LOJA   = D2_LOJA      AND "  

cQuery += _nD_ENTER + " B1_FILIAL = '  '         AND "  
cQuery += _nD_ENTER + " B1_COD    = D2_COD       AND "  

//cQuery += _nD_ENTER + " D2_X_MARGV>=0            AND "   

cQuery += _nD_ENTER + " F4_FILIAL = '  '         AND "  
cQuery += _nD_ENTER + " F4_CODIGO = D2_TES       AND "  
cQuery += _nD_ENTER + " F4_DUPLIC = 'S'          AND "  

cQuery += _nD_ENTER + " Z11_GRPCON= A1_X_GRPCO   AND "  

cQuery += _nD_ENTER + " D2_TIPO  NOT IN ('D','I','B') AND "  

cQuery += _nD_ENTER + " D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND "  

cQuery += _nD_ENTER + " A1_X_GRPCO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "  

cQuery += _nD_ENTER + " SB1.D_E_L_E_T_ <> '*'    AND "  
cQuery += _nD_ENTER + " SA1.D_E_L_E_T_ <> '*'    AND "  
cQuery += _nD_ENTER + " SD2.D_E_L_E_T_ <> '*'    AND "  
cQuery += _nD_ENTER + " Z11.D_E_L_E_T_ <> '*'        "  
 
If MV_PAR05=2
  cQuery += _nD_ENTER + " Group by A1_X_GRPCO , Z11_DESCRI  "  
ElseIf MV_PAR05=3
  cQuery += _nD_ENTER + " Group by A1_X_GRPCO,SUBSTR(D2_EMISSAO,1,4),SUBSTR(D2_EMISSAO,5,2), Z11_DESCRI "  
Endif  


If aReturn[8] == 1 
   If MV_PAR05<> 2
      cQuery += _nD_ENTER + "ORDER BY GRUPO,SUBSTR(D2_EMISSAO,1,4),SUBSTR(D2_EMISSAO,5,2) "  
   Else 
      cQuery += _nD_ENTER + "ORDER BY GRUPO "  
   Endif
Else
   cQuery += _nD_ENTER + "ORDER BY RESTOTAL DESC "  
Endif
 
MEMOWRITE("MTR_CONTRA",cQuery)

cQuery := ChangeQuery(cQuery)

		
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)
For nX := 1 To Len(aStru)
	If ( aStru[nX][2] <> "C" .and. alltrim(aStru[nX][1])$cQuery )
		TcSetField("TMP",aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
	EndIf
Next nX
		
DbgoTop()


dbSelectArea("TMP")
dbGoTop()

While !TMP->(Eof())



   AADD(_aTrb,{SUBSTR(TMP->GRUPO,1,6),;
               SUBSTR(TMP->DESCC,1,30),;
					TMP->POSTOTAL,;
					TMP->POSMARG,;
               ROUND(TMP->POSMARG / TMP->POSTOTAL * 100,2),; 
					TMP->NEGTOTAL,;
               TMP->NEGMARG,; 
               ROUND(TMP->NEGMARG / TMP->NEGTOTAL * 100,2),;  
					TMP->RESTOTAL,;
					TMP->POSMARG  + TMP->NEGMARG,;
               ROUND( (TMP->POSMARG + TMP->NEGMARG)/ (TMP->RESTOTAL) * 100,2),; 
               IF(MV_PAR05 <> 2,TMP->ANO,SPACE(4)),;
               IF(MV_PAR05 <> 2,TMP->MES,SPACE(2))})

			 //TMP->POSTOTAL - TMP->NEGTOTAL,;
          //ROUND( (TMP->POSMARG + TMP->NEGMARG)/ (TMP->POSTOTAL - TMP->NEGTOTAL) * 100,2),; 
 		
 
   nY:= Len(_aTrb)
   
	nPOSTOTAL += _aTrb[nY][03]               // POSITIVOS
	nPOSMARG  += _aTrb[nY][04]
   nPOSRESU  := ROUND(nPOSMARG / nPOSTOTAL * 100,2) 
   
	nNEGTOTAL += _aTrb[nY][06]               // NEGATIVOS
	nNEGMARG  += _aTrb[nY][07]
   nNEGRESU  := ROUND(nNEGMARG / nNEGTOTAL * 100,2) 

	nRESTOTAL += _aTrb[nY][09]               // TOTAL
	nRESMARG  += _aTrb[nY][10]
   nRESRESU  := ROUND(nRESMARG / nRESTOTAL * 100,2) 


  

	dbSelectArea("TMP")
	dbSkip()

Enddo

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ Cabec02  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Gera o SX1                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Cabec02()

if nPag >= 2
	@ li,000   PSAY cCabec6 // fecha a pagina
	Roda(CbCont,CbTxt)
Endif
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
li:=PROW()
li := li + 1
@ li,000   PSAY cCabec1
li := li + 1
@ li,000   PSAY cCabec2
li := li + 1
@ li,000   PSAY cCabec3
li := li + 1
@ li,000   PSAY cCabec4
li := li + 1
@ li,000   PSAY cCabec5
li := li + 1
@ li,000   PSAY cCabec6
li := li + 1
@ li,000   PSAY cCabec7
li := li + 1
nPag++

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ AjustaSx1³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Gera o SX1                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1(cPerg)

Local _aPerguntas:= {} 

AADD(_aPerguntas,{cPerg,"01","A partir da Data    ?","mv_ch1","D",08,0,0,"G","","mv_par01","               ","","","             ","","","               ","","","                     ","","","               ","","   ",})
AADD(_aPerguntas,{cPerg,"02","Ate a Data          ?","mv_ch2","D",08,0,0,"G","","mv_par02","               ","","","             ","","","               ","","","                     ","","","               ","","   ",})
AADD(_aPerguntas,{cPerg,"03","Do Grupo  Contrato  ?","mv_ch3","C",06,0,0,"G","","mv_par03","               ","","","             ","","","               ","","","                     ","","","               ","","Z11",})
AADD(_aPerguntas,{cPerg,"04","Ate o Grupo de Contr?","mv_ch4","C",06,0,0,"G","","mv_par04","               ","","","             ","","","               ","","","                     ","","","               ","","Z11",})
AADD(_aPerguntas,{cPerg,"05","Analitivo/Sintetico ?","mv_ch5","N",01,0,0,"C","","mv_par05","Analitico      ","","","Sintetico    ","","","               ","","","                     ","","","               ","","   ",})

dbSelectArea("SX1")

For _nLaco:=1 to LEN(_aPerguntas)
	If !dbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
		RecLock("SX1",.T.)
		SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
		SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
		SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
		SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
		SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
		SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
		SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
		SX1->X1_Presel    := _aPerguntas[_nLaco,08]
		SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
		SX1->X1_Valid     := _aPerguntas[_nLaco,10]
		SX1->X1_Var01     := _aPerguntas[_nLaco,11]
		SX1->X1_Def01     := _aPerguntas[_nLaco,12]
		SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
		SX1->X1_Var02     := _aPerguntas[_nLaco,14]
		SX1->X1_Def02     := _aPerguntas[_nLaco,15]
		SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
		SX1->X1_Var03     := _aPerguntas[_nLaco,17]
		SX1->X1_Def03     := _aPerguntas[_nLaco,18]
		SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
		SX1->X1_Var04     := _aPerguntas[_nLaco,20]
		SX1->X1_Def04     := _aPerguntas[_nLaco,21]
		SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
		SX1->X1_Var05     := _aPerguntas[_nLaco,23]
		SX1->X1_Def05     := _aPerguntas[_nLaco,24]
		SX1->X1_Cnt05     := _aPerguntas[_nLaco,25]
		SX1->X1_F3        := _aPerguntas[_nLaco,26]
		MsUnLock()
	EndIf
NEXT

Return

