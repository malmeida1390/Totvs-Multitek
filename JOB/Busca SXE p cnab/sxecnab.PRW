#include "RWMAKE.CH"
#include "topconn.ch"
#include "tbiconn.ch"


User Function GeraSxeSxf()

Local lNewIndice := FaVerInd()
Local cIdCnab    := ""
Local __lSx8     := .t.

lImpEmp := (Aviso('Atencao','Gera sxe e sxf para ID CNAB? ',{'Nao','Sim'})==2)

if lImpEmp

	cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt,19)
	dbSelectArea("SE1")
	aOrdSE1 := SE1->(GetArea())
	DbOrderNickname("SE1IDCNAB")  //dbSetOrder(16)
	While SE1->(MsSeek(xFilial("SE1")+cIdCnab))
		If ( __lSx8 )
			ConfirmSX8()
		EndIf
		cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt,19)
	EndDo
	
	__lSx8:= .t.
	
	cIdCnab:= GetSxENum("SE2", "E2_IDCNAB","E2_IDCNAB"+cEmpAnt,11)
	dbSelectArea("SE2")
	aOrdSE2 := SE2->(GetArea())
	dbSetOrder(11)
	While SE2->(MsSeek(xFilial("SE2")+cIdCnab))
		If ( __lSx8 )
			ConfirmSX8()
		EndIf
		cIdCnab := GetSxENum("SE2", "E2_IDCNAB","E2_IDCNAB"+cEmpAnt,11)
	EndDo
	
Endif

Return


