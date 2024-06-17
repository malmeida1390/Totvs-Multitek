#INCLUDE "RWMAKE.CH"
                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTK_CONTRAºAutor  ³                    º Data ³  10/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de Grupo de Contratos                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTK_CONTRA()
Local aGetArea  := GetArea()
Local cCadastro := "Cadastro de Grupo de Contratos"


DbSelectArea("Z11")
DbSetOrder(1)

AxCadastro("Z11",cCadastro,"U_Z11Exclui()","U_Z11Valida()") 

RetIndex("Z11")

RestArea(aGetArea)


Return                                                                                 


*----------------------*
User Function Z11Exclui()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.
         
DbSelecTArea("SA1") 
DbOrderNickname("Z11CONTRA") // A1_FILIAL+A1_X_GRPCO
If Dbseek(xFilial("SA1")+Z11->Z11_GRPCON)
   Aviso("ATENCAO", "Grupo de contrato nao pode ser excluido existem amaracoes com o cliente...",{"&Ok"})
   _lRet:=.F.
Endif
            
RestArea(_aArea)

RETURN _lRet
                          
                                     

*----------------------*
User Function Z11Valida()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.
                                           

M->Z11_GRPCON := STRZERO(VAL(M->Z11_GRPCON),6)

If Inclui                     //Processo semelhante ao EXISTCHAV("SZ3")
   DbSelectArea("Z11")       
   Dbsetorder(1)
   If DbSeek(xFilial("Z11") + M->Z11_GRPCON)
      Aviso("ATENCAO", "Grupo de Contrato ja cadastrado...",{"&Ok"})
      _lRet:=.F.
   Endif  
//   u_ItemAtuC() 	//Alteração em 01/10/12 para atualizar o cadastro de ITEM CONTABIL - Julio   
Endif

If EmptY(M->Z11_DESCRI)
   Aviso("ATENCAO", "Favor preencher o campo Descricao...",{"&Ok"})
   _lRet:=.F.
Endif

RestArea(_aArea)

RETURN _lRet
                      
/* 
USER FUNCTION ITEMATUC()

	DbSelectArea("CTD")
	Dbsetorder(1)
	If !DbSeek(xFilial("CTD")+"C"+ALLTRIM(M->Z11_GRPCON))
		RecLock("CTD",.T.)
		CTD->CTD_Filial   := xFilial("CTD")
		CTD->CTD_ITEM     := "C"+ALLTRIM(M->Z11_GRPCON)
		CTD->CTD_CLASSE   := "2"
		CTD->CTD_NORMAL   := "0"
		CTD->CTD_DESC01   :=M->Z11_DESCRI
		CTD->CTD_BLOQ     := "2"
		CTD->CTD_DTEXIS   := ctod("01/01/1980")
		CTD->CTD_CLOBRG   := "2"
		CTD->CTD_ACCLVL   := "1"
		MsUnlock()
	EndIF
	
Return
*/
