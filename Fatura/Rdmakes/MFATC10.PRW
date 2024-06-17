#INCLUDE "FIVEWIN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATC10   ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ativa Filtro no SXB (Industria ou Comercio) para o TES      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATC10()                                                      


// Nao funcionou por algum motivo desta forma coloquei no proprio F4F o Filtro

//Local _cFiltro := "SF4->F4_X_ST_CI = '"+M->CJ_X_ST_CI+"'"

//Return("SF4->F4_X_ST_CI = '"+M->CJ_X_ST_CI+"'")  

Return

                          

User Function ValTes(cTes,cIndCom)
Local _aArea   := GetArea()                           
Local _lRet    := .T.
Local _cIndCom := substr(cIndCom,1,1)
                                 
//
// Nao Funcionou via Gatilho sendo necessario esta correcao.
// Este funcao esta sendo chamada pela campo CK_TES.
//
//                                 
SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+M->CK_TES))

M->CK_CLASFIS:=SB1->B1_ORIGEM+SF4->F4_SITTRIB
     
/*
Conforme solicitacao do Sr. Mauricio no dia  28/10/05
nao sera mais consistido o tes devido a necessidade
de estar se utilizando tes diferentes no simulador
nao diferenciando industria ou consumo.
    
DbSelectArea("SF4")                                                   
DbSetOrder(1) 
If Dbseek(xFilial("SF4")+cTes)
	
	If SF4->F4_X_ST_CI <> _cIndCom
		If M->CJ_X_ST_CI = "I"                                               Ø
			Aviso("ATENCAO", "Tes nao pode ser utilizado devido Orcamento ser para Industria",{"&Ok"})
			_lRet:= .f.
		Else
			Aviso("ATENCAO", "Tes nao pode ser utilizado devido Orcamento ser para Consumo",{"&Ok"})
			_lRet:= .f.
		Endif
	Endif
	
Endif
*/
                        
RestArea(_aArea) 

Return(_lRet)
