#include "rwmake.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
壁哪哪哪哪哪哪履哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目�
背 PROGRAMA   � MPL_004   � AUTOR � Anderson Kurtinaitis  � DATA � 18/02/04  潮
泵哪哪哪哪哪哪拍哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇�
背 Fun嘺o     � Gera Tela no padrao SIGA (com aROTINA) para manutencao da    潮
背            � do cadastro de EIS.                                          潮
背            � Usamos aRotina pois cliente tem intensao de efetuar algumas  潮
背            � validacoes,informacoes apos a inclusao/alteracao/exclusao.   潮
泵哪哪哪哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇�
背 Uso        � Especifico - Multi-Tek                                       潮
泵哪哪哪哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇�
背UpDate.....:                                                               潮
背Autor..... :                                                               潮
背Solicitante:                                                               潮
背Fun噭o.....:                                                               潮
崩哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
/*/


User Function MPL_004()       

aRotina := {{"Pesquisa"	,"AxPesqui"			, 0 , 1},;
            { "Manutencao"              	,'U_MPL_005("A")'	, 0 , 1}} // Deve ficar como visualizacao

DbSelectArea("Z10")
DbSetOrder(1)

cCADASTRO:= "Manutencao do Cadastro de EIS"

MBrowse( 6,1,22,75,"Z10",,,,,,)

Return()