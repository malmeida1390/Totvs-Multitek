#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/07/00
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矨010TOK   矨utor  �                       � Data �06.11.03   潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escricao 砎alida gravacao do SB1                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       矼ultitek                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
/*
User Function A010TOK()
Local lRet:=.T.

If Empty(M->B1_POSIPI) .OR. M->B1_POSIPI <> '99999999'
	
	If !Empty(M->B1_CLASFIS)
		
		//
		// Caso o usuario escolha um N.C.M que esteja com a classificacao fiscal em
		// branco nao ira conseguir efetuar a inclusao/alteracao do produto.
		//
		
		Aviso("ATENCAO", "O campo Classificacao Fiscal esta em branco.",{"&Ok"})
		lRet:=.F.
		
	Endif
	
Endif

Return(lRet)
*/       
