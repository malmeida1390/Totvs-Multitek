#include "rwmake.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±
±³ PROGRAMA   ³ MPL_004   ³ AUTOR ³ Anderson Kurtinaitis  ³ DATA ³ 18/02/04  ³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±
±³ Fun‡ao     ³ Gera Tela no padrao SIGA (com aROTINA) para manutencao da    ³±
±³            ³ do cadastro de EIS.                                          ³±
±³            ³ Usamos aRotina pois cliente tem intensao de efetuar algumas  ³±
±³            ³ validacoes,informacoes apos a inclusao/alteracao/exclusao.   ³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³ Uso        ³ Especifico - Multi-Tek                                       ³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³UpDate.....:                                                               ³±
±³Autor..... :                                                               ³±
±³Solicitante:                                                               ³±
±³Fun‡„o.....:                                                               ³±
±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/


User Function MPL_004()       

aRotina := {{"Pesquisa"	,"AxPesqui"			, 0 , 1},;
            { "Manutencao"              	,'U_MPL_005("A")'	, 0 , 1}} // Deve ficar como visualizacao

DbSelectArea("Z10")
DbSetOrder(1)

cCADASTRO:= "Manutencao do Cadastro de EIS"

MBrowse( 6,1,22,75,"Z10",,,,,,)

Return()