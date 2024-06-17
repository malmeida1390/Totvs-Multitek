#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTKAF03   ºAutor  ³Edelcio Cano        º Data ³  24/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica o Grupo e define C.Contabil para Bx. Venda        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                          

User Function MTKATF03()

Local _aAreaAt	:=	GetArea()
Local _cConta   := ""


// 24/01/13 Codigos em verde são para ativar quando entrar a nova contabilidade JULIO.

If SN1->N1_GRUPO == "0001" 
//	_cConta	:=	"132020001"             //123070002 moveis e utensilios
	_cConta	:=	"123070002"             // moveis e utensilios
ElseIf	SN1->N1_GRUPO == "0002"
//    _cConta	:=	"132020002"             //123070003 depreciacao acumulada de instalacoes
    _cConta	:=	"123070003"                 //depreciacao acumulada de instalacoes
ElseIf	SN1->N1_GRUPO	==	"0003"
//	_cConta :=	"132020003"            //123070004 depreciacao acumulada de maq e equipamentos
	_cConta :=	"123070004"            //depreciacao acumulada de maq e equipamentos
ElseIf SN1->N1_GRUPO $ "0004/0009"   
//	_cConta :=	"132020004"	          //123070005 depreciacao de veiculos
	_cConta :=	"123070005"           //depreciacao de veiculos
ElseIf SN1->N1_GRUPO == "0005"
//	_cConta :=	"132020005"           //124030001 amortizacao marcas direitos e patentes
	_cConta :=	"124030001"           //amortizacao marcas direitos e patentes
//ElseIf SN1->N1_GRUPO == "0008"
//	_cConta := 	                             //124030002 amortizacao software

Endif	 	
	
RestArea(_aAreaAt)

Return(_cConta)