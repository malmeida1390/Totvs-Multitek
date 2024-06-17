#INCLUDE "RWMAKE.CH"
#include "topconn.ch"
                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTK_TPFORNºAutor  ³                    º Data ³  01/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de Tipo de Fornecedor                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTK_TPFORN()
Local aGetArea  := GetArea()
Local cCadastro := "Cadastro de Tipo de Fornecedor"


DbSelectArea("Z24")
DbSetOrder(1)

AxCadastro("Z24",cCadastro,"U_Z24Exclui()","U_Z24Valida()")

RetIndex("Z24")

RestArea(aGetArea)


Return


*----------------------*
User Function Z24Exclui()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.
         
DbSelecTArea("SA2") 
DbOrderNickname("Z24TPFORN") // A2_FILIAL+A2_X_TPFOR
If Dbseek(xFilial("SA2")+Z24->Z24_CODIGO)
   Aviso("ATENCAO", "Tipo de Fornecedor nao pode ser excluido existem amaracoes com o fornecedor...",{"&Ok"})
   _lRet:=.F.
Endif
            
RestArea(_aArea)

RETURN _lRet
                          
                                     

*----------------------*
User Function Z24Valida()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.
                                           

M->Z24_CODIGO := STRZERO(VAL(M->Z24_CODIGO),6)

If Inclui                     //Processo semelhante ao EXISTCHAV("SZ3")
   DbSelectArea("Z24")       
   Dbsetorder(1)
   If DbSeek(xFilial("Z24") + M->Z24_CODIGO)
      Aviso("ATENCAO", "Tipo de Fornecedor ja cadastrado...",{"&Ok"})
      _lRet:=.F.
   Endif 
   u_ItemAtuF()	//Alteração em 01/10/12 para atualizar o cadastro de ITEM CONTABIL - Julio 
Endif

If EmptY(M->Z24_DESCRI)
   Aviso("ATENCAO", "Favor preencher o campo Descricao...",{"&Ok"})
   _lRet:=.F.
Endif

RestArea(_aArea)

RETURN _lRet


USER FUNCTION ITEMATUF()

	DbSelectArea("CTD")
	Dbsetorder(1)
	If !DbSeek(xFilial("CTD")+"F"+ALLTRIM(M->Z24_CODIGO))
		RecLock("CTD",.T.)
		CTD->CTD_Filial   := xFilial("CTD")
		CTD->CTD_ITEM     := "F"+ALLTRIM(M->Z24_CODIGO)
		CTD->CTD_CLASSE   := "2"
		CTD->CTD_NORMAL   := "0"
		CTD->CTD_DESC01   :=M->Z24_DESCRI
		CTD->CTD_BLOQ     := "2"
		CTD->CTD_DTEXIS   := ctod("01/01/1980")
		CTD->CTD_CLOBRG   := "2"
		CTD->CTD_ACCLVL   := "1"
		MsUnlock()
	EndIF
	
Return

