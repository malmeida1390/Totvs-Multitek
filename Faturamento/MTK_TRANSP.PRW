#include "rwmake.ch"
#include "colors.ch"

User Function PV_Transp()
/* Rotina que permite a alteracao da transportadora no Pedido de Vendas. */

Private nomeprog    := "PV_Transp"
Private cString     := ""
Private cCadastro   := "PEDIDO DE VENDA - Alteracao do Codigo da Transportadora"
Private _cAlias     := "SC5"
Private aRotina     := { {"Pesquisar"    ,"AxPesqui"     ,0,1 } ,;
{"Visualizar"    ,"A410Visual"      ,0,2 } ,;
{"Transportadora","U__fTransp()"   ,0,3 } }

//{"Visualizar"    ,"AxVisual"       ,0,2 } ,;

DbSelectArea("SA1")
DbSetOrder(1)

dbSelectArea(_cAlias)
dbSetOrder(1)

mBrowse( 6,1,22,75,_cAlias)

Return


*------------------------
User Function _fTransp()

Local _aAreaSC5       := {}
Local _cTranspSC5     := ""
Local _cNomeTranspSC5 := ""
Local _aItensVol	    := {}
Local _cCliente       := ""
Private _cItensTRP      := ""
Private _cCodTransp   := ""

DbSelectArea("SC5")
_aAreaSC5 := GetArea()

/*            
Retirado por Gerardo (19/08/05) para que seja feita a validação no SC6, para faturamento parcial.

If !Empty(SC5->C5_NOTA)
	// ??? - Parametros do MsgAlert
	MsgAlert("Alteracao nao permitido porque o pedido ja foi faturado.")
	Return
EndIf

xx - 0123456789
01 - Cx Papelao
02 - Cx Madeira
03 - Pacote
04 - Envelope
05 - Pallet
06 - A Granel
07 - Volume
08 - Engradado
*/

_cTranspSC5 := SC5->C5_TRANSP
_cCodTransp := SC5->C5_TRANSP
_cTipoFrete	:= alltrim(SC5->C5_TPFRETE)
_cQdeVolume	:= SC5->C5_VOLUME1
_cTipVolume	:= SC5->C5_ESPECI1
_cPesoBruto := SC5->C5_PBRUTO

_aItensVol	  := {"Cx Papelao","Cx Madeira","Pacote","Envelope","Pallet","A Granel","Volume","Engradado"}
_aItensTCF	  := {"C=CIF","F=FOB","T=Por Conta Terceiros","S=Sem Frete"} 
                 
IF  _cTipoFrete = "C"
    _aItensTCF	  := {"C=CIF","F=FOB","T=Por Conta Terceiros","S=Sem Frete"} 
	_cItensTRP    := "C=CIF"
ELSEIF _cTipoFrete = "F"
    _aItensTCF	  := {"F=FOB","C=CIF","T=Por Conta Terceiros","S=Sem Frete"} 
	_cItensTRP    :=  "F=FOB"
ELSEIF _cTipoFrete = "T"
    _aItensTCF	  := {"T=Por Conta Terceiros","F=FOB","C=CIF","S=Sem Frete"} 
	_cItensTRP    :=  "T=Por Conta Terceiros"
ELSEIF _cTipoFrete = "S"
    _aItensTCF	  := {"S=Sem Frete","T=Por Conta Terceiros","F=FOB","C=CIF"} 
	_cItensTRP    :=  "S=Sem Frete"
ENDIF
       
_cItensVol	  := "Volume"


If SC5->C5_TIPO $ "D/B"
   DbSelectArea("SA2")
   DbSeek(xFilial("SA2")+SC5->(C5_CLIENTE+C5_LOJACLI))
   _cCliente:=SA2->A2_NREDUZ
Else
   DbSelectArea("SA1")
   DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI))
   _cCliente:=SA1->A1_NREDUZ
Endif     


IF Found()

	DbSelectArea("SA4")
	DbSeek(xFilial("SA4")+SC5->(C5_TRANSP))
	_cNomeTranspSC5 := Substr(AllTrim(SA4->A4_NOME),1,30)

	IF Found()
		
		@ 100,182 To 400+80,590 Dialog oDlg Title OemToAnsi( Space(10)+"ALTERACAO DE DADOS DO PEDIDO." )
		@ 006,009 To 180,196
		
		@ 014,015 Say OemToAnsi("Nr. Pedido: ")+SC5->C5_NUM COLOR CLR_HRED
		If SC5->C5_TIPO $ "D/B"
 			@ 029,015 Say OemToAnsi("Fornecedor: ")+_cCliente COLOR CLR_HRED
      Else
		   @ 029,015 Say OemToAnsi("Cliente: ")+_cCliente COLOR CLR_HRED
		Endif   
		@ 044,015 Say OemToAnsi("Transportadora Atual: ")+_cTranspSC5+" - "+_cNomeTranspSC5 COLOR CLR_HRED
		
		@ 065,015 Say OemToAnsi("Novo Codigo da Transportadora:")
		@ 080,015 Say OemToAnsi("Tipo de Frete ("+_cTipoFrete+"):")

		@ 095,015 Say OemToAnsi("Qde de Volumes:")
		@ 110,015 Say OemToAnsi("Peso Bruto:")

		@ 130,015 Say OemToAnsi("Tipo Volume ("+_cTipVolume+"):")

		@ 065,120 Get _cCodTransp   F3 "SA4"
        //	@ 080,120 Get _cTipoFrete   VALID PERTENCE("CF")

 	    @ 080,120 COMBOBOX _cItensTRP ITEMS _aItensTCF SIZE 50,10

		@ 095,120 Get _cQdeVolume	Picture "@e 99,999"
		@ 110,120 Get _cPesoBruto  Picture  "@E 999,999.9999"                                

		@ 130,120 COMBOBOX _cItensVol ITEMS _aItensVol	SIZE 50,10
		
		@ 155,110 BmpButton Type 1 Action GravaTransp()
		@ 155,150 BmpButton Type 2 Action Close(oDlg)
		
		Activate Dialog oDlg Centered

	EndIF

EndIF

RestArea(_aAreaSC5)

dbSelectArea(_cAlias)
dbSetOrder(1)

Return


//*-----------------------
Static Function GravaTransp()


Close(oDlg)

DbSelectArea("SA4")
DbSeek( xFilial("SA4") + _cCodTransp )


If Found()
	// ??? - Impedir alteracao para Faturamento Total. O q fazer para Faturamento Parcial?
	DbSelectArea("SC5")
	IF EMPTY(SC5->C5_NOTA)
		GravaSC5()
	ELSE
		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xfilial()+SC5->C5_NUM)

		Saldo	:= 0
		
		While !eof() .and. SC6->C6_NUM == SC5->C5_NUM
            Saldo	+= (SC6->C6_QTDVEN - SC6->C6_QTDENT)

			SC6->( DbSkip() )
		EndDO	
		IF Saldo > 0

		ELSE
           ALERT("Pedido Totalmente Faturado, os dados não podem ser alterados!!!")
		EndIF
	ENDIF		
EndIf

Return



Static Function GravaSC5()

DbSelectArea("SC5")
RecLock("SC5",.f.)
SC5->C5_TRANSP 	:=	_cCodTransp
SC5->C5_TPFRETE	:=	SUBSTR(_cItensTRP,1,1)
SC5->C5_VOLUME1	:=	_cQdeVolume
SC5->C5_ESPECI1	:=	_cItensVol 
SC5->C5_PBRUTO    :=_cPesoBruto
SC5->( MsUnLock() )

Return