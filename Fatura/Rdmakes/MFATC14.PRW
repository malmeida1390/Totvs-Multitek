#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATC14   ºAutor  ³                    º Data ³  05/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de Armazem                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATC14()

Local aArea := GetArea()

DbSelectArea("NNR")
DbSetOrder(1)

AxCadastro("NNR","Cadastro de Armazens",".T.","U_ValUsu14()")

RetIndex("NNR")

RestArea(aArea)

Return




*----------------------*
User Function ValUsu14()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.
Local _cArma:= ""

If EmptY(M->NNR_CODIGO)
   Aviso("ATENCAO", "Favor preencher o campo Local...",{"&Ok"})
   _lRet:=.F.
Endif

If EmptY(M->NNR_DESCRI)
   Aviso("ATENCAO", "Favor preencher o campo Nome do Armazem...",{"&Ok"})
   _lRet:=.F.
Endif


If Inclui                     //Processo semelhante ao EXISTCHAV("SZ5")
   If !ExistChav("NNR",M->NNR_CODIGO,,"")
      Aviso("ATENCAO", "Codigo de local ja Cadastrado...",{"&Ok"})
      _lRet := .f.
   ELSE
     
     // Para realizar esta operacao existe dois grandes inconveniencias:
     // 1. O campo X3_CBOX  cabe somente 128 kbytes
     // 2. Estou travando o SX3 para um replace                          ??? 
     // 3. Devido ao expaco utilizando este processo somente caberiam 10 arquivos
     //    para conta exata teriamos que miminar o tamamno do nome do armazem e o
     //    numero suportavel de registros.                      123456789012
     //    EX. DE DEFINIRMOS 12 kbytes para cada armazem seriam 01=12444444;
                               
     // Mediante o exposto nao sera possivel a utilizacao do nome do armazem no 
     // acols.
    
     /*
     DbSelectArea("NNR")
     DbSetorder(1)
     DbGotop()
     While !NNR->(EOF())       
           _cArma := _cArma + NNR->ZB_LOCAL+"="+alltrim(SZB->ZB_LOCNOME)+";"
           SZB->(DBSKIP())
     Enddo 
     _cArma := SUBSTR(_cArma,1,LEN(_cArma)-1)

     DbSelectArea("SX3")
     DbSetOrder(2)

     Dbseek("Z6_LOCAL")
     Reclock("SX3",.F.)
     SX3->X3_CBOX:=_cArma
     MsUnlock()

     DbSeek("CK_LOCAL")
     Reclock("SX3",.F.)
     SX3->X3_CBOX:=_cArma
     MsUnlock()
     */
     
        
   Endif
Endif


RestArea(_aArea)


Return(_lRet)



  