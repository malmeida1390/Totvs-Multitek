#INCLUDE  "FIVEWIN.CH"
#INCLUDE  "TCBROWSE.CH"
#INCLUDE  "SIGA.CH"
#INCLUDE  "FONT.CH"
#INCLUDE  "COLORS.CH"
#INCLUDE  "VKEY.CH"

#DEFINE X_SIMIL			1


User Function AJUSTECB7()

             
DbSelectArea("SC9")
DbGotop()

While !SC9->(EOF())
	
	DbSelectArea("CB7")
	DbSetOrder(1)
	
	If DbSeek(SC9->C9_FILIAL+SC9->C9_ORDSEP)
		
		If EMPTY(CB7->CB7_NOTA)
			RecLock("CB7",.F.)
			CB7->CB7_NOTA := SC9->C9_NFISCAL
			CB7->CB7_SERIE:= SC9->C9_SERIENF
			MsUnlock()
		Endif
		
	Endif
	
	SC9->(DBSKIP())
	
Enddo
    
    

RETURN
