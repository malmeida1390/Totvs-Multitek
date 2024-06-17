#INCLUDE "RWMAKE.CH"
                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³mpl_medidaºAutor  ³                    º Data ³  10/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de Medidas                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function mpl_medida()
Local aGetArea  := GetArea()
Local cCadastro := "Cadastro de Medidas"


DbSelectArea("SZ3")
DbSetOrder(1)

AxCadastro("SZ3",cCadastro,"U_SZ3Exclui()","U_SZ3Valida()")

RetIndex("SZ3")

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
User Function SZ3Exclui()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.
         
DbSelecTArea("SB1") 
DbOrderNickname("B1UNMED") // B1_FILIAL+B1_X_MEDIDA
If Dbseek(xFilial("SB1")+SZ3->Z3_CODIGO)
   Aviso("ATENCAO", "Medida nao podera ser excluida pois esta associada a Produto(s)...",{"&Ok"})
   _lRet:=.F.
Endif
            
RestArea(_aArea)

RETURN _lRet
                          
                                     

*----------------------*
User Function SZ3Valida()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.


If Inclui                     //Processo semelhante ao EXISTCHAV("SZ3")
   DbSelectArea("SZ3")       
   Dbsetorder(1)
   If DbSeek(xFilial("SZ3") + M->Z3_CODIGO)
      Aviso("ATENCAO", "Codigo ja cadastrado...",{"&Ok"})
      _lRet:=.F.
   Endif
Endif

If EmptY(M->Z3_DESC)
   Aviso("ATENCAO", "Favor preencher o campo Descricao...",{"&Ok"})
   _lRet:=.F.
Endif

RestArea(_aArea)

RETURN _lRet


