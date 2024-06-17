#INCLUDE "RWMAKE.CH"
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MPL_DESCRIºAutor  ³                    º Data ³  10/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de Descricoes                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MPL_DESCRI()
Local aGetArea := GetArea()
Local cCadastro:= "Cadastro de Descricoes"

DbSelectArea("SZ5")
DbSetOrder(1)


AxCadastro("SZ5",cCadastro,"U_SZ5Exclui()","U_SZ5Valida()")

RetIndex("SZ5")

RestArea(aGetArea)

Return


*----------------------*
User Function SZ5Exclui()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.
         
DbSelecTArea("SB1") 
DbOrderNickname("B1DESCR") // B1_FILIAL+B1_X_DESCR
If Dbseek(xFilial("SB1")+SZ5->Z5_CODIGO)
   Aviso("ATENCAO", "Descricao nao podera ser excluida pois esta associada a Produto(s)...",{"&Ok"})
   _lRet:=.F.
Endif
            
RestArea(_aArea)

RETURN _lRet

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
User Function SZ5Valida()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.


If Inclui                     //Processo semelhante ao EXISTCHAV("SZ5")
   DbSelectArea("SZ5")       
   Dbsetorder(1)
   If DbSeek(xFilial("SZ5") + M->Z5_CODIGO)
      Aviso("ATENCAO", "Codigo ja cadastrado...",{"&Ok"})
      _lRet:=.F.
   Endif
Endif

If EmptY(M->Z5_DESCR)
   Aviso("ATENCAO", "Favor preencher o campo Descricao...",{"&Ok"})
   _lRet:=.F.
Endif

RestArea(_aArea)

RETURN _lRet


