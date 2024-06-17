#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTKAF05   ºAutor  ³Edelcio Cano        º Data ³  13/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica o Grupo e define C.Contabil para Aquisicao        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                          

User Function MTKATF05()

// Codigos em verde são para ativar quando entrar a nova contabilidade.

Local _aAreaAt	:=	GetArea()
Local _cConta   := ""

If SN1->N1_GRUPO == "0001"   			
//	_cConta	:=	"132010001"          //123020001 moveis e utensilios
	_cConta	:=	"123020001" 	  //moveis e utensilios
ElseIf	SN1->N1_GRUPO == "0002"
//    _cConta	:=	"132010002"          //123030001 Instalacoes
    _cConta	:=	"123030001"       // Instalacoes
ElseIf	SN1->N1_GRUPO	==	"0003"
//	_cConta :=	"132010003"          //123040001 Maquinas e equipamentos
	_cConta :=	"123040001"       // Maquinas e equipamentos
ElseIf SN1->N1_GRUPO $ "0004/0009"
//	_cConta :=	"132010004"	         //123050001 VEICULOS
	_cConta :=	"123050001"       // VEICULOS
ElseIf SN1->N1_GRUPO == "0005"
//	_cConta :=	"132010005"          //124010001 Marcas e Patentes
	_cConta :=	"124010001"       //Marcas e Patentes
ElseIf SN1->N1_GRUPO == "0008"
//	_cConta :=	"133010001"	         //124020001 Software para microcomputadores
	_cConta :=	"124020001"       // Software para microcomputadores
Endif	 	
	
RestArea(_aAreaAt)

Return(_cConta)