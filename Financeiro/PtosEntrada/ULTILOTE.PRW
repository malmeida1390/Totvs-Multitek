#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณULTILOTE  บAUTOR  ณEdelcio Cano        บ Data ณ  31/03/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Captura o ultimo Lote. C.Receber e C.Pagar                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multitek                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ULTILOTE()

Local _aAreaM		:=	GetArea()
Local _cMotBx		:= ""
Local _cUltLote     := Space(04)
Local _cRecPag		:= ""
Local _cRotina		:= FunName()

dbSelectArea("SE5")
_aAreaE5	:= GetArea()
dbSetOrder(11)           

_cMotBx := GetMV("MV_MOTBAIX")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine se eh Receber ou Pagarณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Alltrim(_cRotina)$ "FINA070/FINA110"
	_cRecPag	:= "R"
ElseIf Alltrim(_cRotina) $ "FINA080/FINA090"
	_cRecPag	:= "P"
Endif

Set SoftSeek On
//dbSeek(xFilial()+"BA"+_cRecPag+"ZZZZ")
dbSeek(xFilial()+_cRecPag+"ZZZZ")
dbSkip(-1)
Set SoftSeek Off

//Do While SE5->E5_TIPODOC $ "BACPVL" .and. SE5->E5_RECPAG = _cRecPag 
Do While SE5->E5_RECPAG = _cRecPag 
    If SE5->E5_MOTBX == "CMP"
		dbSkip(-1)
		Loop 
	Else
		If SE5->E5_MOTBX $_cMotBx .and. !Empty(SE5->E5_LOTE)
			_cUltLote	:= SE5->E5_LOTE
			Exit
		Else
			MsgBox("Atencao ! Foi criado Motivo de Baixa novo ? Atualize o parametro MV_MOTBAIX, senao o sistema assumira sempre o Lote nr. 0001","ALERT")
		    Exit
	    Endif
	Endif
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe nao houver Lote, inicia-se em 0001, caso contrario soma 1ณ
//ณno ultimo lote utilizado.                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(_cUltLote)
	_cUltLote := "0001"
Else
	_cUltLote := Soma1(_cUltLote)
Endif

CLOTEFIN	:=	_cUltLote

RestArea(_aAreaE5)
RestArea(_aAreaM)

Return