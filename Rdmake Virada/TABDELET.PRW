#include "rwmake.ch"
#include "topconn.ch"


USER FUNCTION DELTABELA


Private		aTabelas:={ "AF8010","SE1010","SE2010","CT2010","CT6010","CTC010","CTF010","SR4010",;
                                  "SE1020","SE2020","CT2020","CT6020","CTC020","CTF020","SR4020",; 
                                                                                               "CT6030","CTC030",;
                                                                                               "CT6040","CTC040",;
                                                                                               "CT6050","CTC050","CTF050","SRZ050", ;
                                                                                               "CT6060","CTC060","CTF060"}

//
// Estas tabelas deverao ser  importadas
//
IF MsgBox( "O programa deletar registro de varias tabelas." + chr(13) + chr(10) + "É recomendável que seja feito um backup!" + chr(13) + chr(10) + "Deseja continuar?", "Limpar", "YESNO" )
	
	
	IF MsgBox( "Tem certeza disto"+"Deseja continuar?", "Limpar", "YESNO" )
		

		For nY:= 1 to len(aTabelas)
       		 TCSQLExec( "DELETE FROM  "+aTabelas[nY] )
			 //TCSQLExec( "DELETE TABLE"+aTabelas[nY]+cEmpresa+" WHERE D_E_L_E_T_ = '*'")
			 // TCSQLExec( "UPDATE  "+aTabelas[nY]+cEmpresa+" SET  D_E_L_E_T_ = '*'")
		Next nY


	Endif
	
Endif

//
// Empresa 10
//
TCSQLExec( "DELETE FROM AE9010 WHERE R_E_C_N_O_ IN( 20, 19, 18, 17) ")
TCSQLExec( "DELETE FROM AF9010 WHERE R_E_C_N_O_ IN( 4144, 4143, 4186, 4185, 3937, 3936, 3968, 3966, 4053, 4052, 4190, 4188)  ")
TCSQLExec( "DELETE FROM AFC010 WHERE R_E_C_N_O_ IN( 3799, 2841, 2837, 2822, 3653, 3652, 3697, 3696, 2810, 2809, 2806, 2920, 2919, 2918, 3516, 3515, 3529 )") 
TCSQLExec( "DELETE FROM AFC010 WHERE R_E_C_N_O_ IN(3527, 3571, 3570, 3701, 3699, 2819, 7761, 2801, 2797, 3118, 3117, 2791, 9782, 2788, 3824, 3822, 3820, 3818, 3816, 3814, 3812, 3810, 3808, 3806, 3804, 3802, 3800, 3798)") 
TCSQLExec( "DELETE FROM AFC010 WHERE R_E_C_N_O_ IN(3796, 3795, 3794, 3792, 3790, 3788, 3786)  ")
TCSQLExec( "DELETE FROM AFE010 WHERE R_E_C_N_O_ IN( 2559, 2245, 2241, 2226, 2495, 3314, 2511, 2213, 2212, 2209, 2443, 2455, 2223, 2204, 2200, 2194, 2189) ")
TCSQLExec( "DELETE FROM AFX010 WHERE R_E_C_N_O_ IN( 2560, 2323, 2319, 2304, 2513, 2291, 2290, 2287, 2301, 2282, 2278, 2272, 2267) ")
TCSQLExec( "DELETE FROM SB1010 WHERE R_E_C_N_O_ IN( 2024) ")
TCSQLExec( "DELETE FROM SD8010 WHERE R_E_C_N_O_ IN( 47620, 47149) ")
TCSQLExec( "DELETE FROM AFA010 WHERE R_E_C_N_O_ IN( 8958) ")

//
// Empresa 20
//
TCSQLExec( "DELETE FROM SD2020 WHERE R_E_C_N_O_ IN( 12257, 12256, 12255, 12254, 12253, 12252, 12251, 12250, 12249, 12248, 12247, 12246, 12245) ")
TCSQLExec( "DELETE FROM SN3020 WHERE R_E_C_N_O_ IN( 3529, 3528, 3527, 3526, 3525, 3524, 3523, 3522, 3521, 3520, 3519, 3518, 3517, 3516, 3515, 3514) ")
TCSQLExec( "DELETE FROM SN3020 WHERE R_E_C_N_O_ IN(  3513, 3512, 3511, 3510, 3509, 3508, 3507, 3506, 3505, 3504, 3503, 3502, 3501, 3500, 3499, 3498, 3497, 3496, 3495, 3494, 3493, 3492, 3491, 3490, 3489, 3488, 3487) ")
TCSQLExec( "DELETE FROM SN3020 WHERE R_E_C_N_O_ IN(  3486, 3485, 3484, 3483, 3482, 3481, 3480, 3479, 3478, 3477, 3476, 3475, 3474, 3473, 3472, 3471, 3470, 3469, 3468, 3467, 3466, 3465, 3464, 3463, 3462, 3461, 3460) ")
TCSQLExec( "DELETE FROM SN3020 WHERE R_E_C_N_O_ IN(  3459, 3458, 3457, 3456, 3455, 3454, 3453, 3452, 3451, 3450, 3449, 3448, 3447, 3446, 3445, 3444, 3443, 3442, 3441, 3440, 3439, 3438, 3437, 3436, 3435, 3434, 3433) ") 
TCSQLExec( "DELETE FROM SN3020 WHERE R_E_C_N_O_ IN(  3432, 3431, 3430, 3429, 3428, 3427, 3426, 3425, 3424, 3423, 3422, 3421, 3420, 3419, 3418, 3417, 3416, 3415, 3414, 3413, 3412, 3411, 3410, 3409, 3408, 3407, 3406) ") 
TCSQLExec( "DELETE FROM SN3020 WHERE R_E_C_N_O_ IN(  3405, 3404, 3403, 3402, 3401, 3400, 3399, 3398, 3397, 3396, 3395, 3394, 3393, 3392, 3391, 3390, 3389, 3388, 3387, 3386, 3385, 3384, 3383, 3382, 3381, 3380, 3379) ") 
TCSQLExec( "DELETE FROM SN3020 WHERE R_E_C_N_O_ IN(  3378, 3377, 3376, 3375, 3374, 3373, 3372, 3371, 3370, 3369, 3368, 3367, 3366) ")
TCSQLExec( "DELETE FROM SR7020 WHERE R_E_C_N_O_ IN( 2354) ")
TCSQLExec( "DELETE FROM SRF020 WHERE R_E_C_N_O_ IN( 144, 167) ")



//
// Empresa 30
//
TCSQLExec( "DELETE FROM SC6030 WHERE R_E_C_N_O_ IN( 99) ")



Return




USER FUNCTION RECTABELA

//
// Estas tabelas deverao ser  importadas
//
IF MsgBox( "O programa deletar registro de varias tabelas." + chr(13) + chr(10) + "É recomendável que seja feito um backup!" + chr(13) + chr(10) + "Deseja continuar?", "Limpar", "YESNO" )
	
	
	IF MsgBox( "Tem certeza disto"+"Deseja continuar?", "Limpar", "YESNO" )
		
		aTabelas:={"AF8","SE1","SE2","CT2","CT6","CTC","CTF"}
		
		//
		//  Empresa 010
		//
		
		cEmpresa:="010"
		
		For nY:= 1 to len(aTabelas)
			TCSQLExec( "UPDATE  "+aTabelas[nY]+cEmpresa+" SET  D_E_L_E_T_ = ' '")
		Next nY
		
		cEmpresa:="020"
		
		For nY:= 1 to len(aTabelas)
			TCSQLExec( "UPDATE  "+aTabelas[nY]+cEmpresa+" SET  D_E_L_E_T_ = ' '")
		Next nY
		
		
	Endif
	
Endif

Return









USER FUNCTION LIMPADEL

IF MsgBox( "O programa ira limpar os registros deletados nas tabelas" + chr(13) + chr(10) + "Deseja continuar?", "Limpar", "YESNO" )
	
	// Abre o SX2 para ler o
	DbSelectArea( "SX2" )
	SX2->( DbGoTop() )
	WHILE SX2->( !Eof() )
		
		TCSQLExec( "DELETE TABLE "+SX2->X2_ARQUIVO+"WHERE  D_E_L_E_T_ = '*'")
		
		SX2->( DbSkip() )
	ENDDO
	
ENDIF

MS_FLUSH()

RETURN


/*
USER FUNCTION CLEAN

IF MsgBox( "O programa ira efetuar o drop em todas as tabelas." + chr(13) + chr(10) + "É recomendável que seja feito um backup!" + chr(13) + chr(10) + "Deseja continuar?", "Limpar", "YESNO" )
// Abre o SX2 para ler o
DbSelectArea( "SX2" )
SX2->( DbGoTop() )
WHILE SX2->( !Eof() )
TCSQLExec( "DROP TABLE " + SX2->X2_ARQUIVO )

SX2->( DbSkip() )
ENDDO

MsgBox( "Concluído!", "Cleaner", "INFO" )
ENDIF

MS_FLUSH()

RETURN
*/

