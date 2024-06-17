***********
* Debito    *
***********
user function deb_rh_contabil()

cConta := space(10)
cCateg := FDESC("SRA",SRZ->RZ_MAT,"RA_X_CATEG") 

if cCateg = "M" .and. FDESC("SRA",SRZ->RZ_MAT,"RA_X_COMIS")="S" //Se Mensalista e recebe comissao
 	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_DVEND")
	if trim(cConta) = ""                      
	   msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	   //msgalert("Conta nao encontrada verba="+SRZ->RZ_PD+"Conteudo campo RV_X_DVEND"+SRV->RV_X_DVEND+ " cCateg = "+ cCateg+ "FUNC."+SRZ->RZ_MAT)	
	endif  	
elseif cCateg = "P"
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_DPLAB")
	if trim(cConta) = ""
	   msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	   //msgalert("Conta nao encontrada verba="+SRZ->RZ_PD+"Conteudo campo RV_X_DPLAB"+SRV->VZ_X_DPLAB+ " cCateg = "+ cCateg+ "FUNC."+SRZ->RZ_MAT)	
	endif 	
elseif cCateg = "A"
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_DAUT")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	    //msgalert("Conta nao encontrada verba="+SRZ->RZ_PD+"Conteudo campo RV_X_DAUT"+SRV->RV_X_DAUT+ " cCateg = "+ cCateg+ "FUNC."+SRZ->RZ_MAT)	
	endif 	
elseif cCateg = "L"										//  ALTERACAO A SER EFETIVADA NA IMPLANTACAO DA NOVA CONTABILIDADE
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_DPLA2")
	if trim(cConta) = ""
	   msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	   //msgalert("Conta nao encontrada verba="+SRZ->RZ_PD+"Conteudo campo RV_X_DPLAB"+SRV->VZ_X_DPLAB+ " cCateg = "+ cCateg+ "FUNC."+SRZ->RZ_MAT)	
	endif 	
elseif cCateg = "B"										//  ALTERACAO A SER EFETIVADA NA IMPLANTACAO DA NOVA CONTABILIDADE
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_DAUT2")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	    //msgalert("Conta nao encontrada verba="+SRZ->RZ_PD+"Conteudo campo RV_X_DAUT"+SRV->RV_X_DAUT+ " cCateg = "+ cCateg+ "FUNC."+SRZ->RZ_MAT)	
	endif 	
else
    cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_DADM")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	    //msgalert("Conta nao encontrada verba="+SRZ->RZ_PD+"Conteudo campo RV_X_DADM"+SRV->RV_X_DADM+ " cCateg = "+cCateg+ "FUNC."+SRZ->RZ_MAT)	
	endif 	
endif


return(cConta)    

***********
* Credito   *
***********
user function cre_rh_contabil()

cConta := space(10)
cCateg := FDESC("SRA",SRZ->RZ_MAT,"RA_X_CATEG") 

if cCateg = "M" .and. FDESC("SRA",SRZ->RZ_MAT,"RA_X_COMIS")="S" //Se Mensalista e recebe comissao
 	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_CVEND")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	endif  	
elseif cCateg = "P"
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_CPLAB")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	endif 	
elseif cCateg = "A"
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_CAUT")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	endif 	
elseif cCateg = "L"  										//  ALTERACAO A SER EFETIVADA NA IMPLANTACAO DA NOVA CONTABILIDADE
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_CPLA2")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	endif 	
elseif cCateg = "B"                                      	//  ALTERACAO A SER EFETIVADA NA IMPLANTACAO DA NOVA CONTABILIDADE
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_CAUT2")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	endif 	
else
    cConta := FDESC("SRV",SRZ->RZ_PD,"RV_X_CADM")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada " + SRZ->RZ_PD+"-"+cCateg)	
	endif 	
endif

return(cConta)  

