#include "rwmake.ch"        

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矼T010INC  矨utor  �                       � Data �06.11.03   潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escricao 矨pos a Inclusao do Produto.                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       矼ultitek                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function MT010INC()
                  
If SB1->B1_IMPORT = "S"             
    DbSelectArea("SB1")
	If SB1->(RecLock("SB1",.F.))
  		SB1->(MSMM(SB1->B1_DESC_P ,36,,SB1->B1_DESC,1,,,"SB1","B1_DESC_P" ))  // Descr. Portugu阺
      SB1->(MSMM(SB1->B1_DESC_GI,48,,SB1->B1_DESC,1,,,"SB1","B1_DESC_GI"))  // Descr. LI
 	   SB1->(MSMM(SB1->B1_DESC_I ,48,,SB1->B1_DESC,1,,,"SB1","B1_DESC_I" ))  // Descr. Ingl阺
     	SB1->(MsUnlock())        
	Endif 
Endif		

RETURN

       