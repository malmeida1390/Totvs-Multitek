#INCLUDE "Rwmake.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A415TDOK  ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao Total do Orcamento antes da Gravacao.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A415TDOK()
Local lRet       := .T.
Local lStatus    := .T.    
Local _cIndComer := ""


DbSelectArea("TMP1")
DbGotop()

While !TMP1->(eof()) 

    _cIndComer := GetAdvFval("SF4","F4_X_ST_CI",xFilial("SF4")+TMP1->CK_TES, 1)

	If !EmptY(TMP1->CK_PRODUTO)  .and. !TMP1->CK_FLAG

		If TMP1->CK_PRCVEN = 0
			lStatus := .F.	
		Endif

		If EMPTY(TMP1->CK_X_PRCLI)
			Aviso("ATENCAO", "Existem produtos com o codigo do cliente em branco neste orcamento.",{"&Ok"})
			lRet:=.f.
		Elseif Empty(TMP1->CK_X_ENTRE)
			Aviso("ATENCAO", "Campo data de entrega deve ser preenchido.",{"&Ok"})
			lRet := .F.
		Elseif TMP1->CK_X_ENTRE < M->CJ_EMISSAO
			Aviso("ATENCAO", "Data de entrega menor que a data de Emissao.",{"&Ok"})
			lRet := .F.
		Elseif TMP1->CK_X_ENTRE < M->CJ_EMISSAO
			Aviso("ATENCAO", "Data de entrega menor que a data de Emissao.",{"&Ok"})
			lRet := .F.
		//Elseif M->CJ_X_ST_CI <> _cIndComer
		//	Aviso("ATENCAO", "Esta sendo utilizada uma TES neste orcamento que nao e para "+;
  	    //      IF (CJ_X_ST_CI $ "I" , "INDUSTRIA" , "CONSUMO") ,{"&Ok"})
		// 	lRet := .F.
  	   Endif 
  	
	Endif
   
   if !lRet
      Exit
   Endif   

	TMP1->(DBSKIP()) 
	
ENddo


If lRet

	If M->CJ_CLIENTE+M->CJ_LOJA <> M->CJ_CLIENT+M->CJ_LOJAENT
	   lRet := (Aviso('Atencao','Cliente de Faturamento diferente de Cliente de Entrega. Deseja Continuar ?',{'Sim','Nao'})==1)
    Endif
    
Endif    
                          
if lRet
	
	If !lStatus
		SCJ->CJ_STATUS=="D"
	Endif
	
Endif

Return(lRet)