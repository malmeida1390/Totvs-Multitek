#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2460   ºAutor  ³                    º Data ³  01/05/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada desenvolvido para gravar no SD2           º±±
±±º          ³ campos especificos da Multitek.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MSD2460()

Local _aArea := GetArea()
Local _cDoc    := SD2->D2_DOC
Local _cSerie  := SD2->D2_SERIE
Local _cCod    := SD2->D2_COD
Local _cLocal  := SD2->D2_LOCAL
Local _cNumSeq := SD2->D2_NUMSEQ
Local _cPedido := SD2->D2_PEDIDO
Local _cItemPed:= SD2->D2_ITEMPV
       

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6") + _cPedido + _cItemPed )

DbSelectArea("SD2")
Reclock("SD2",.F.)
SD2->D2_X_MARGE := SC6->C6_X_MARGE
SD2->D2_X_MARGV := SC6->C6_X_MARGV
SD2->D2_X_MARGA := SC6->C6_X_MARGA
SD2->D2_X_ORIGM := SC6->C6_X_ORIGM
MsUnlock()

// Efetuo a gravacao do produto do cliente na tabela SA7 que e apenas um 
// facilitador de digitacao o programa e chamada estao no MFATC02
///U_CodCliente(SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRODUTO,SC6->C6_X_PRCLI,.T.)

RestArea(_aArea) 

Return



/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2460   ºAutor  ³Heitor Sacomani     º Data ³  01/05/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada desenvolvido para gravar no SD3 uma devol º±±
±±º          ³ cao devido ao tratamento de produção em terceiros.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º01/11/02  ³ Fábio R.Silva- Quando a filial utilizar localizacao, gravarº±±
±±º        	 ³ no SDB um movimento de distribuicao.						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo Cliente AGIP                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAtualizado³ Jorge Gomes em 08/02.                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Private _cNumNF   := "", _cSerie := "" , _cAlias:= "", _cTm:= "", _cCod:="", _cUm:= ""
Private _nQuant   := 0 , _cCf     := "", _cLocDest:="" , _dEmissao:="" , _nCusto:=0 , nQtdseg:=0
Private _cTipo    := "", _cChave  := "", _cTes   := "", _cDoc := "", _cSerie := ""
Private _nValAcum := 0 , _nValFt  := 0 , _cFlag  := "", _Atu := "",_nCm1:=0 , _nResult :=0, _cLocal := ""
Private xdest     := "", _cprcven := 0 , _ctotal := 0 , _ccliente:= "",_cloja := "", _cNumSeq := ""
Private xtrib     := "", xsuframa:= "" , xcodmun := "", xest    := "", _cUm2 := "", _cTran := ""
Local _cAlias, _nOrdem, _nRecno

_cAlias := Alias()
_nOrdem  := IndexOrd()
_nRecno  := Recno()

// Armazena as areas no inicio do ponto de entrada ( bloco inserido por Jorge Gomes em 22/02/02
_cAreaSD2:=SD2->(GetArea())
_cAreaSD3:=SD3->(GetArea())
_cAreaSF4:=SF4->(GetArea())
_cAreaSB1:=SB1->(GetArea())
_cAreaSB2:=SB2->(GetArea())
_cAreaSA1:=SA1->(GetArea())
_cAreaSBF:=SBF->(GetArea())
_cAreaSDB:=SDB->(GetArea())

_cDoc    := SD2->D2_DOC
_cSerie  := SD2->D2_SERIE
_cCod    := SD2->D2_COD
_cLocal  := SD2->D2_LOCAL
_cNumSeq := SD2->D2_NUMSEQ
_cPedido := SD2->D2_PEDIDO


_cCpSol  := GetAdvFval("SC5","C5_X_CPSOL",xFilial("SC5") + _cPedido, 1)

If _cCpSol = "S"
	Reclock("SD2",.F.)
	Replace SD2->D2_PRCVEN  WITH 0.01
	Replace SD2->D2_TOTAL   WITH 0.01
	Replace SD2->D2_TIPO    WITH "T"
	MsUnlock()
Endif

_cItem   := SD2->D2_ITEMPV
_cTm     := "999"
_cUm     := SD2->D2_UM
_nQuant  := SD2->D2_QUANT
_cCf     := "RE4"
_cLocDest:= SC6->C6_X_LOCD
_dEmissao:= SD2->D2_EMISSAO
_nQtdseg := SD2->D2_QTSEGUM
_cTipo   := SD2->D2_TP
_cChave  := "E0"
_cTes    := SD2->D2_TES
_cUm2    := SD2->D2_SEGUM
_cLocalizO:= SC6->C6_LOCALIZ // VER LOCALIZACAO ORIGEM
_cLocalizD:= SC6->C6_LOCALID // VER LOCALIZACAO DESTINO

// implementação p/ clientes SUFRAMA, retornando 7% qdo. Finalidade for Consumo
// Fernando 27/06
// ALIMENTA VARIÁVEIS

xdest    := SC5->C5_X_DSTPD
_cCpSol  := SC5->C5_X_CPSOL
_cprcven := SD2->D2_PRCVEN
_ctotal  := SD2->D2_TOTAL
_ccliente:= SD2->D2_CLIENTE
_cloja   := SD2->D2_LOJA

Dbselectarea("SF4")
Dbsetorder(1)
If Dbseek(xfilial()+_cTes)
	_cFlag := SF4->F4_PODER3
	_Atu   := SF4->F4_ESTOQUE
	_cTran := SF4->F4_X_TRF
Endif

Dbselectarea("SB2")
Dbsetorder(1)
If Dbseek(xFilial()+_cCod+ _cLocal)
	_nCm1   := SB2->B2_CM1
	_nResult:= _nCm1 * _nQuant
Elseif Dbseek(xFilial()+_cCod)
    While !Eof .and. SB2->B2_COD == _cCod
       If SB2->B2_CM1 == 0
          DbSelectArea("SB2")
          DbSkip()
          Loop
       Else
          _nCm1 := SB2->B2_CM1
          _nResult := _nCm1 * _nQuant
       Endif   
       DbSkip()
    Enddo
Endif  
    
_cNumseq := STRZERO(VAL(Getmv("MV_DOCSEQ"))+1,6)

If _cTran == "S"
	Dbselectarea("SD3")
	Reclock("SD3",.T.)
	Replace SD3->D3_FILIAL  WITH xFilial("SD3")
	Replace SD3->D3_TM      WITH _cTm
	Replace SD3->D3_COD     WITH _cCod
	Replace SD3->D3_UM      WITH _cUm
	Replace SD3->D3_QUANT   WITH _nQuant
	Replace SD3->D3_CF      WITH _cCF
	Replace SD3->D3_LOCAL   WITH _cLocal
	Replace SD3->D3_EMISSAO WITH _dEmissao
	Replace SD3->D3_CUSTO1  WITH _nResult
	Replace SD3->D3_NUMSEQ  WITH _cNumseq
	Replace SD3->D3_SEGUM   WITH _cUm2
	Replace SD3->D3_QTSEGUM WITH _nQtdseg
	Replace SD3->D3_TIPO    WITH _cTipo
	Replace SD3->D3_CHAVE   WITH _cChave
	Replace SD3->D3_IDENT   WITH _cSerie
	Replace SD3->D3_DOC     WITH _cDoc
	Replace SD3->D3_LOCALIZ WITH _cLocalizO // GRAVA LOCALIZACAO
	MsUnlock()
	IF !EMPTY(_cLocalizO) // atualiza SDB/SBF/SB2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pega os 15 custos medios atuais            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		aCM := PegaCMAtu(SD3->D3_COD,SD3->D3_LOCAL)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o custo da movimentacao              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aCusto := GravaCusD3(aCM)
        
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o saldo atual (VATU) com os dados do SD3     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		B2AtuComD3(aCusto)

	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Este bloco foi bloqueado na linha 190 e incluido neste local, pq   ³
		//³ estaria substraindo o estoque  duas vezes.                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Dbselectarea("SB2")
		Dbsetorder(1)
		If Dbseek(xFilial()+_cCod+ _cLocal)
			RecLock("SB2",.F.)
			Replace SB2->B2_QATU WITH SB2->B2_QATU - _nQuant
			Replace SB2->B2_VATU1 WITH SB2->B2_VATU1 - _nResult
			MsUnlock()
		Endif
		
	Endif
	
	Dbselectarea("SD3")
	_cCf     := "DE4"
	_cTm     := "499"
	_cChave  := "E9"
	
	Reclock("SD3",.T.)
	Replace SD3->D3_FILIAL  WITH xFilial("SD3")
	Replace SD3->D3_TM      WITH _cTm
	Replace SD3->D3_COD     WITH _cCod
	Replace SD3->D3_UM      WITH _cUm
	Replace SD3->D3_QUANT   WITH _nQuant
	Replace SD3->D3_CF      WITH _cCF
	Replace SD3->D3_LOCAL   WITH _cLocDest
	Replace SD3->D3_EMISSAO WITH _dEmissao
	Replace SD3->D3_CUSTO1  WITH _nResult
	Replace SD3->D3_NUMSEQ  WITH _cNumseq
	Replace SD3->D3_QTSEGUM WITH _nQtdseg
	Replace SD3->D3_TIPO    WITH _cTipo
	Replace SD3->D3_CHAVE   WITH _cChave
	Replace SD3->D3_IDENT   WITH _cSerie
	Replace SD3->D3_DOC     WITH _cDoc
	Replace SD3->D3_LOCALIZ WITH _cLocalizD // GRAVA LOCALIZACAO
	MsUnlock()
	IF !EMPTY(_cLocalizD) // atualiza SDB/SBF/SB2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pega os 15 custos medios atuais            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//		aCM := PegaCMAtu(SD3->D3_COD,SD3->D3_LOCAL)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o custo da movimentacao              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//		aCusto := GravaCusD3(aCM)
	    Aadd(aCusto,_nCm1)        

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o saldo atual (VATU) com os dados do SD3     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		B2AtuComD3(aCusto)
	ELSE
		Dbselectarea("SB2")
		Dbsetorder(1)
		If Dbseek(xFilial()+_cCod+ _cLocDest)
			RecLock("SB2",.F.)
			Replace SB2->B2_QATU WITH SB2->B2_QATU + _nQuant
			Replace SB2->B2_VATU1 WITH SB2->B2_VATU1 + _nResult
			MsUnlock()
		Else
			Reclock("SB2",.T.)
			SB2->B2_FILIAL := Substr(cNumEmp,3,2)
			SB2->B2_COD    := _cCod
			SB2->B2_LOCAL  := _cLocDest
			SB2->B2_QATU   := _nQuant
			SB2->B2_VATU1  := _nResult
			SB2->B2_CM1    := _nCm1
			MsUnlock()
		Endif
	Endif
	PutMv("MV_DOCSEQ",_cNumSeq)
Endif
// implementação p/ clientes SUFRAMA, retornando 7% qdo. Finalidade for Consumo
// Fernando 27/06
// INÍCIO DE IMPLEMENTAÇÃO

Dbselectarea("SA1")
Dbsetorder(1)
If Dbseek(xfilial("SA1")+_ccliente+_cloja)
	xsuframa:= SA1->A1_SUFRAMA
	xcodmun := SA1->A1_CODMUN
	xest    := SA1->A1_EST
Endif

Dbselectarea("SB1")
Dbsetorder(1)
If Dbseek(xfilial("SB1")+_ccod)
	xtrib := SB1->B1_GRTRIB
Endif

if xtrib == "002" .and. !empty(xsuframa) .and. _cCpSol = "N"
	If (xcodmun != "00605" .and. xcodmun != "00615" .and. xcodmun != "999985";
		.and. xcodmun != "00307" .and. xcodmun != "99999" .and. xcodmun != "00001";
		.and. xcodmun != "09847" .and. xcodmun != "00107" .and. xcodmun != "00105";
		.and. xcodmun != "00255" .and. xcodmun != "09843" .and. xcodmun != "09841");
		.and. xEST == "AM" .OR. xEST == "RO" .OR. xEST == "AC" .OR. xEST == "RR"
		if xDEST == "002"
			_cprcven := _cprcven / 0.93
			_ctotal  := _ctotal  / 0.93
			Dbselectarea("SD2")
			Reclock("SD2",.T.)
			Replace D2_PRCVEN With _cprcven
			Replace D2_TOTAL  With _ctotal
			MsUnlock()
		endif
	Endif
Endif
// FIM DE IMPLEMENTAÇÃO

_cCC := SC6->C6_X_CCUST

RecLock("SD2",.F.)
  SD2->D2_X_CCUST := _cCC
  SD2->D2_DESCPV  := SD2->D2_DESCON
  SD2->D2_PDESCPV := SD2->D2_DESC
  SD2->D2_DESCON  := 0
  SD2->D2_DESC    := 0
MsUnlock()              

// Restaura todas as areas guardadas anteriormente ( bloco inserido por Jorge Gomes em 22/02/02
SA1->(RestArea(_cAreaSA1))
SF4->(RestArea(_cAreaSF4))
SB1->(RestArea(_cAreaSB1))
SB2->(RestArea(_cAreaSB2))
SD2->(RestArea(_cAreaSD2))
SD3->(RestArea(_cAreaSD3))

DbSelectArea(_cAlias)
DbSetOrder(_nOrdem)
DbGoto(_nRecno)
Return
*/