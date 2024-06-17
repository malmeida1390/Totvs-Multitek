/*
Funcao...: NumProcAuto()
Autor....: Paulo Rogerio O. de Moraes
Cliente..: MULTITEK
Data.....: 31.08.2005
Objetivo.: Numerador automatico do processo de embarque/desembaraco, 
           de acordo com o ultimo registro do SW6
*/ 

//#include "eec.ch"
#include "topconn.ch"

*-------------------------* 
User Function NumProcAuto()
*-------------------------*
Local nUltNum  := Val(GetMV("MV_MTKPROC",,0))
Local cNovoNum := Strzero(nUltNum,6)      
                                               
SetMV("MV_MTKPROC",Alltrim(Str(nUltNum+1)))
 
Return cNovoNum 
