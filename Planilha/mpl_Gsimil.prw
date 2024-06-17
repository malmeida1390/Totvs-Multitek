#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MPL_GsimilºAutor  ³                    º Data ³  10/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Chamada do Cadastro de Grupo de Similaridade                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MPL_Gsimil()

Local aGetArea := GetArea()
Local cCadastro:= "Grupo de Similaridade"


DbSelectArea("SZ2")
DbSetOrder(1)

AxCadastro("SZ2",cCadastro,"U_SZ2Exclui()","U_SZ2Valida()")

RetIndex("SZ2")

RestArea(aGetArea)

Return
            
// Permite que o sistema de o Codigo automaticamente        
//                X3_RELACAO                        X3_VISUAL
// Z2_CODIGO      GETSX8NUM("SZ2",M->Z2_CODIGO)     N
// Z3_CODIGO      GETSX8NUM("SZ3",M->Z3_CODIGO)     N
// Z5_CODIGO      GETSX8NUM("SZ5",M->Z5_CODIGO)     N
// B1_COD         GETSX8NUM("SB1",M->B1_COD)        N
// Validacoes a serem colocadas no SB1 ou nos locais que usaram esta tabela
//                X3_VALDUSER
// B1_X_SIMIL     VAZIO() .OR. EXISTCPO("SZ2",M->B1_X_SIMIL)
// B1_X_MEDID     VAZIO() .OR. EXISTCPO("SZ3",M->B1_X_MEDID)
// B1_X_DESCR     VAZIO() .OR. EXISTCPO("SZ5",M->B1_X_DESCR)
//                X3_F3
// B1_X_SIMIL     SZ2
// B1_X_MEDID     SZ3
// B1_X_DESCR     SZ4

*----------------------*
User Function SZ2Exclui()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.
         
DbSelecTArea("SB1") 
DbOrderNickname("B1SIMIL") // B1_FILIAL+B1_X_SIMIL
If Dbseek(xFilial("SB1")+SZ2->Z2_CODIGO)
   Aviso("ATENCAO", "Medida nao podera ser excluida pois esta associada a Produto(s)...",{"&Ok"})
   _lRet:=.F.
Endif
            
RestArea(_aArea)

RETURN _lRet
                          
                                     

*----------------------*
User Function SZ2Valida()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.



If Inclui                    //Processo semelhante ao EXISTCHAV("SZ2")
   DbSelectArea("SZ2")       
   Dbsetorder(1)
   If DbSeek(xFilial("SZ2") + M->Z2_CODIGO)
      Aviso("ATENCAO", "Codigo ja cadastrado...",{"&Ok"})
      _lRet:=.F.
   Endif
Endif

If EmptY(M->Z2_DESCR)
   Aviso("ATENCAO", "Favor preencher o campo Descricao...",{"&Ok"})
   _lRet:=.F.
Endif
If EmptY(M->Z2_CODMED)
   Aviso("ATENCAO", "Favor preencher o Codigo da Medida...",{"&Ok"})
   _lRet:=.F.
Else 
   DbSelectArea("SZ3")
   DbSetOrder(1)
   If !Dbseek(xFilial("SZ3")+M->Z2_CODMED)
       Aviso("ATENCAO", "Codigo de Medida Invalido...",{"&Ok"})
      _lRet:=.F.
   Endif
Endif

If Altera
   MsgRun( OemToAnsi( "Aguarde. Atualizando Medidas do Cadastro de Produtos..." ),"",{||AltMedi()})
Endif

RestArea(_aArea)

RETURN _lRet
                                                                                                    


Static Function AltMedi()
Local _cQuery   := ""                 

IF valType(M->Z2_CODIGO) <> "C" .or. valType(M->Z2_CODMED) <>"C"
   Return
Endif

#IFDEF TOP
	If  TCCanOpen(RETSQLNAME("SB1"))
        _cQuery := "UPDATE "+RETSQLNAME("SB1")+" (NOLOCK) SB1" 
        _cQuery += " SET B1_X_MEDID = '"+M->Z2_CODMED+"'"
        _cQuery += " WHERE "
        _cQuery += " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND"
        _cQuery += " SB1.B1_X_SIMIL = '"+M->Z2_CODIGO+"' AND"
        _cQuery += " SB1.D_E_L_E_T_ <> '*'
		TCSQLEXEC(_cQuery)
	EndIf
#Else
	DbSelectArea("SB1") 
	DbOrderNickname("B1SIMIL")         // Filial+Simil+Eis
	If  DbSeek(xFilial("SB1")+M->Z2_CODIGO)
	    While !SB1->(Eof()) .AND. xFilial("SB1")+M->Z2_CODIGO = B1_FILIAL + B1_X_SIMIL
		      RecLock("SB1",.f.) 
		      SB1->B1_X_MEDID := M->Z2_CODMED
		      MsUnLock() 
		      SB1->(DBSKIP())
    	EndDo
	Endif
#EndIf

Return
