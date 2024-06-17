#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ UltCompra³ Autor ³ Atualiza Ultima Compra ³ Data ³ 24/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ultima Compra.                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UltCompra()
Local cTes  := ""
Local dData := ""
Local cQyery:= ""

Pergunte("MTA103",.F.)
lDigita     := (mv_par01==1)
lAglutina   := (mv_par02==1)
lReajuste   := (mv_par04==1)
lAmarra     := (mv_par05==1)
lGeraLanc   := (mv_par06==1)
lConsLoja   := (mv_par07==1)
IsTriangular(mv_par08==1)
nTpRodape   := (mv_par09)
lPrecoDes   := (mv_par10==1)
lDataUcom   := (mv_par11==1)
lAtuAmarra  := (mv_par12==1)
lRatLiq     := (mv_par13==2)
lRatImp     := (mv_par13==1 .And. mv_par14==2)

DbselectArea("SD1")
DbSetOrder(1)
Dbseek(xFilial("SD1"))               


cQyery := "SELECT SD1.R_E_C_N_O_ RECNO,D1_FILIAL,D1_TIPO,D1_COD,D1_TES,D1_EMISSAO,D1_VUNIT,F4_UPRC,B1_UCOM,B1_UPRC, "
cQyery += "D1_DTDIGIT,D1_VUNIT,D1_VALDESC,D1_QUANT, "
cQyery += "D1_NFORI,D1_SERIORI,D1_FORNECE,D1_LOJA,D1_ITEMORI "
cQyery += "FROM SD1010 SD1, SF4010 SF4, SB1010 SB1 "
cQyery += "WHERE "
//cQyery += "D1_COD='066783' AND "
//cQyery += "D1_FILIAL='01' AND "
cQyery += "D1_TIPO='N' AND "
cQyery += "F4_CODIGO = D1_TES AND "
cQyery += "B1_COD = D1_COD AND "
cQyery += "B1_UCOM = '' AND "
cQyery += "SF4.D_E_L_E_T_ <>'*' AND "
cQyery += "SD1.D_E_L_E_T_ <>'*' AND "
cQyery += "SB1.D_E_L_E_T_ <>'*' "
cQyery += "ORDER BY D1_COD,D1_DTDIGIT  "
             

TRBSD1 := "TEMPARQ"
//Criar alias temporário
TCQUERY cQyery NEW ALIAS (TRBSD1)

tCSetField((TRBSD1), "D1_EMISSAO", "D")
tCSetField((TRBSD1), "D1_DTDIGIT",  "D")


While !(TRBSD1)->(eof())

	
	cTes   := (TRBSD1)->D1_TES
	dData  := (TRBSD1)->D1_EMISSAO
    cCod   := (TRBSD1)->D1_COD 
    
    DbSelectArea("SB1")
	DbSetorder(1)
	Dbseek(xFilial("SB1")+cCod)

	
	DbSelectArea("SF4")
	DbSetorder(1)
	If  Dbseek(xFilial("SF4")+cTes)
		
		DbSelectArea(TRBSD1)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza Produto                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (TRBSD1)->D1_TIPO == "N" .And. SF4->F4_UPRC$" S"
			If  dData >= RetFldProd(SB1->B1_COD,"B1_UCOM")
				If RetArqProd(SB1->B1_COD) 
					RecLock("SB1",.F.)
					SB1->B1_UCOM := IIf(lDataUcom,(TRBSD1)->D1_DTDIGIT,(TRBSD1)->D1_EMISSAO)
					SB1->B1_UPRC := IIf(lPrecoDes,(TRBSD1)->D1_VUNIT-((TRBSD1)->D1_VALDESC/(TRBSD1)->D1_QUANT),(TRBSD1)->D1_VUNIT)
					Msunlock()
				Else
					RecLock("SBZ",.F.)
					SBZ->BZ_UCOM := IIf(lDataUcom,(TRBSD1)->D1_DTDIGIT,(TRBSD1)->D1_EMISSAO)
					SBZ->BZ_UPRC := IIf(lPrecoDes,(TRBSD1)->D1_VUNIT-((TRBSD1)->D1_VALDESC/(TRBSD1)->D1_QUANT),(TRBSD1)->D1_VUNIT)
					Msunlock()
					dbSelectArea("SB1")
				Endif
			EndIf
		Else
			If (TRBSD1)->D1_TIPO == "C" .And. SF4->F4_UPRC$" S"
				If dData >= RetFldProd(SB1->B1_COD,"B1_UCOM")
					nVlrCompl := (TRBSD1)->D1_VUNIT
					cDoc:= (TRBSD1)->D1_NFORI
					cSerie:= (TRBSD1)->D1_SERIORI
					cFornec:= (TRBSD1)->D1_FORNECE
					cLoja:= (TRBSD1)->D1_LOJA
					cCod:= (TRBSD1)->D1_COD
					cItem:= AllTrim((TRBSD1)->D1_ITEMORI)
					If !Empty(cItem)
						dbSelectArea("TRBSD1")
						dbSetOrder(1)
						If MsSeek(xFilial("SB1")+cDoc+cSerie+cFornec+cLoja+cCod+cItem)
							If RetArqProd(SB1->B1_COD)
								RecLock("SB1",.F.)
								SB1->B1_UPRC := IIf(lPrecoDes,(TRBSD1)->D1_VUNIT-((TRBSD1)->D1_VALDESC/(TRBSD1)->D1_QUANT)+ (nVlrCompl/(TRBSD1)->D1_QUANT) ,nVlrCompl/(TRBSD1)->D1_QUANT+(TRBSD1)->D1_VUNIT)
            					Msunlock()
							Else
								RecLock("SBZ",.F.)
								SBZ->BZ_UPRC := IIf(lPrecoDes,(TRBSD1)->D1_VUNIT-((TRBSD1)->D1_VALDESC/(TRBSD1)->D1_QUANT)+ (nVlrCompl/(TRBSD1)->D1_QUANT) ,nVlrCompl/(TRBSD1)->D1_QUANT+(TRBSD1)->D1_VUNIT)
								Msunlock()
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		
	Endif   
	
	DbSelectArea(TRBSD1)
	(TRBSD1)->(DBSKIP())
	
Enddo
    
DbSelectArea(TRBSD1)
dbCloseArea()
                                            
Return
