#include "rwmake.ch"

User Function agpr011()

SetPrvt("CBTXT,TITULO,CDESC1,CDESC2,CDESC3,CBCONT")
SetPrvt("CABEC1,CABEC2,WNREL,TAMANHO,LIMITE,CSTRING")
SetPrvt("LCONTINUA,LEND,CMOEDA,NMOEDA,CNFISCAL,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,ACAMPOS,ATAM")
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
±±³ Funcao    ³ AGPR011  ³ Autor ³ Adriano P.Pavan       ³ Data ³ 23.08.00 ³±±
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt     := ""
Titulo    := "Faturamento por Vendedor"
cDesc1    := "Este relatorio emite a relacao de faturamento. Podera ser"
cDesc2    := "emitido por ordem de Cliente ou por Valor (Ranking).     "
cDesc3    := "Se no TES estiver gera duplicata (N), nao sera computado."
CbCont    := ""
Cabec1    := ""
Cabec2    := ""
wnrel     := ""
Tamanho   := "M"
Limite    := 132
cString   := "SF2"
lContinua := .T.
lEnd      := .F.
cMoeda    := ""
nMoeda    := ""
cNFiscal  := ""

aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg  := "AGPR011"
aLinha    := {}
nLastKey  := 0

_cAlias   := Alias()
_nOrder   := dbSetOrder()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPerg   := "AGP011"

//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Variaveis utilizadas para parametros                         ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01         // A partir da data                         ³
//³ mv_par02         // Ate a data                               ³
//³ mv_par03         // Do Vendedor                              ³
//³ mv_par04         // Ao Vendedor                              ³
//³ mv_par05         // Por Codigo ou valor                      ³
//³ mv_par06         // Moeda                                    ³
//³ mv_par07         // Inclui Devolucao                         ³
//³ mv_par08         // TES Qto Faturamento                      ³
//³ mv_par09         // TES Qto Estoque                          ³
//³ mv_par10         // Da Filial                                ³
//³ mv_par11         // Ate a Filial                             ³
//³ mv_par12         // Do Cliente                               ³
//³ mv_par13         // Ate o Cliente                            ³
//³ mv_par14         // Do Produto                               ³
//³ mv_par15         // Ate o Produto                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//³ O trecho de programa abaixo verifica se o arquivo SX1 esta   ³
//³ atualizado. Caso nao, deve ser inserido o grupo de perguntas ³
//³ que sera utilizado.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerguntas:= {}

AADD(_aPerguntas,{"AGP011","01","A partir da Data   ?","mv_ch1","D",08,0,0,"G","","mv_par01","               ","","","             ","","","               ","","","                     ","","","               ","","   ",})
AADD(_aPerguntas,{"AGP011","02","Ate a Data         ?","mv_ch2","D",08,0,0,"G","","mv_par02","               ","","","             ","","","               ","","","                     ","","","               ","","   ",})
AADD(_aPerguntas,{"AGP011","03","Do Vendedor        ?","mv_ch3","C",06,0,0,"G","","mv_par03","               ","","","             ","","","               ","","","                     ","","","               ","","SA3",})
AADD(_aPerguntas,{"AGP011","04","Ate o Vendedor     ?","mv_ch4","C",06,0,0,"G","","mv_par04","               ","","","             ","","","               ","","","                     ","","","               ","","SA3",})
AADD(_aPerguntas,{"AGP011","05","Lista por          ?","mv_ch5","N",01,0,0,"C","","mv_par05","Vendedor       ","","","Ranking      ","","","               ","","","                     ","","","               ","","   ",})
AADD(_aPerguntas,{"AGP011","06","Qual a Moeda       ?","mv_ch6","N",01,0,0,"C","","mv_par06","1a Moeda       ","","","2a Moeda     ","","","3a Moeda       ","","","4a Moeda             ","","","5a Moeda       ","","   ",})
AADD(_aPerguntas,{"AGP011","07","Inclui Devolucao   ?","mv_ch7","N",01,0,0,"C","","mv_par07","Sim            ","","","Nao          ","","","               ","","","                     ","","","               ","","   ",})
AADD(_aPerguntas,{"AGP011","08","TES Qto Faturamento?","mv_ch8","N",01,0,0,"C","","mv_par08","Gera Financeiro","","","Nao Gera     ","","","Considera Ambas","","","                     ","","","               ","","   ",})
AADD(_aPerguntas,{"AGP011","09","TES Qto Estoque    ?","mv_ch9","N",01,0,0,"C","","mv_par09","Movimenta      ","","","Nao Movimenta","","","Considera Ambas","","","                     ","","","               ","","   ",})
AADD(_aPerguntas,{"AGP011","10","Da Filial          ?","mv_cha","C",02,0,0,"G","","mv_par10","               ","","","             ","","","               ","","","                     ","","","               ","","   ",})
AADD(_aPerguntas,{"AGP011","11","Ate a Filial       ?","mv_chb","C",02,0,0,"G","","mv_par11","               ","","","             ","","","               ","","","                     ","","","               ","","   ",})
AADD(_aPerguntas,{"AGP011","12","Do Cliente         ?","mv_chc","C",06,0,0,"G","","mv_par12","               ","","","             ","","","               ","","","                     ","","","               ","","CLI",})
AADD(_aPerguntas,{"AGP011","13","Ate o Cliente      ?","mv_chd","C",06,0,0,"G","","mv_par13","               ","","","             ","","","               ","","","                     ","","","               ","","CLI",})
AADD(_aPerguntas,{"AGP011","14","Do Produto         ?","mv_che","C",15,0,0,"G","","mv_par14","               ","","","             ","","","               ","","","                     ","","","               ","","SB1",})
AADD(_aPerguntas,{"AGP011","15","Ate o Produto      ?","mv_chf","C",15,0,0,"G","","mv_par15","               ","","","             ","","","               ","","","                     ","","","               ","","SB1",})

dbSelectArea("SX1")

/*/
If dbSeek(_aPerguntas[1,1]+_aPerguntas[1,2])
	Do While SX1->X1_GRUPO == "AGP011"
		RecLock("SX1",.F.)
		DELETE
		MsUnLock()
		dbSkip()
	EndDo
EndIf
/*/

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

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  := "AGPR011"            //Nome Default do relatorio em Disco
wnrel  := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	dbSelectArea(_cAlias)
	dbSetOrder(_nOrder)
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbSelectArea(_cAlias)
	dbSetOrder(_nOrder)
	Return
Endif

Processa({|| P580Gera()},"Aguarde !!! Selecionando Registros ...")
RptStatus({|| C580Imp()},"Aguarde !!! Gerando Relatorio de Vendedores ...")

dbSelectArea(_cAlias)
dbSetOrder(_nOrder)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ P580GERA ³ Autor ³ Adriano P.Pavan      ³ Data ³ 23/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Chamada da Query                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ AGPR011                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function P580Gera()

Titulo    := "Faturamento por Vendedor"
cDesc1    := "Este relatorio emite a relacao de faturamento. Podera ser"
cDesc2    := "emitido por ordem de Cliente ou por Valor (Ranking).     "
cDesc3    := "Se no TES estiver gera duplicata (N), nao sera computado."
CbCont    := ""
Cabec1    := ""
Cabec2    := ""
Tamanho   := "M"
Limite    := 132
aCampos   := {}
aTam      := {}
nAg1      := 0
nAg2      := 0
nAg3      := 0
nAg4      := 0
nRank     := 0
nMoeda    := 0
cMoeda    := ""
cDupli    := If( (MV_PAR08 == 1),"'S'",If( (MV_PAR08 == 2),"'N'","'S','N'" ) )
cEstoq    := If( (MV_PAR09 == 1),"'S'",If( (MV_PAR09 == 2),"'N'","'S','N'" ) )
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
li       := 80
m_pag    := 1
nMoeda   := mv_par06
cMoeda   := "MV_MOEDA" + STR(nMoeda,1)

If mv_par05 == 1
	Titulo := "FATURAMENTO POR VENDEDOR  (CODIGO) - "  + GetMV(cMoeda)
Else
	Titulo := "FATURAMENTO POR VENDEDOR  (RANKING) - " + GetMV(cMoeda)
Endif

Cabec1 := "CODIGO   NOME DO VENDEDOR                                FATURAMENTO          VALOR DA                 VALOR     RANKING     QUANT."
Cabec2 := "                                                        SEM IMPOSTOS         MERCADORIA                TOTAL                 LITROS"

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

dbSelectArea("TRB")
SetRegua(RecCount())

If mv_par05 == 2
	dbSetOrder(2)
Else
	dbSetOrder(1)
Endif

dbGoTop()

While !Eof()
	IncRegua()
	If li > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	Endif
	
	_cVendedor  := TRB->TB_VEND + "  " + TRB->TB_NOME
	_nImposto   := TRB->TB_IMPOSTO
	_nQuant     := TRB->TB_QUANT                            
	_nValMerc   := TRB->TB_VALMERC
	_nValBrut   := TRB->TB_VALBRUT
    _nValpisvel := TRB->TB_VLPVEL
    _nValpisnov := TRB->TB_VLPNOV
                          
   
  ///	_nPisCof   := 1 - ((GetMv("MV_TXPIS")/100) + (GetMv("MV_TXCOFIN")/100))
	
	
	If mv_par07 = 1   .and.  TMP->TB_QTSGDEV <> 0
		//_nValSImp  := _nValMerc * ( 1 - _nPisCof )
	   	//_nValSImp  := _nImposto * ( 1 - _nPisCof )
		_nValSImp  := _nImposto 
	Else                                                             
	    ///   _nValSImp  := _nValBrut - _nImposto - (_nValMerc * _nPisCof ) 
         _nValSImp  := _nValBrut - _nImposto - (_nValpisvel +_nValpisnov) 
       
    Endif
	
	@ li,00  PSAY _cVendedor
	@ li,50  PSAY _nValSImp PicTure tm(_nValSImp,18)
	@ li,70  PSAY _nValMerc PicTure tm(_nValMerc,18)
	@ li,90  PSAY _nValBrut PicTure tm(_nValBrut,18)
	If mv_par05 == 2
		nRank := nRank + 1
		@ li,114 PSAY nRank PicTure "9999"
	Endif
	@ li,120 PSAY _nQuant   PicTure "999,999,999"
	
	li := li + 1
	
	nAg1 := nAg1 + _nValSImp
	nAg2 := nAg2 + _nValMerc
	nAg3 := nAg3 + _nValBrut
	nAg4 := nAg4 + _nQuant
	
	dbSkip()
EndDo

If li != 80
	@ li,  0 PSAY "T O T A L --->"
	@ li, 50 PSAY nAg1 PicTure tm(nAg1,18)
	@ li, 70 PSAY nAg2 PicTure tm(nAg2,18)
	@ li, 90 PSAY nAg3 PicTure tm(nAg3,18)
	@ li,120 PSAY nAg4 PicTure "999,999,999"
	Roda(CbCont,CbTxt)
Endif

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

DbSelectArea("TRB")
DbCloseArea()
Ferase(cNomeArq+".DBF")
Ferase(cNomeArq+".IDX")

dbSelectArea(_cAlias)
dbSetOrder(_nOrder)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ CriaSQL  ³ Autor ³ Adriano P.Pavan      ³ Data ³ 23.08.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Gera a Query com as totalizacoes por Vendedor             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ CriaSQL()                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CriaSQL()


_nPisCof   := STR(((GetMv("MV_TXPIS")/100) + (GetMv("MV_TXCOFIN")/100)))

//--> SÓ PARA TOTALIZAR
cQuery :=          "SELECT  COUNT(SF2.F2_VEND1) AS SOMA "
cQuery := cQuery + " FROM     " + RetSQLName("SD2") + " SD2, " + RetSQLName("SF2") + " SF2, " + RetSQLName("SA3") + " SA3, "
cQuery := cQuery +                RetSQLName("SF4") + " SF4  " 

                               // Separa o SF2
cQuery := cQuery + " WHERE    SF2.F2_FILIAL  BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "' "
cQuery := cQuery + " AND      SF2.F2_CLIENTE BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "' "
cQuery := cQuery + " AND      SF2.F2_VEND1   BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
cQuery := cQuery + " AND      SF2.F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "  // ALMEIDA


                               // Separa o SD2                                 
cQuery := cQuery + " AND      SD2.D2_FILIAL  = SF2.F2_FILIAL "  
cQuery := cQuery + " AND      SD2.D2_DOC     = SF2.F2_DOC    "
cQuery := cQuery + " AND      SD2.D2_SERIE   = SF2.F2_SERIE  "
cQuery := cQuery + " AND      SD2.D2_CLIENTE = SF2.F2_CLIENTE "     
cQuery := cQuery + " AND      SD2.D2_LOJA    = SF2.F2_LOJA "     
cQuery := cQuery + " AND      SD2.D2_COD     BETWEEN '" + mv_par14 + "' AND '" + mv_par15 + "' "

                               // Separa o SA3
cQuery := cQuery + " AND      SA3.A3_COD    = SF2.F2_VEND1 "

                               // Separa o SF4                                 
cQuery := cQuery + " AND      SD2.D2_FILIAL = SF4.F4_FILIAL"
cQuery := cQuery + " AND      SD2.D2_TES    = SF4.F4_CODIGO "

                               // Filtros 
cQuery := cQuery + " AND      SF2.F2_TIPO    IN ('N','C') "
cQuery := cQuery + " AND      SF4.F4_DUPLIC  IN ("+ cDupli +") "
cQuery := cQuery + " AND      SF4.F4_ESTOQUE IN ("+ cEstoq +") "
cQuery := cQuery + " AND      SD2.D2_GRUPO   <> ''  "
cQuery := cQuery + " AND      SD2.D2_TP      =  'PA' "
cQuery := cQuery + " AND      SA3.A3_X_TAB IN ('1','2','4','5') "
cQuery := cQuery + " AND      SUBSTRING(SA3.A3_COD,1,1) <> '7' "

cQuery := cQuery + " AND      SF2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + " AND      SD2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + " AND      SA3.D_E_L_E_T_ <> '*' "
cQuery := cQuery + " AND      SF4.D_E_L_E_T_ <> '*' "


dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP", .F., .T.)
_nTotSQL := (TMP->SOMA)
dbCloseArea()




cQuery :=  "SELECT  SF2.F2_VEND1 TB_VEND, SA3.A3_NOME TB_NOME, "
If mv_par07==1  
    cQuery := cQuery + " SUM((( SD2.D2_TOTAL + SD2.D2_VALIPI + SD2.D2_ICMSRET )/ SD2.D2_QUANT) *( SD2.D2_QUANT-SD2.D2_QTDEDEV )) TB_VALBRUT, "
Else
	cQuery := cQuery + " SUM( SD2.D2_TOTAL + SD2.D2_VALIPI + SD2.D2_ICMSRET ) TB_VALBRUT, "
Endif
If mv_par07==1 
	cQuery := cQuery + " SUM((SD2.D2_TOTAL/SD2.D2_QUANT)*(SD2.D2_QUANT-SD2.D2_QTDEDEV)) TB_VALMERC, "
    cQuery := cQuery + " 0  TB_VLPVEL,"  
    cQuery := cQuery + " 0  TB_VLPNOV,"
Else
	cQuery := cQuery + " SUM(SD2.D2_TOTAL) TB_VALMERC, " 
    cQuery := cQuery + " (SUM(CASE WHEN SD2.D2_EMISSAO < '20030301' THEN SD2.D2_TOTAL ELSE 0 END ) * 0.0365 )  TB_VLPVEL , " 
    cQuery := cQuery + " (SUM(CASE WHEN SD2.D2_EMISSAO < '20030301' THEN 0 ELSE SD2.D2_TOTAL END )* "+_nPisCof+" ) TB_VLPNOV, " 
Endif
cQuery := cQuery + " SUM( CASE "
cQuery := cQuery + "        WHEN SD2.D2_UM <> 'LT' THEN "
cQuery := cQuery + "             SD2.D2_QTSEGUM "
cQuery := cQuery + "        ELSE "
cQuery := cQuery + "             SD2.D2_QUANT "
cQuery := cQuery + "        END) TB_QUANT, "

If mv_par07==1
  
	cQuery := cQuery + " SUM( CASE "
	cQuery := cQuery + " 	  WHEN SB1.B1_TIPCONV = 'M' THEN "
	cQuery := cQuery + " 			(SD2.D2_QTDEDEV*SB1.B1_CONV) "
	cQuery := cQuery + " 	  ELSE "
	cQuery := cQuery + " 			(SD2.D2_QTDEDEV/SB1.B1_CONV) "
	cQuery := cQuery + " END) TB_QTSGDEV, "

	cQuery := cQuery + " SUM( CASE  WHEN (SD2.D2_VALDEV > 0) THEN "
    cQuery := cQuery + " CASE WHEN SD2.D2_EMISSAO < '20030301' THEN ((SD2.D2_TOTAL/SD2.D2_QUANT)* (SD2.D2_QUANT-SD2.D2_QTDEDEV) ) - ( (SD2.D2_VALICM/SD2.D2_QUANT) * SD2.D2_QTDEDEV )* 0.9635 " 
    cQuery := cQuery + " ELSE (((SD2.D2_TOTAL/SD2.D2_QUANT)*(SD2.D2_QUANT - SD2.D2_QTDEDEV)) - ((SD2.D2_VALICM/SD2.D2_QUANT) * SD2.D2_QTDEDEV)) * (1 - "+_nPisCof+" ) END "
    cQuery := cQuery + " ELSE "
    cQuery := cQuery + "  ( CASE WHEN SD2.D2_EMISSAO < '20030301' THEN ROUND(((SD2.D2_VALICM+SD2.D2_VALIPI+SD2.D2_ICMSRET)* 0.9635),2) ELSE ROUND(((SD2.D2_VALICM+SD2.D2_VALIPI+SD2.D2_ICMSRET)* (1 - "+_nPisCof+")),2) END )"
	cQuery := cQuery + " END) TB_IMPOSTO  "
Else
	cQuery := cQuery + " 0 TB_QTSGDEV, "
	cQuery := cQuery + " SUM(ROUND(SD2.D2_VALICM+SD2.D2_VALIPI+SD2.D2_ICMSRET,2) ) TB_IMPOSTO "
Endif
cQuery := cQuery + " FROM     " + RetSQLName("SD2") + " SD2, " + RetSQLName("SF2") + " SF2, "
cQuery := cQuery +                RetSQLName("SA3") + " SA3, " + RetSQLName("SB1") + " SB1, "
cQuery := cQuery +                RetSQLName("SF4") + " SF4  " 

                              // Seleciona SF2
cQuery := cQuery + " WHERE    SF2.F2_FILIAL  BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "' "
cQuery := cQuery + " AND      SF2.F2_CLIENTE BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "' "
cQuery := cQuery + " AND      SF2.F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "  // ALMEIDA
cQuery := cQuery + " AND      SF2.F2_VEND1   BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "

                              // Seleciona SD2
cQuery := cQuery + " AND      SD2.D2_FILIAL  = SF2.F2_FILIAL"
cQuery := cQuery + " AND      SD2.D2_DOC     = SF2.F2_DOC "
cQuery := cQuery + " AND      SD2.D2_SERIE   = SF2.F2_SERIE "     
cQuery := cQuery + " AND      SD2.D2_CLIENTE = SF2.F2_CLIENTE "     
cQuery := cQuery + " AND      SD2.D2_LOJA    = SF2.F2_LOJA "     
cQuery := cQuery + " AND      SD2.D2_COD     BETWEEN '" + mv_par14 + "' AND '" + mv_par15 + "' "

                              // Seleciona SB1
cQuery := cQuery + " AND      SB1.B1_COD     = SD2.D2_COD "
                              
                              // Seleciona SA3                
cQuery := cQuery + " AND      SA3.A3_COD     = SF2.F2_VEND1 "

                               // Separa o SF4                                 
cQuery := cQuery + " AND      SD2.D2_FILIAL = SF4.F4_FILIAL"
cQuery := cQuery + " AND      SD2.D2_TES    = SF4.F4_CODIGO "

                               // Filtros 
cQuery := cQuery + " AND      SF2.F2_TIPO    IN ('N','C') "
cQuery := cQuery + " AND      SD2.D2_GRUPO   <> ''  "
cQuery := cQuery + " AND      SD2.D2_TP      =  'PA' "
cQuery := cQuery + " AND      SF4.F4_DUPLIC  IN ("+ cDupli +") "
cQuery := cQuery + " AND      SF4.F4_ESTOQUE IN ("+ cEstoq +") "
cQuery := cQuery + " AND      SA3.A3_X_TAB IN ('1','2','4','5') "
cQuery := cQuery + " AND      SUBSTRING(SA3.A3_COD,1,1) <> '7' "
cQuery := cQuery + " AND      SUBSTRING(SA3.A3_COD,1,1) <> '7' "
                                          

cQuery := cQuery + " AND      SF2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + " AND      SD2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + " AND      SF4.D_E_L_E_T_ <> '*' "
cQuery := cQuery + " AND      SA3.D_E_L_E_T_ <> '*' "
cQuery := cQuery + " AND      SB1.D_E_L_E_T_ <> '*' "
cQuery := cQuery + " GROUP BY SF2.F2_VEND1, SA3.A3_NOME"//,SF2.F2_EMISSAO "
cQuery := cQuery + " ORDER BY TB_VEND "

MEMOWRITE("agpr011.SQL",cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP", .F., .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam := TamSX3("A3_COD")
AADD(aCampos,{ "TB_VEND   ","C",aTam[1],aTam[2] } )
aTam := TamSX3("A3_NOME")
AADD(aCampos,{ "TB_NOME   ","C",aTam[1],aTam[2] } )
aTam := TamSX3("F2_VALFAT")
AADD(aCampos,{ "TB_VALBRUT","N",aTam[1],aTam[2] } )
aTam := TamSX3("F2_VALFAT")
AADD(aCampos,{ "TB_VALMERC","N",aTam[1],aTam[2] } )
AADD(aCampos,{ "TB_VLPVEL","N",aTam[1],aTam[2] } )
AADD(aCampos,{ "TB_VLPNOV","N",aTam[1],aTam[2] } )
aTam := TamSX3("D2_QUANT")
AADD(aCampos,{ "TB_QUANT  ","N",aTam[1],aTam[2] } )
aTam := TamSX3("D2_QUANT")
AADD(aCampos,{ "TB_QTSGDEV","N",aTam[1],aTam[2] } )
aTam := TamSX3("F2_VALFAT")
AADD(aCampos,{ "TB_IMPOSTO","N",aTam[1],aTam[2] } )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomeArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,, cNomeArq,"TRB", .T. , .F. )
cNomArq1 := Subs(cNomeArq,1,7)+"A"
IndRegua("TRB",cNomArq1,"TB_VEND",,,"Selecionando Registros...")
aTamVal  := TamSX3("F2_VALFAT")
cNomArq2 := Subs(cNomeArq,1,7)+"B"
IndRegua("TRB",cNomArq2,"DESCEND(TB_VALBRUT)",,,"Selecionando Registros...")
dbClearIndex()
dbSetIndex(cNomArq1+OrdBagExt())
dbSetIndex(cNomArq2+OrdBagExt())

dbSelectArea("TMP")
dbGoTop()
ProcRegua(_nTotSQL)
While !Eof()
	IncProc()
	ProcessMessages()
	_cVend      := TMP->TB_VEND
	_cNome      := TMP->TB_NOME
	_nQuant     := TMP->TB_QUANT - TMP->TB_QTSGDEV
	_nImposto   := TMP->TB_IMPOSTO
	_nValBrut   := TMP->TB_VALBRUT
	_nValMerc   := TMP->TB_VALMERC 
    _nValpisvel := TMP->TB_VLPVEL
    _nValpisnov := TMP->TB_VLPNOV
	dbSkip()
	RecLock("TRB",.T.)
	TRB->TB_VEND      := _cVend
	TRB->TB_NOME      := _cNome
	TRB->TB_VALBRUT   := _nValBrut
	TRB->TB_VALMERC   := _nValMerc
	TRB->TB_QUANT     := _nQuant
	TRB->TB_IMPOSTO   := _nImposto
    TRB->TB_VLPVEL    := _nValpisvel  
    TRB->TB_VLPNOV    := _nValpisnov  

  	MsUnlock()
	dbCommit()
	dbSelectArea("TMP")
	_nValBrut := 0
	_nValMerc := 0
	_nQuant   := 0
	_nImposto := 0
    _nValpis  := 0 
Enddo

Return
